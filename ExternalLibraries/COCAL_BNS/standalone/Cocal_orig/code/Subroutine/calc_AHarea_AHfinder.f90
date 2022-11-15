subroutine calc_AHarea_AHfinder
  use phys_constant, only : long, pi
  use grid_parameter, only : ntg, npg
  use def_quantities_bh, only : AHarea, AHmass
  use interface_source_AHarea_AHfinder
  use interface_surf_int_grav_solidangle
  use make_array_2d
  implicit none
  real(long), pointer :: sou(:,:)
!  real(long) :: AHarea, AHmass
!
! --- Compute AH area.
  call alloc_array2d(sou,1,ntg,1,npg)
!
  call source_AHarea_AHfinder(sou)
  call surf_int_grav_solidangle(sou,AHarea)
  AHmass = dsqrt(AHarea/(16.0d0*pi))
!
  write(6,'(a11,1p,e15.7)') ' AH area = ', AHarea
  write(6,'(a11,1p,e15.7)') ' AH mass = ', AHmass
!
  deallocate(sou)
end subroutine calc_AHarea_AHfinder
