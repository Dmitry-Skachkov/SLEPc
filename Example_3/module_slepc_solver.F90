Module module_slepc_solver
#include <slepc/finclude/slepceps.h>
  use slepceps
  implicit none
contains
 
     subroutine slepc_solver(HX,EX,HE,NX,NE)
      Mat            HH
      Vec            xx
      EPS            eps
      PetscInt       ns, is, js, Istart, Iend
      PetscInt       nev,ncv,mpd,max_it
      PetscInt       row(1), col(8000)
      PetscMPIInt    rank
      PetscErrorCode ierr
      PetscScalar    H1(8000),kr 
      PetscReal      tols
      PetscLogDouble ts0,tsf
      PetscScalar, pointer    :: xxs(:)
      integer                 :: NX,NE
      complex(8)              :: HX(NX,NX)
      complex(8)              :: HE(NX,NE)
      real(8)                 :: EX(NE)
      ns   = NX                                                           ! size of the matrix
      nev  = NE                                                           ! number of the solutions
      mpd  = nev                                                          ! working projections (for small nev mpd=nev, for large nev mpd<<nev) 
      ncv  = nev + mpd                                                    ! working subspace
      tols = 1.d-8                                                        ! accuracy of the solution
      max_it = 150                                                        ! max number of iterations
      PetscCallA(SlepcInitialize(PETSC_NULL_CHARACTER,ierr))              ! initialize SLEPc
      PetscCallMPIA(MPI_Comm_rank(PETSC_COMM_WORLD,rank,ierr))            ! Initialize MPI processes
      PetscCallA(MatCreate(PETSC_COMM_WORLD,HH,ierr))                     ! create matrix HH
      PetscCallA(MatSetSizes(HH,PETSC_DECIDE,PETSC_DECIDE,ns,ns,ierr))    ! set size of the matrix HH (ns x ns)
      PetscCallA(MatSetFromOptions(HH,ierr))                              ! type of matrix HH (default MATAIJ)
      PetscCallA(MatGetOwnershipRange(HH,Istart,Iend,ierr))               ! start to fill matrix HH in parallel
      PetscCallA(MatCreateVecs(HH,xx,PETSC_NULL_VEC,ierr))                ! create vector xx for eigenvectors

      PetscCallA(PetscTime(ts0,ierr))
      do is=Istart,Iend-1                                                 ! fill Hamiltonian in parallel regime
       row(1) = is
       do js=1,ns
        col(js) = js-1
       enddo 
       do js=1,ns
        H1(js) = HX(is+1,js)
       enddo
       PetscCallA(MatSetValues(HH,1,row,ns,col,H1,INSERT_VALUES,ierr))     ! insert one row in HH (it may be a part of the row)
      enddo
      PetscCallA(MatAssemblyBegin(HH,MAT_FINAL_ASSEMBLY,ierr))             ! MPI assembling of matrix HH
      PetscCallA(MatAssemblyEnd(HH,MAT_FINAL_ASSEMBLY,ierr))               !
      PetscCallA(PetscTime(tsf,ierr))
      PetscCallA(PetscPrintf(PETSC_COMM_WORLD,'matrix assembling ',ierr))
      if(rank==0) print *,'calc time=',(tsf-ts0)

      PetscCallA(PetscTime(ts0,ierr))
      PetscCallA(EPSCreate(PETSC_COMM_WORLD,eps,ierr))                    ! create object EPS
      PetscCallA(EPSSetOperators(eps,HH,PETSC_NULL_MAT,ierr))             ! set matrix HH to EPS problem AX=lX
      PetscCallA(EPSSetProblemType(eps,EPS_HEP,ierr))                     ! Hermitian Hamiltonian
      PetscCallA(EPSSetWhichEigenpairs(eps,EPS_SMALLEST_MAGNITUDE,ierr))  ! calculate smallest eigenvalues
      PetscCallA(EPSSetType(eps,EPSKRYLOVSCHUR,ierr))                     ! Krylov-Schur method (default)
      PetscCallA(EPSSetFromOptions(eps,ierr))                             ! set all parameters for EPS
      PetscCallA(EPSSetDimensions(eps,nev,ncv,mpd,ierr))                  ! set number of eigenvalues to find (nev)
      PetscCallA(EPSSetTolerances(eps,tols,max_it,ierr))                  ! set max number of iterations and tolerance 
      PetscCallA(EPSMonitorSet(eps,MyEPSMonitor,0,PETSC_NULL_FUNCTION,ierr))    ! print iterations

      PetscCallA(EPSSolve(eps,ierr))                                      ! solve AX = lX 
      PetscCallA(PetscTime(tsf,ierr))
      PetscCallA(PetscPrintf(PETSC_COMM_WORLD,'solving ',ierr))
      if(rank==0) print *,'calc time=',(tsf-ts0)

      PetscCallA(PetscTime(ts0,ierr))
      do is=0,nev-1                                                       ! in SLEPc indexes start from zero
       PetscCallA(EPSGetEigenpair(eps,is,kr,PETSC_NULL_SCALAR,xx,PETSC_NULL_VEC,ierr))          ! read solution is
       PetscCallA(VecGetArrayReadF90(xx,xxs,ierr))                        ! get access to Vec xx
       if(rank==0) then
        EX(is+1) = PetscRealPart(kr)                                      ! store eigenvalues
        HX(1:ns,is+1) = xxs(1:ns)                                         ! store eigenvectors
       endif
       PetscCallA(VecRestoreArrayReadF90(xx,xxs,ierr))                    ! restore Vec xx
      enddo
      PetscCallA(PetscTime(tsf,ierr))
      PetscCallA(PetscPrintf(PETSC_COMM_WORLD,'extract solution ',ierr))
      if(rank==0) print *,'calc time=',(tsf-ts0)

      PetscCallA(EPSDestroy(eps,ierr))                                    ! destroy EPS object
      PetscCallA(VecDestroy(xx,ierr))                                     ! destroy vector
      PetscCallA(MatDestroy(HH,ierr))                                     ! destroy matrix
      PetscCallA(SlepcFinalize(ierr))                                     ! finalize SLEPc MPI calculation
     end subroutine slepc_solver



! --------------------------------------------------------------
!
!  MyEPSMonitor - This is a user-defined routine for monitoring the EPS iterative solvers.
!
!  Input Parameters:
!    eps   - eigensolver context
!    its   - iteration number
!    nconv - number of converged eigenpairs
!    eigr  - real part of the eigenvalues
!    eigi  - imaginary part of the eigenvalues
!    errest- relative error estimates for each eigenpair
!    nest  - number of error estimates
!    dummy - optional user-defined monitor context (unused here)
!
     subroutine MyEPSMonitor(eps,its,nconv,eigr,eigi,errest,nest,dummy,ierr)
      EPS            eps
      PetscErrorCode ierr
      PetscInt       its,nconv,nest,dummy
      PetscScalar    eigr(*),eigi(*)
      PetscReal      re,errest(*)
      PetscMPIInt    rank
      call MPI_Comm_rank(PETSC_COMM_WORLD,rank,ierr)
      if (its .gt. 0 .and. rank .eq. 0) then
        re = PetscRealPart(eigr(nconv+1))
        print 140,its,nconv+1,re,errest(nconv+1)
      endif
 140  format(i5,' EPS pair=',i4,' value (error) ',E15.4,' (',g10.3,')')
      ierr = 0
     end subroutine MyEPSMonitor



end Module module_slepc_solver




