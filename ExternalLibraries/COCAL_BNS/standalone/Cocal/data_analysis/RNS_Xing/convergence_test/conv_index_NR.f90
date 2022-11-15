program  conv_index_NR
  implicit none
  integer :: i, k, n = 6, iter, iter_max = 100, ndata = 5
  real(8) :: xi(5),yi(5), yin(5,6)
  real(8) :: dd, od(6), dd_old, delta_dd
  real(8) :: fx, delta_fx, logfx, delta_logfx, error
!
  open(1,file='data.dat',status='old')
  do i = 1, ndata
    read(1,*) xi(i), (yin(i,k), k = 1, n)
  end do
  close(1)
!
  do k = 1, n
    yi(:) = yin(:,k)
!
    dd = 2.0d0
    do iter = 1, iter_max
!
      fx = (yi(3)-yi(4))*xi(5)**dd &
      &  + (yi(5)-yi(3))*xi(4)**dd &
      &  + (yi(4)-yi(5))*xi(3)**dd
      delta_fx = (yi(3)-yi(4))*xi(5)**dd*dlog(xi(5)) &
      &        + (yi(5)-yi(3))*xi(4)**dd*dlog(xi(4)) &
      &        + (yi(4)-yi(5))*xi(3)**dd*dlog(xi(3))
      logfx = dlog(fx)
      delta_logfx = delta_fx/fx
!      delta_dd = - logfx/delta_logfx
      delta_dd = - fx/delta_fx
!
      dd_old = dd
      dd = dd + delta_dd
      error = dabs((dd_old - dd)/dd)
      write(6,*) 'error = ', error
      if (error.le.1.0d-10) then 
        write(6,*) 'iteration=', iter ; exit
      end if
!
    end do
    if (iter.eq.iter_max) stop 'iteration not converged'
!
    od(k) = dd
  end do
!
  write(6,*) (od(k), k = 1, n)
  open(1,file='output_index.dat',status='unknown')
    write(1,'(1p,9e18.10)') (od(k), k = 1, n)
  close(1)
!
end program conv_index_NR
