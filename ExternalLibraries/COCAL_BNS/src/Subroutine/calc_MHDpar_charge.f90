subroutine calc_MHDpar_charge
  use phys_constant, only : long
  use grid_parameter
  use def_metric,  only : alph, bvxu, bvyu, bvzu
  use def_matter_parameter, only : ome
  use def_emfield, only : va  , vaxd, vayd, vazd
  use integrability_fnc_MHD, only : MHDpar_charge
  use def_vector_phi, only : vec_phig
  implicit none
  real(long) :: At0, At_eq, Aphi_eq
  integer    :: flag_restmass, count_adj
!
! Match At and Aphi at the center
!center  At0 = - alph(0,0,0)*  va(0,0,0) + vaxd(0,0,0)*bvxu(0,0,0) &
!center  &     + vayd(0,0,0)*bvyu(0,0,0) + vazd(0,0,0)*bvzu(0,0,0)
!center  MHDpar_charge = At0
!
!! Match At and Aphi at the surface
  At_eq = - alph(nrf,ntgeq,0)*  va(nrf,ntgeq,0) &
  &       + vaxd(nrf,ntgeq,0)*bvxu(nrf,ntgeq,0) &
  &       + vayd(nrf,ntgeq,0)*bvyu(nrf,ntgeq,0) &
  &       + vazd(nrf,ntgeq,0)*bvzu(nrf,ntgeq,0)
  Aphi_eq = vayd(nrf,ntgeq,0)*vec_phig(nrf,ntgeq,0,2)
  MHDpar_charge = At_eq + ome*Aphi_eq
!
! Set electric charge to be zero.
!
end subroutine calc_MHDpar_charge
