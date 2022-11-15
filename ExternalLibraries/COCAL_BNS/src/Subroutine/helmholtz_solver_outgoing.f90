subroutine helmholtz_solver_outgoing(sou,pot)
  use phys_constant,  only : long
  use grid_parameter, only : nrg, npg, ntg
  use def_matter_parameter, only : ome
  use make_array_3d
  use radial_green_fn_hrethadv
  use radial_green_fn_hret_mi_hadv
  use interface_copy_to_bsjy_and_sbsjy
  use interface_helmholtz_solver_vol_int
  use interface_helmholtz_solver_vol_int_hret_mi_hadv
  implicit none
  real(long), pointer :: pot(:,:,:), sou(:,:,:)
  real(long), pointer :: pot_vol_hret_pl_hadv(:,:,:)
  real(long), pointer :: pot_vol_hret_mi_hadv(:,:,:)
! 
  call alloc_array3d(pot_vol_hret_pl_hadv,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot_vol_hret_mi_hadv,0,nrg,0,ntg,0,npg)
!
  call calc_radial_green_fn_hrethadv(ome)
  call copy_to_bsjy_and_sbsjy(bsjy_hrha,sbsjy_hrha,sbsjyp_hrha)
  call helmholtz_solver_vol_int(sou,pot_vol_hret_pl_hadv)
  call calc_radial_green_fn_hret_mi_hadv(ome)
  call copy_to_bsjy_and_sbsjy(bsjy_hrmiha,sbsjy_hrmiha,sbsjyp_hrmiha)
  call helmholtz_solver_vol_int_hret_mi_hadv(sou,pot_vol_hret_mi_hadv)
! gives   - 4 pi sum m omega Y Y j j = i/2(Gout - Gin)
!
  pot(0:nrg,0:ntg,0:npg) = pot_vol_hret_pl_hadv(0:nrg,0:ntg,0:npg) &
  &                      + pot_vol_hret_mi_hadv(0:nrg,0:ntg,0:npg)
!
  deallocate(pot_vol_hret_pl_hadv)
  deallocate(pot_vol_hret_mi_hadv)
! 
end subroutine helmholtz_solver_outgoing
