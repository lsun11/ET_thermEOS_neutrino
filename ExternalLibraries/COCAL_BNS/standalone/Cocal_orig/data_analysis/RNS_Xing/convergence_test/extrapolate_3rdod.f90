program extrapolation
  implicit none
  integer :: i, k, n = 6
  real(8) :: xi(4),yi(4), yin(4,6), yex(4)
  real(8) :: v, x(3),y(3)
  real(8), external :: lagint_3rd
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
    x(1:3) = xi(2:4)
    y(1:3) = yi(2:4)
    yex(k) = lagint_3rd(x,y,v)
  end do
!
  write(6,*) (yex(k), k = 1, n)
  open(1,file='output_3rd.dat',status='unknown')
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
function lagint_3rd(x,y,v)
  implicit none
  real(8) :: lagint_3rd
  real(8) :: x(3),y(3), v
  real(8) :: dx12, dx21, dx13, dx31, dx23, dx32
  real(8) :: xv1, xv2, xv3, wex1, wex2, wex3
!
      dx12 = x(1) - x(2)
      dx13 = x(1) - x(3)
      dx23 = x(2) - x(3)
      dx21 = - dx12
      dx31 = - dx13
      dx32 = - dx23
      xv1 = v - x(1)
      xv2 = v - x(2)
      xv3 = v - x(3)
      wex1 = xv2*xv3/(dx12*dx13)
      wex2 = xv1*xv3/(dx21*dx23)
      wex3 = xv1*xv2/(dx31*dx32)
!
      lagint_3rd = wex1*y(1) + wex2*y(2) + wex3*y(3)
!
end function lagint_3rd
