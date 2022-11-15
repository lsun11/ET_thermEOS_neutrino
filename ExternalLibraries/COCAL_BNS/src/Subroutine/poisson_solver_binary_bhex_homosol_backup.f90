subroutine poisson_solver_binary_bhex_homosol(char_bc,sou, &
           &                                      sou_exsurf,dsou_exsurf, &
           &                                      sou_insurf,dsou_insurf, &
           &                                     sou_outsurf,dsou_outsurf,pot)
  use phys_constant,  only : long
  use grid_parameter, only : nrg, npg, ntg
  use make_array_3d
  use interface_poisson_solver_binary_vol_int
  use interface_poisson_solver_binary_surf_int
  use interface_poisson_solver_bhex_surf_int
  use interface_sourceterm_surface_int_homosol
  use interface_copy_to_hgfn_and_gfnsf
  use radial_green_fn_grav_bhex_nb
  use radial_green_fn_grav_bhex_dh
  use radial_green_fn_grav_bhex_nh
  implicit none
  real(long), pointer :: pot(:,:,:), sou(:,:,:)
  real(long), pointer :: sou_exsurf(:,:), dsou_exsurf(:,:)
  real(long), pointer :: sou_insurf(:,:), dsou_insurf(:,:)
  real(long), pointer :: sou_outsurf(:,:), dsou_outsurf(:,:)
  real(long), pointer :: sou_iosurf(:,:,:)
  real(long), pointer :: pot_vol(:,:,:), pot_exsurf(:,:,:)
  real(long), pointer :: pot_insurf(:,:,:), pot_outsurf(:,:,:)
  real(long), pointer :: pot_integrals(:,:,:)
  character(len=2)    :: char_bc
! 
  call alloc_array3d(pot_vol,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot_exsurf,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot_insurf,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot_outsurf,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot_integrals,0,nrg,0,ntg,0,npg)
  call alloc_array3d(sou_iosurf,0,ntg,0,npg,1,4)
!
  call calc_hgfn_bhex_nb
  call copy_to_hgfn_and_gfnsf(hgfn_nb,gfnsf_nb)
  call poisson_solver_binary_vol_int(sou,pot_vol)
  call poisson_solver_binary_surf_int(sou_exsurf,dsou_exsurf,pot_exsurf)
!
  sou_iosurf(1:ntg,1:npg,1) = dsou_insurf(1:ntg,1:npg)
  sou_iosurf(1:ntg,1:npg,2) = sou_insurf(1:ntg,1:npg)
  call poisson_solver_bhex_surf_int('in',sou_iosurf,pot_insurf)
  sou_iosurf(1:ntg,1:npg,3) = dsou_outsurf(1:ntg,1:npg)
  sou_iosurf(1:ntg,1:npg,4) = sou_outsurf(1:ntg,1:npg)
  if (char_bc.eq.'dh') then 
    call calc_hgfn_bhex_dh
    call copy_to_hgfn_and_gfnsf(hgfn_dh,gfnsf_dh)
  end if  
  if (char_bc.eq.'nh') then 
    call calc_hgfn_bhex_nh
    call copy_to_hgfn_and_gfnsf(hgfn_nh,gfnsf_nh)
  end if
  call poisson_solver_bhex_surf_int('ou',sou_iosurf,pot_outsurf)
!
  pot_integrals(0:nrg,0:ntg,0:npg) = pot_vol(0:nrg,0:ntg,0:npg) &
                                 & + pot_exsurf(0:nrg,0:ntg,0:npg) &
                                 & + pot_insurf(0:nrg,0:ntg,0:npg) &
                                 & + pot_outsurf(0:nrg,0:ntg,0:npg)
!
  call sourceterm_surface_int_homosol(pot_integrals,0,sou_insurf,dsou_insurf)
  sou_iosurf(1:ntg,1:npg,1) = dsou_insurf(1:ntg,1:npg)
  sou_iosurf(1:ntg,1:npg,2) = sou_insurf(1:ntg,1:npg)
  call poisson_solver_bhex_surf_int('in',sou_iosurf,pot_insurf)
  pot(0:nrg,0:ntg,0:npg) = pot_integrals(0:nrg,0:ntg,0:npg) &
                       & + pot_insurf(0:nrg,0:ntg,0:npg)
!
  deallocate(pot_vol)
  deallocate(pot_exsurf)
  deallocate(pot_insurf)
  deallocate(pot_outsurf)
  deallocate(pot_integrals)
  deallocate(sou_iosurf)
! 
end subroutine poisson_solver_binary_bhex_homosol
