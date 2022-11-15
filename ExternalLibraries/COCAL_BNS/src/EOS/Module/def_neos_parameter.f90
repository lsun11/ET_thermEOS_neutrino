module def_neos_parameter
  use phys_constant         !nnpeos
  implicit none
  real(8) :: enei(0:nnneos), prei(0:nnneos), rhoi(0:nnneos), qi(0:nnneos), hi(0:nnneos)
  real(8) :: rhocgs(0:nnneos), precgs(0:nnneos), enecgs(0:nnneos)
  real(8) :: rhoini_cgs, rhoini_gcm1, emdini_gcm1  !used in TOV solver
  integer :: nphase
end module def_neos_parameter
