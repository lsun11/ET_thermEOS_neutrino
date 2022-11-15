subroutine poisson_solver_binary_star_homosol(char_bc,sou, &
           &                                      sou_exsurf,dsou_exsurf, &
           &                                     sou_outsurf,dsou_outsurf,pot)
  use phys_constant,  only : long
  use grid_parameter, only : nrg, npg, ntg, npgxzm, npgxzp, ntgeq
  use make_array_3d
  use interface_poisson_solver_binary_vol_int
  use interface_poisson_solver_binary_surf_int
  use interface_poisson_solver_bhex_surf_int
  use interface_sourceterm_surface_int_homosol
  use interface_copy_to_hgfn_and_gfnsf
  use radial_green_fn_grav_bhex_sd
  use radial_green_fn_grav_bhex_nb
  implicit none
!
  real(long), pointer :: pot(:,:,:), sou(:,:,:)
  real(long), pointer :: sou_exsurf(:,:), dsou_exsurf(:,:)
  real(long), pointer :: sou_outsurf(:,:), dsou_outsurf(:,:)
  real(long), pointer :: sou_iosurf(:,:,:)
  real(long), pointer :: pot_vol(:,:,:), pot_exsurf(:,:,:)
  real(long), pointer :: pot_outsurf(:,:,:)
  real(long), pointer :: pot_integrals(:,:,:)
  character(len=2)    :: char_bc
  integer :: irg
! 
  call alloc_array3d(pot_vol,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot_exsurf,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot_outsurf,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot_integrals,0,nrg,0,ntg,0,npg)
  call alloc_array3d(sou_iosurf,0,ntg,0,npg,1,4)
!
  call calc_hgfn_bhex_nb
  call copy_to_hgfn_and_gfnsf(hgfn_nb,gfnsf_nb)
  call poisson_solver_binary_vol_int(sou,pot_vol)
!
  call poisson_solver_binary_surf_int(sou_exsurf,dsou_exsurf,pot_exsurf)
!
  pot_integrals(0:nrg,0:ntg,0:npg) = pot_vol(0:nrg,0:ntg,0:npg) &
                                 & + pot_exsurf(0:nrg,0:ntg,0:npg)
!
  if (char_bc.eq.'sd') then
    call calc_hgfn_bhex_sd
    call copy_to_hgfn_and_gfnsf(hgfn_sd,gfnsf_sd)
  end if
!
  call sourceterm_surface_int_homosol(pot_integrals,nrg,sou_outsurf, &
  &                                                    dsou_outsurf)
  sou_iosurf(1:ntg,1:npg,3) = dsou_outsurf(1:ntg,1:npg)
  sou_iosurf(1:ntg,1:npg,4) = sou_outsurf(1:ntg,1:npg)
  call poisson_solver_bhex_surf_int('ou',sou_iosurf,pot_outsurf)
!
  pot(0:nrg,0:ntg,0:npg) = pot_integrals(0:nrg,0:ntg,0:npg) &
                       & + pot_outsurf(0:nrg,0:ntg,0:npg)
!
  deallocate(pot_vol)
  deallocate(pot_exsurf)
  deallocate(pot_outsurf)
  deallocate(pot_integrals)
  deallocate(sou_iosurf)
! 
end subroutine poisson_solver_binary_star_homosol
