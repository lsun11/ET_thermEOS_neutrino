program simple_convtest
  implicit none
  integer :: i, k, n = 6, ndata
  real(8) :: xi(4),yi(4), yin(4,6), yex(4)
  real(8) :: v
  real(8), external :: lagint_4th
!
  read(5,*) ndata
write(6,*)ndata
  open(1,file='data.dat',status='old')
  do i = 1, ndata
    read(1,*) xi(i), (yin(i,k), k = 1, n)
  end do
  close(1)
!
  open(1,file='output.dat',status='unknown')
  do i = 1, ndata - 1
    write(1,'(1p,9e18.10)') &
    &  xi(i), & 
    &  (dabs(1.0d0 - yin(i,k)/yin(i+1,k))*100.0, k = 1, n)
  end do
  close(1)
!
end program simple_convtest
