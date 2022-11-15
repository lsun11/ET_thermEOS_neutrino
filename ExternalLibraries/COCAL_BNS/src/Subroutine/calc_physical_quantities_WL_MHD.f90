subroutine calc_physical_quantities_WL_MHD
  implicit none
!
  call interpo_gr2fl_metric_WL
  call SEM_tensor
  call SEM_tensor_EMF
!
  call calc_rest_mass_peos
  call calc_mass_WL_MHD
  call calc_proper_mass_peos
  call calc_ang_mom_WL_MHD
  call calc_charge_MHD
  call calc_ToverW_peos  ! to compute I_inertia
  call calc_virial_WL_MHD
  call calc_EMenergy_axisym_WL
  call calc_radius_WL
  call calc_redblue_shift_WL
!
  call excurve_WL_gridpoint
  call calc_mass_asympto('ns')
  call calc_angmom_asympto('ns')
  call calc_charge_asympto('ns')
!
  call calc_quad_pole_peos
  call calc_physq_center_peos
  call calc_physq_cgs_peos
  call calc_enthalpy_xyzaxis
end subroutine calc_physical_quantities_WL_MHD
