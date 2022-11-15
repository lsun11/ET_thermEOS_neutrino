subroutine helmholtz_solver_binary(sou,sou_surf,dsou_surf,pot)
  use phys_constant,  only : long
  use grid_parameter, only : nrg, npg, ntg
  use def_matter_parameter, only : ome
  use make_array_3d
  use interface_helmholtz_solver_binary_surf_int
  use interface_helmholtz_solver_binary_vol_int
  implicit none
  real(long), pointer :: pot(:,:,:), sou(:,:,:)
  real(long), pointer :: sou_surf(:,:), dsou_surf(:,:)
  real(long), pointer :: pot_vol(:,:,:), pot_surf(:,:,:)
! 
  call alloc_array3d(pot_vol,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot_surf,0,nrg,0,ntg,0,npg)
!
  call calc_radial_green_fn_hrethadv(ome)
  call helmholtz_solver_binary_vol_int(sou,pot_vol)
  call helmholtz_solver_binary_surf_int(sou_surf,dsou_surf,pot_surf)
  pot(0:nrg,0:ntg,0:npg) = pot_vol(0:nrg,0:ntg,0:npg) &
  &                      + pot_surf(0:nrg,0:ntg,0:npg)
!
  deallocate(pot_vol)
  deallocate(pot_surf)
! 
end subroutine helmholtz_solver_binary
