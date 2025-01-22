

#include <slepc/finclude/slepceps.h>

  Module module_slepc
   use slepceps
   implicit none
   real(8)         :: E(10)                                              ! 10 eigenvalues
   complex(8)      :: P(100,10)                                          ! 10 eigenvectors
  contains



    subroutine calc_AX                                                    ! solve AX=lX
      Mat            A
      Vec            x
      EPS            eps
      PetscInt       n, i, j, Istart, Iend
      PetscInt       nev,ncv,mpd,max_it
      PetscInt       row(1), col(100)
      PetscMPIInt    rank
      PetscErrorCode ierr
      PetscScalar    val(100),kr 
      PetscReal      tol
      PetscScalar, pointer    :: xx(:)

      n   = 100                                                           ! size of the matrix
      nev = 10                                                            ! number of the solutions
      ncv = 20                                                            ! working subspace
      mpd = 20                                                            ! working projections
      tol = 1.d-9                                                         ! accuracy of the solution
      max_it = 100                                                        ! max number of iterations

      PetscCallA(SlepcInitialize(PETSC_NULL_CHARACTER,"test",ierr))       ! initialize SLEPc
      PetscCallMPIA(MPI_Comm_rank(PETSC_COMM_WORLD,rank,ierr))            ! Initialize MPI processes
      PetscCallA(MatCreate(PETSC_COMM_WORLD,A,ierr))                      ! create matrix A
      PetscCallA(MatSetSizes(A,PETSC_DECIDE,PETSC_DECIDE,n,n,ierr))       ! set size of the matrix A (n x n)
      PetscCallA(MatSetFromOptions(A,ierr))                               ! type of matrix A (default MATAIJ)
      PetscCallA(MatGetOwnershipRange(A,Istart,Iend,ierr))                ! start to fill matrix A in parallel
      PetscCallA(MatCreateVecs(A,x,PETSC_NULL_VEC,ierr))                  ! create vector x for eigenvectors

      do i=Istart,Iend-1                                                  ! fill matrix A by rows
       row(1) = i                                                         ! row number - 1
       do j=1,n
        col(j) = j-1                                                      ! global indexes of A for part of the row
       enddo 
       call calc_A(row(1)+1,val,n)                                        ! calculate row A(i,:)
       PetscCallA(MatSetValues(A,1,row,n,col,val,INSERT_VALUES,ierr))     ! insert one row in A (it may be a part of the row)
      enddo                                                               !            (ADD_VALUES add to the matrix elements) 

      PetscCallA(MatAssemblyBegin(A,MAT_FINAL_ASSEMBLY,ierr))             ! MPI assembling of matrix A
      PetscCallA(MatAssemblyEnd(A,MAT_FINAL_ASSEMBLY,ierr))               !
      PetscCallA(EPSCreate(PETSC_COMM_WORLD,eps,ierr))                    ! create object EPS
      PetscCallA(EPSSetOperators(eps,A,PETSC_NULL_MAT,ierr))              ! set matrix A to EPS problem AX=lX
      PetscCallA(EPSSetProblemType(eps,EPS_HEP,ierr))                     ! Hermitian Hamiltonian
      PetscCallA(EPSSetWhichEigenpairs(eps,EPS_SMALLEST_MAGNITUDE,ierr))  ! calculate smallest eigenvalues
      PetscCallA(EPSSetType(eps,EPSKRYLOVSCHUR,ierr))                     ! Krylov-Schur method (default)
      PetscCallA(EPSSetFromOptions(eps,ierr))                             ! set all parameters for EPS
      PetscCallA(EPSSetDimensions(eps,nev,ncv,mpd,ierr))                  ! set number of eigenvalues to find (nev)
      PetscCallA(EPSSetTolerances(eps,tol,max_it,ierr))                   ! set max number of iterations and tolerance 
      PetscCallA(EPSSolve(eps,ierr))                                      ! solve AX = lX 

      do i=0,nev-1                                                        ! in SLEPc indexes start from zero
       PetscCallA(EPSGetEigenpair(eps,i,kr,PETSC_NULL_SCALAR,x,PETSC_NULL_VEC,ierr))          ! read solution i
       PetscCallA(VecGetArrayReadF90(x,xx,ierr))                          ! get access to Vec x
       if(rank==0) then
        E(i+1) = PetscRealPart(kr)                                        ! store eigenvalues
        P(1:100,i+1) = xx(1:100)                                          ! store eigenvectors
       endif
       PetscCallA(VecRestoreArrayReadF90(x,xx,ierr))                      ! restore Vec x
      enddo

      PetscCallA(EPSDestroy(eps,ierr))                                    ! destroy EPS object
      PetscCallA(VecDestroy(x,ierr))                                      ! destroy vector
      PetscCallA(MatDestroy(A,ierr))                                      ! destroy matrix
      PetscCallA(SlepcFinalize(ierr))                                     ! finalize SLEPc calculation
    end subroutine calc_AX



  subroutine calc_A(i,val,n)                                              ! calculate row i of matrix A: val(1:n) = A(i,1:n)
   integer    :: i
   integer    :: j
   integer    :: n
   complex(8) :: val(n)
   do j=1,n
    if(j==i) then
     val(j) = cmplx(i,0.d0,8)
    else
     val(j) = (0.d0,0.d0)
    endif 
   enddo 
  end subroutine calc_A


end Module module_slepc


