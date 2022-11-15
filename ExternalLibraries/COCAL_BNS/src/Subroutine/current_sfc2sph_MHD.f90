subroutine current_sfc2sph_MHD
  use phys_constant, only  : long
  use def_emfield, only : jtuf, jxuf, jyuf, jzuf, jtu, jxu, jyu, jzu
  use interface_interpo_fl2gr
  implicit none
!
  call interpo_fl2gr(jtuf, jtu)
  call interpo_fl2gr(jxuf, jxu)
  call interpo_fl2gr(jyuf, jyu)
  call interpo_fl2gr(jzuf, jzu)
!
end subroutine current_sfc2sph_MHD
