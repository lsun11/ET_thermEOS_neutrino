program extrapolation
  implicit none
  integer :: i, k, n = 6
  real(8) :: xi(4),yi(4), yin(4,6), yex(4)
  real(8) :: v, x(2),y(2)
  real(8), external :: lagint_2nd
!  real(8) :: lagint_2nd
!
  open(1,file='data.dat',status='old')
  do i = 1, 4
    read(1,*) xi(i), (yin(i,k), k = 1, n)
  end do
  close(1)
!
  v = 0.0
!
  do k = 1, n
    yi(:) = yin(:,k)
    x(1:2) = xi(3:4)
    y(1:2) = yi(3:4)
    yex(k) = lagint_2nd(x,y,v)
  end do
!
  write(6,*) (yex(k), k = 1, n)
  open(1,file='output_2nd.dat',status='unknown')
  do i = 1, 4
    write(1,'(1p,9e18.10)')xi(i), & 
    &  (dabs(1.0d0 - yin(i,k)/yex(k))*100.0, k = 1, n)
  end do
  close(1)
  open(1,file='output.dat',status='unknown')
  do i = 1, 3
    write(1,'(1p,9e18.10)') &
    &  dsqrt((xi(i)/xi(4))**2 - 1.0d0)*xi(4), &
    &  (dabs(1.0d0 - yin(i,k)/yin(4,k))*100.0, k = 1, n)
  end do
  close(1)
!
end program extrapolation
!
function lagint_2nd(x,y,v)
  implicit none
  real(8) :: lagint_2nd
  real(8) :: x(2),y(2), v
  real(8) :: dx12, dx21
  real(8) :: xv1, xv2, wex1, wex2
!
      dx12 = x(1) - x(2)
      dx21 = - dx12
      xv1 = v - x(1)
      xv2 = v - x(2)
      wex1 = xv2/dx12
      wex2 = xv1/dx21
!
      lagint_2nd = wex1*y(1) + wex2*y(2)
!
end function lagint_2nd
