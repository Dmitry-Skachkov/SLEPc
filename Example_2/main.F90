

    program main
     use module_slepc
     call calc_AX                                 ! solve AX=lX for A 100x100
     call print_results                           ! print eigenvalues and eigenvectors
     call check_results                           ! check 10 solutions
    end program main



   subroutine print_results
    use module_slepc
    integer          :: i
    print 1
    do i =1,10
     print 2,i,E(i),P(1:100,i)
    enddo 
 1  format(' n   eigenvalue     eigenvector')
 2  format(I4,F12.4,4x,200E14.4)
   end subroutine print_results



   subroutine check_results                       ! check AX=lX for first 10 eigenvalues
    use module_slepc
    complex(8)       :: s
    complex(8)       :: AX(100),val(100),Axx
    integer          :: q,l,i
    logical          :: l_wrong,l_one
    l_one = .false.
    do q = 1,10
     l_wrong = .false.
     do i=1,100
      s = (0.d0,0.d0)
      do l=1,100
       call calc_A(l,val,100)                     ! calculate row l of matrix A
       Axx = val(i)                               ! take only element A(i,l)
       s = s + Axx*P(l,q)                         ! calculate sum A(i,l)*P(l,q)
      enddo
      AX(i) = s
      if(zabs(AX(i)-E(q)*P(i,q)) > 1.d-8) then    ! check i-component of AX-lX is zero or not, for i=1,100
       l_wrong = .true.
      endif
     enddo
     if(l_wrong) then
      print *,'solution q=',q,' is wrong'
      l_one = .true.
     endif 
    enddo 
    if(.not.l_one) print *,'all solutions are correct'
   end subroutine check_results



