subroutine current_sph2sfc_MHD
  use phys_constant, only  : long
  use def_emfield, only : jtuf, jxuf, jyuf, jzuf, jtu, jxu, jyu, jzu
  use interface_interpo_gr2fl
  implicit none
!
  call interpo_gr2fl(jtu, jtuf)
  call interpo_gr2fl(jxu, jxuf)
  call interpo_gr2fl(jyu, jyuf)
  call interpo_gr2fl(jzu, jzuf)
!
end subroutine current_sph2sfc_MHD
