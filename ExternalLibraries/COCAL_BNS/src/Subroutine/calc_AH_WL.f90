subroutine calc_AH_WL
  use phys_constant, only  : long, pi
  use grid_parameter, only : ntg, npg
  use def_quantities, only : admmass_asymp, app_hor_area_bh, irredmass, &
       &                     bindingene, christmass, angmom_asymp
  use interface_source_AHarea_WL
  use interface_surf_int_grav_rg
  use make_array_2d
  implicit none
  real(long) :: surf, spinpar
  real(long), pointer :: sousf(:,:)
!
  call alloc_array2d(sousf,0,ntg,0,npg)
!
  call source_AHarea_WL(sousf)          ! contains the weights
  call surf_int_grav_rg_noweights(sousf,surf)
  app_hor_area_bh = surf
  irredmass = dsqrt(app_hor_area_bh/(16.0d0*pi))    

  bindingene = admmass_asymp - irredmass

  spinpar = angmom_asymp/(irredmass*irredmass)
  christmass = irredmass*dsqrt(1.0d0 + spinpar*spinpar/4.0d0)
!
  deallocate(sousf)
end subroutine calc_AH_WL
