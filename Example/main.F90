

    program main
     use one
     real(8)    :: t0,tf
     call cpu_time(t0)
     call calc_matr
     call cpu_time(tf)
     print *,'calc time =',tf-t0,' s'
    end program main

