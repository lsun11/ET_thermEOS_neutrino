subroutine helmholtz_solver_binary_bhex_homosol(fnc,sou,pot)
  use phys_constant,  only : long
  use grid_parameter, only : nrg, npg, ntg
  use def_matter_parameter, only : ome
  use make_array_2d
  use make_array_3d
  use interface_sourceterm_exsurf_eqm_binary
  use interface_sourceterm_surface_int
  use interface_sourceterm_surface_int_homosol
  use interface_helmholtz_solver_binary_vol_int
  use interface_helmholtz_solver_binary_surf_int
  use interface_helmholtz_solver_outer_surf_int
  use interface_helmholtz_solver_bhex_surf_int
  implicit none
  real(long), pointer :: pot(:,:,:), sou(:,:,:), fnc(:,:,:)
  real(long), pointer :: sou_exsurf(:,:), dsou_exsurf(:,:)
  real(long), pointer :: sou_insurf(:,:), dsou_insurf(:,:)
  real(long), pointer :: sou_outsurf(:,:), dsou_outsurf(:,:)
  real(long), pointer :: pot_vol(:,:,:), pot_exsurf(:,:,:)
  real(long), pointer :: pot_insurf(:,:,:), pot_outsurf(:,:,:)
  real(long), pointer :: pot_integrals(:,:,:)
! 
  call alloc_array2d(sou_exsurf,0,ntg,0,npg)
  call alloc_array2d(dsou_exsurf,0,ntg,0,npg)
  call alloc_array2d(sou_insurf,0,ntg,0,npg)
  call alloc_array2d(dsou_insurf,0,ntg,0,npg)
  call alloc_array2d(sou_outsurf,0,ntg,0,npg)
  call alloc_array2d(dsou_outsurf,0,ntg,0,npg)
!
  call alloc_array3d(pot_vol,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot_exsurf,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot_insurf,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot_outsurf,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot_integrals,0,nrg,0,ntg,0,npg)
!
  call sourceterm_exsurf_eqm_binary(fnc,sou_exsurf,dsou_exsurf)
  call sourceterm_surface_int(fnc,0,sou_insurf,dsou_insurf)
  call sourceterm_surface_int(fnc,nrg,sou_outsurf,dsou_outsurf)
!
  call calc_radial_green_fn_hrethadv(ome)
  call helmholtz_solver_binary_vol_int(sou,pot_vol)
  call helmholtz_solver_binary_surf_int(sou_exsurf,dsou_exsurf,pot_exsurf)
  call helmholtz_solver_outer_surf_int(sou_outsurf,dsou_outsurf,pot_outsurf)
  pot_intgrals(0:nrg,0:ntg,0:npg) = pot_vol(0:nrg,0:ntg,0:npg)    &
                                & + pot_exsurf(0:nrg,0:ntg,0:npg) &
                                & + pot_outsurf(0:nrg,0:ntg,0:npg)
!
  call sourceterm_surface_int_homosol(pot_integrals,0,sou_insurf,dsou_insurf)
!  call helmholtz_solver_bhex_surf_int(sou_insurf,dsou_insurf,pot_insurf)
  call helmholtz_solver_surf_int(sou_insurf,dsou_insurf,pot_insurf)
  pot(0:nrg,0:ntg,0:npg) = pot_integrals(0:nrg,0:ntg,0:npg)  &
  &                      + pot_insurf(0:nrg,0:ntg,0:npg)
!
  deallocate(sou_exsurf)
  deallocate(dsou_exsurf)
  deallocate(sou_insurf)
  deallocate(dsou_insurf)
  deallocate(sou_outsurf)
  deallocate(dsou_outsurf)
!
  deallocate(pot_vol)
  deallocate(pot_exsurf)
  deallocate(pot_insurf)
  deallocate(pot_outsurf)
  deallocate(pot_integrals)
! 
end subroutine helmholtz_solver_binary_bhex_homosol
