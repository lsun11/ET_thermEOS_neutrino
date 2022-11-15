subroutine IO_output_AHfinder_gnuplot
  use phys_constant, only : long, pi
  use coordinate_grav_theta, only  : thg
  use coordinate_grav_phi, only  : phig
  use def_horizon, only : ahz
  use grid_parameter, only : npg, ntg, ntgxy, npgyzp, npgyzm, npgxzp, npgxzm
  use trigonometry_grav_theta
  use trigonometry_grav_phi
  implicit none
  integer :: ipg, itg
!
! --- Apparent horizon.
  open(13,file='bbhahz_gnuplot.las',status='unknown')
!  write(13,'(5i5)') ntg, npg
  do ipg = 0, npg
    do itg = 0, ntg
      write(13,'(1p,6e20.12)') phig(ipg), thg(itg)-0.5d0*pi, ahz(itg,ipg)
    end do
    write(13,'(1x)') 
  end do
  close(13)
!
  open(13,file='bbhahz_gnuplot_xy.las',status='unknown')
  itg = ntgxy
  do ipg = 0, npg
    write(13,'(1p,6e20.12)') ahz(itg,ipg)*sinthg(itg)*cosphig(ipg), &
    &                        ahz(itg,ipg)*sinthg(itg)*sinphig(ipg)
  end do
  close(13)
!
  open(13,file='bbhahz_gnuplot_yz.las',status='unknown')
  ipg = npgyzp
  do itg = 0, ntg-1
    write(13,'(1p,6e20.12)') ahz(itg,ipg)*sinthg(itg)*sinphig(ipg), &
    &                        ahz(itg,ipg)*costhg(itg)
  end do
  ipg = npgyzm
  do itg = ntg, 0, -1
    write(13,'(1p,6e20.12)') ahz(itg,ipg)*sinthg(itg)*sinphig(ipg), &
    &                        ahz(itg,ipg)*costhg(itg)
  end do
  close(13)
!
  open(13,file='bbhahz_gnuplot_xz.las',status='unknown')
  ipg = npgxzp
  do itg = 0, ntg-1
    write(13,'(1p,6e20.12)') ahz(itg,ipg)*sinthg(itg)*cosphig(ipg), &
    &                        ahz(itg,ipg)*costhg(itg)
  end do
  ipg = npgxzm
  do itg = ntg, 0, -1
    write(13,'(1p,6e20.12)') ahz(itg,ipg)*sinthg(itg)*cosphig(ipg), &
    &                        ahz(itg,ipg)*costhg(itg)
  end do
  close(13)
!
end subroutine IO_output_AHfinder_gnuplot
