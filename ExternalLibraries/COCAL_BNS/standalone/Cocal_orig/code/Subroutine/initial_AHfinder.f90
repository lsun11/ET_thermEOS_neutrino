subroutine initial_AHfinder
  use phys_constant, only  : long, pi
  use grid_parameter, only : ntg, npg
  use def_horizon, only : ahz
  integer    :: itg, ipg
!
  ahz(0:ntg,0:npg) = 0.4d0
!
end subroutine initial_AHfinder
