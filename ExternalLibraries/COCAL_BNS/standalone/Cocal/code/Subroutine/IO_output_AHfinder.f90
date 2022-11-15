subroutine IO_output_AHfinder
  use def_horizon, only : ahz
  use grid_parameter, only : npg, ntg
  implicit none
  integer :: ipg, itg
!
! --- Apparent horizon.
  open(13,file='bbhahz.las',status='unknown')
  write(13,'(5i5)') ntg, npg
  do ipg = 0, npg
    do itg = 0, ntg
      write(13,'(1p,6e20.12)') ahz(itg,ipg)
    end do
  end do
  close(13)
!
end subroutine IO_output_AHfinder
