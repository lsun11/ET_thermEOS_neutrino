subroutine helmholtz_solver_asymptotic_patch_homosol_outgoing &
&                             (sou,sou_insurf,dsou_insurf,pot)
  use phys_constant,  only : long
  use grid_parameter, only : nrg, npg, ntg
  use def_matter_parameter, only : ome
  use make_array_2d
  use make_array_3d
  use radial_green_fn_hrethadv
  use radial_green_fn_hret_mi_hadv
  use radial_green_fn_hrethadv_homosol
  use radial_green_fn_hret_mi_hadv_homosol
  use interface_sourceterm_surface_int
  use interface_sourceterm_surface_int_homosol
  use interface_copy_to_bsjy_and_sbsjy
  use interface_helmholtz_solver_vol_int
  use interface_helmholtz_solver_vol_int_hret_mi_hadv
  use interface_helmholtz_solver_surf_int
  use interface_helmholtz_solver_surf_int_hret_mi_hadv
  use interface_helmholtz_solver_outer_surf_int
  implicit none
  real(long), pointer :: pot(:,:,:), sou(:,:,:)
  real(long), pointer :: sou_insurf(:,:), dsou_insurf(:,:)
  real(long), pointer :: sou_outsurf(:,:), dsou_outsurf(:,:)
  real(long), pointer :: pot_vol(:,:,:),    pot_outsurf(:,:,:)
  real(long), pointer :: pot_insurf_hr_pl_ha(:,:,:)
  real(long), pointer :: pot_insurf_hr_mi_ha(:,:,:)
  real(long), pointer :: pot_integrals(:,:,:)
  real(long), pointer :: pot_vol_hret_pl_hadv(:,:,:)
  real(long), pointer :: pot_vol_hret_mi_hadv(:,:,:)
  integer :: irg, itg, ipg
!
  call alloc_array2d(sou_outsurf,0,ntg,0,npg)
  call alloc_array2d(dsou_outsurf,0,ntg,0,npg)
!
  call alloc_array3d(pot_vol,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot_insurf_hr_pl_ha,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot_insurf_hr_mi_ha,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot_outsurf,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot_integrals,0,nrg,0,ntg,0,npg)
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
  pot_integrals(0:nrg,0:ntg,0:npg) = pot_vol_hret_pl_hadv(0:nrg,0:ntg,0:npg) &
  &                                + pot_vol_hret_mi_hadv(0:nrg,0:ntg,0:npg)
!
  call sourceterm_surface_int_homosol(pot_integrals,0,sou_insurf,dsou_insurf)
  call calc_radial_green_fn_hrethadv_homosol(ome,'dh')
  call copy_to_bsjy_and_sbsjy(bsjy_hrha,sbsjy_hrha_ho,sbsjyp_hrha_ho)
  call helmholtz_solver_surf_int(sou_insurf,dsou_insurf,pot_insurf_hr_pl_ha)
  call calc_radial_green_fn_hret_mi_hadv_homosol(ome,'dh')
  call copy_to_bsjy_and_sbsjy(bsjy_hrmiha,sbsjy_hrmiha_ho,sbsjyp_hrmiha_ho)
  call helmholtz_solver_surf_int_hret_mi_hadv(sou_insurf,dsou_insurf, &
  &                                                     pot_insurf_hr_mi_ha)
!
  pot(0:nrg,0:ntg,0:npg) = pot_integrals(0:nrg,0:ntg,0:npg)  &
  &                      + pot_insurf_hr_pl_ha(0:nrg,0:ntg,0:npg) &
  &                      + pot_insurf_hr_mi_ha(0:nrg,0:ntg,0:npg)
!
  deallocate(sou_outsurf)
  deallocate(dsou_outsurf)
!
  deallocate(pot_vol)
  deallocate(pot_insurf_hr_pl_ha)
  deallocate(pot_insurf_hr_mi_ha)
  deallocate(pot_outsurf)
  deallocate(pot_integrals)
!
  deallocate(pot_vol_hret_pl_hadv)
  deallocate(pot_vol_hret_mi_hadv)
! 
end subroutine helmholtz_solver_asymptotic_patch_homosol_outgoing
