program extrapolation
  implicit none
  real(8) :: lagint_4th
  real(8) :: x(4),y(4), v
  real(8) :: dx12, dx13, dx14, dx23, dx24, dx34
  real(8) :: dx21, dx31, dx32, dx41, dx42, dx43
  real(8) :: xv1, xv2, xv3, xv4, wex1, wex2, wex3, wex4
  integer :: i
!
  open(1,file='data.dat',status='old')
  do i = 1, 4
    read(1,*) x(i),y(i)
  end do
  close(1)
  v = 0.0
!
      dx12 = x(1) - x(2)
      dx13 = x(1) - x(3)
      dx14 = x(1) - x(4)
      dx23 = x(2) - x(3)
      dx24 = x(2) - x(4)
      dx34 = x(3) - x(4)
      dx21 = - dx12
      dx31 = - dx13
      dx32 = - dx23
      dx41 = - dx14
      dx42 = - dx24
      dx43 = - dx34
      xv1 = v - x(1)
      xv2 = v - x(2)
      xv3 = v - x(3)
      xv4 = v - x(4)
      wex1 = xv2*xv3*xv4/(dx12*dx13*dx14) 
      wex2 = xv1*xv3*xv4/(dx21*dx23*dx24) 
      wex3 = xv1*xv2*xv4/(dx31*dx32*dx34) 
      wex4 = xv1*xv2*xv3/(dx41*dx42*dx43) 
!
      lagint_4th = wex1*y(1) + wex2*y(2) + wex3*y(3) + wex4*y(4)
!
  open(1,file='ouput.dat',status='unknown')
  do i = 1, 4
    write(1,*) x(i),dabs(y(i) - lagint_4th)
  end do
  close(1)
!
end program extrapolation
