subroutine IO_input_initial_3D_CF_BH
  use phys_constant, only : long, nnrg, nntg, nnpg
  use def_metric, only : alph, psi, bvxd, bvyd, bvzd
!  use def_bh_parameter, only : ome_bh, spin_bh, alph_bh
  use coordinate_grav_r, only : rg
  use coordinate_grav_theta, only : thg
  use coordinate_grav_phi, only : phig 
  implicit none
  integer :: ir, it, ip, nrtmp, nttmp, nptmp
  real(long) :: rgtmp(0:nnrg), thgtmp(0:nntg), phigtmp(0:nnpg)
  real(long) ::  ome_tmp, spin_tmp, alph_tmp
!
! --- Metric potentials.
  open(13,file='bbhgra_3D.ini',status='old')
  read(13,'(5i5)') nrtmp, nttmp, nptmp
  do ip = 0, nptmp
    do it = 0, nttmp
      do ir = 0, nrtmp
        read(13,'(1p,6e20.12)')  psi(ir,it,ip), &
    &                           alph(ir,it,ip), &
    &                           bvxd(ir,it,ip), &
    &                           bvyd(ir,it,ip), &
    &                           bvzd(ir,it,ip)
      end do
    end do
  end do
  read(13,'(1p,6e20.12)') ome_tmp, spin_tmp, alph_tmp
  close(13)
!
! --- Coordinate grids.
  open(14,file='bbhgrids_3D.ini',status='old')
  read(14,'(5i5)') nrtmp, nttmp, nptmp
  do ir = 0, nrtmp
    read(14,'(1p,6e20.12)') rgtmp(ir)
  end do
  do it = 0, nttmp
    read(14,'(1p,6e20.12)') thgtmp(it)
  end do
  do ip = 0, nptmp
    read(14,'(1p,6e20.12)') phigtmp(ip)
  end do
  close(14)
!
end subroutine IO_input_initial_3D_CF_BH
