program simple_convtest
  implicit none
  integer :: i, k, n = 6, ndata = 5
  real(8) :: xi(10),yi(10), yin(10,6)
!
  write(6,*)ndata
  open(1,file='data.dat',status='old')
  do i = 1, ndata
    read(1,*) xi(i), (yin(i,k), k = 1, n)
  end do
  close(1)
!
  open(1,file='output.dat',status='unknown')
  do i = 1, ndata - 2
    write(1,'(1p,9e18.10)') &
    &  xi(i), & 
    &  (dabs((yin(i+2,k) - yin(i,k))/yin(ndata,k))*100.0, k = 1, n)
  end do
  close(1)
!
end program simple_convtest
