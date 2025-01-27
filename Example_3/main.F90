
 program main
  use module_slepc_solver 
  integer, parameter      :: NX = 8000               ! size of Hamiltonian
  integer, parameter      :: NE = 100                ! number of solutions
  complex(8)              :: HX(NX,NX)               ! Hamiltonian matrix
  complex(8)              :: HE(NX,NE)               ! Eigenvectors
  real(8)                 :: EX(NE)                  ! Eigenvalues
  HX = (0.d0,0.d0)
  do j=1,NX
   do i=j,NX
!    HX(i,j) = (0.1d0,0.1d0)
    if(i==j) then
     HX(i,i) = cmplx(i,0.d0,8)
    endif 
   enddo
  enddo 
!  do j=1,NX
!   do i=1,j-1
!    HX(i,j) = conjg(HX(j,i))
!   enddo
!  enddo 
  call slepc_solver(HX,EX,HE,NX,NE)
  ! on exit eigenvectors HE(:,i), i=1,NE
  !         eigenvalues  EX(i),   i=1,NE
 end program main 
