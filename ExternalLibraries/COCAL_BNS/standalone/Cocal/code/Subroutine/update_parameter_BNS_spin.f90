subroutine update_parameter_BNS_spin(conv_den)
  use grid_parameter, only : EQ_point, nrf_deform, nrf
  use def_matter_parameter, only : ROT_LAW
  use interface_update_parameter_BNS_peos_spin
  use interface_update_parameter_axisym_peos
  use interface_update_parameter_triaxial_peos
  use interface_update_parameter_spherical_peos
  use interface_update_parameter_axisym_peos_drot
  implicit none
  real(8), intent(in) :: conv_den
  if (ROT_LAW.eq.'DR') then 
    call update_parameter_axisym_peos_drot(conv_den)
  else 
    call update_parameter_BNS_peos_spin(conv_den)

!    if (EQ_point.eq.'XZ'.and.nrf.ne.nrf_deform) &
!    &                     call update_parameter_axisym_peos(conv_den)
!    if (EQ_point.eq.'XY') call update_parameter_triaxial_peos(conv_den)
!    if (EQ_point.eq.'XZ'.and.nrf.eq.nrf_deform) &
!    &                     call update_parameter_spherical_peos(conv_den)
  end if
end subroutine update_parameter_BNS_spin
