subroutine initial_metric_CF_pBH
  use phys_constant, only  : long, pi
  use grid_parameter, only : nrg, ntg, npg, rgin, ntgxy, npgxzm
  use def_metric, only : psi, alph, alps, bvxd, bvyd, bvzd
  use def_metric_pBH, only : psi_trpBH, alph_trpBH
  implicit none
  integer    :: irg, itg, ipg
!
  call calc_TrpBH
  do ipg = 0, npg
    do itg = 0, ntg
      psi(0:nrg,itg,ipg) = psi_trpBH(0:nrg)
      alph(0:nrg,itg,ipg) = alph_trpBH(0:nrg)
    end do
  end do
  alps(0:nrg,0:ntg,0:npg) = alph(0:nrg,0:ntg,0:npg)*psi(0:nrg,0:ntg,0:npg)
  bvxd(0:nrg,0:ntg,0:npg) = 0.0d0
  bvyd(0:nrg,0:ntg,0:npg) = 0.0d0
  bvzd(0:nrg,0:ntg,0:npg) = 0.0d0
!
end subroutine initial_metric_CF_pBH
