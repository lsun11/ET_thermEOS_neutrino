subroutine surf_int_grav_rg_noweights(sousf,surf)
  use phys_constant, only  : long, nntg
  use grid_parameter, only    : ntg, npg
!  use coordinate_grav_r, only : rg
  use weight_midpoint_grav, only : wdtg
  use coordinate_grav_phi,     only : dphig
  implicit none
  real(long), pointer     ::  sousf(:,:)
  real(long), intent(out) ::  surf
  integer                 ::  itg, ipg
!
! The source contains all weights from determinant. Integration is only
! over dth, dphi.
  surf = 0.0d0
  do ipg = 1, npg
    do itg = 1, ntg
      surf = surf + sousf(itg,ipg)*wdtg(itg)*dphig      !*hwtpgsf(itg,ipg)
    end do
  end do
!
end subroutine surf_int_grav_rg_noweights
