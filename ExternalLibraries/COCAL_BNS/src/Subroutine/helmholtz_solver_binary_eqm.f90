subroutine helmholtz_solver_binary_eqm(fnc,sou,pot)
  use phys_constant,  only : long
  use grid_parameter, only : nrg, npg, ntg
  use def_matter_parameter, only : ome
  use radial_green_fn_hrethadv
  use make_array_2d
  use make_array_3d
  use interface_copy_to_bsjy_and_sbsjy
  use interface_sourceterm_exsurf_eqm_binary
  use interface_sourceterm_outsurf_eqm_binary
  use interface_helmholtz_solver_binary_vol_int
  use interface_helmholtz_solver_binary_surf_int
  use interface_helmholtz_solver_outer_surf_int
  implicit none
  real(long), pointer :: pot(:,:,:), sou(:,:,:), fnc(:,:,:)
  real(long), pointer :: sou_exsurf(:,:), dsou_exsurf(:,:)
  real(long), pointer :: sou_outsurf(:,:), dsou_outsurf(:,:)
  real(long), pointer :: pot_vol(:,:,:),pot_exsurf(:,:,:),pot_outsurf(:,:,:)
! 
  call alloc_array3d(pot_vol,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot_exsurf,0,nrg,0,ntg,0,npg)
  call alloc_array2d(sou_exsurf,0,ntg,0,npg)
  call alloc_array2d(dsou_exsurf,0,ntg,0,npg)
  call alloc_array3d(pot_outsurf,0,nrg,0,ntg,0,npg)
  call alloc_array2d(sou_outsurf,0,ntg,0,npg)
  call alloc_array2d(dsou_outsurf,0,ntg,0,npg)
!
  call calc_radial_green_fn_hrethadv(ome)
  call copy_to_bsjy_and_sbsjy(bsjy_hrha,sbsjy_hrha,sbsjyp_hrha)
  call sourceterm_exsurf_eqm_binary(fnc,sou_exsurf,dsou_exsurf)
  call sourceterm_outsurf_eqm_binary(fnc,sou_outsurf,dsou_outsurf)
  call helmholtz_solver_binary_vol_int(sou,pot_vol)
  call helmholtz_solver_binary_surf_int(sou_exsurf,dsou_exsurf,pot_exsurf)
  call helmholtz_solver_outer_surf_int(sou_outsurf,dsou_outsurf,pot_outsurf)
  pot(0:nrg,0:ntg,0:npg) = pot_vol(0:nrg,0:ntg,0:npg)    &
  &                      + pot_exsurf(0:nrg,0:ntg,0:npg) !test &
!test  &                      + pot_outsurf(0:nrg,0:ntg,0:npg)
!
  deallocate(pot_vol)
  deallocate(pot_exsurf)
  deallocate(sou_exsurf)
  deallocate(dsou_exsurf)
  deallocate(pot_outsurf)
  deallocate(sou_outsurf)
  deallocate(dsou_outsurf)
! 
end subroutine helmholtz_solver_binary_eqm
