include '../Subroutine/allocate_metric_CF.f90'
include '../Subroutine/allocate_matter.f90'
include '../Subroutine/allocate_matter_velocity.f90'
include '../Subroutine/allocate_metric_on_SFC_CF.f90'
include '../Subroutine/calc_admmom_asympto.f90'
include '../Subroutine/calc_angmom_asympto.f90'
include '../Subroutine/calc_ang_mom_peos.f90'
include '../Subroutine/calc_ang_mom_peos_irrot.f90'
include '../Subroutine/calc_ang_mom_peos_spin.f90'
include '../Subroutine/calc_circ_line_peos.f90'
include '../Subroutine/calc_circ_line_peos_irrot.f90'
include '../Subroutine/calc_circ_line_peos_spin.f90'
include '../Subroutine/calc_circ_surf_peos.f90'
include '../Subroutine/calc_circ_surf_peos_irrot.f90'
include '../Subroutine/calc_circ_surf_peos_spin.f90'
include '../Subroutine/calc_dx_vec.f90'
include '../Subroutine/calc_enthalpy_xyzaxis.f90'
include '../Subroutine/calc_gradvep.f90'
include '../Subroutine/calc_gradvep_export.f90'
include '../Subroutine/calc_mass_peos.f90'
include '../Subroutine/calc_mass_peos_irrot.f90'
include '../Subroutine/calc_mass_peos_spin.f90'
include '../Subroutine/calc_mass_asympto.f90'
include '../Subroutine/calc_omega_drot.f90'
include '../Subroutine/calc_omega_drot_bisection.f90'
include '../Subroutine/calc_physq_center_peos.f90'
include '../Subroutine/calc_physq_center_peos_grid.f90'
include '../Subroutine/calc_physq_cgs_peos.f90'
include '../Subroutine/calc_proper_mass_peos.f90'
include '../Subroutine/calc_proper_mass_peos_irrot.f90'
include '../Subroutine/calc_proper_mass_peos_spin.f90'
include '../Subroutine/calc_qua_loc_spin_out.f90'
include '../Subroutine/calc_quad_pole_peos.f90'
include '../Subroutine/calc_radius_CF_rsurf.f90'
include '../Subroutine/calc_redblue_shift.f90'
include '../Subroutine/calc_rest_mass_peos.f90'
include '../Subroutine/calc_rest_mass_peos_irrot.f90'
include '../Subroutine/calc_rest_mass_peos_spin.f90'
include '../Subroutine/calc_soundspeed_peos.f90'
include '../Subroutine/calc_surface.f90'
include '../Subroutine/calc_ToverW_peos.f90'
include '../Subroutine/calc_vector_phi_grav.f90'
include '../Subroutine/calc_vector_x_grav.f90'
include '../Subroutine/calc_vector_phi_matter.f90'
include '../Subroutine/calc_vector_x_matter.f90'
include '../Subroutine/excurve_CF.f90'
include '../Subroutine/excurve_CF_gridpoint.f90'
include '../Subroutine/excurve_CF_gridpoint_bhex.f90'
include '../Subroutine/excurve_CF_gridpoint_export.f90'
include '../Subroutine/flgrad_2nd_gridpoint.f90'
include '../Subroutine/flgrad_2nd_gridpoint_export.f90'
include '../Subroutine/flgrad_4th_gridpoint.f90'
include '../Subroutine/flgrad_midpoint_type0_meridian.f90'
include '../Subroutine/flgrad_midpoint_type0_parallel.f90'
include '../Subroutine/grgrad_4th_gridpoint.f90'
include '../Subroutine/grgrad_4th_gridpoint_bhex.f90'
include '../Subroutine/grgrad_gridpoint.f90'
include '../Subroutine/grgrad_gridpoint_bhex.f90'
include '../Subroutine/grdr_gridpoint_type0_nosym.f90'
include '../Subroutine/grgrad_midpoint_r3rd_nsbh.f90'
include '../Subroutine/grgrad_midpoint_r3rd_type0_ns.f90'
include '../Subroutine/grgrad_midpoint_r3rd_type0_bh.f90'
include '../Subroutine/interpo_lag4th_2Dsurf.f90'
include '../Subroutine/interpo_fl2gr.f90'
include '../Subroutine/interpo_gr2fl.f90'
include '../Subroutine/interpo_gr2fl_type0.f90'
include '../Subroutine/interpo_gr2fl_export.f90'
include '../Subroutine/interpo_gr2fl_metric_CF.f90'
include '../Subroutine/interpo_gr2fl_metric_CF_export.f90'
include '../Subroutine/interpo_radial1p_grav.f90'
include '../Subroutine/interpo_linear1p_type0_2Dsurf.f90'
include '../Subroutine/interpo_linear_surface_type0.f90'
include '../Subroutine/interpo_linear_type0.f90'
include '../Subroutine/interpo_linear_type0_2Dsurf.f90'
include '../Subroutine/line_int_fluid.f90'
include '../Subroutine/plane_surf_int_fluid.f90'
include '../Subroutine/printout_NS_shape_seq.f90'
include '../Subroutine/radial_int_fluid.f90'
include '../Subroutine/reset_fluid_gradvep.f90'
include '../Subroutine/search_emdmax_xaxis.f90'
include '../Subroutine/search_emdmax_xaxis_grid.f90'
include '../Subroutine/source_adm_mass_peos.f90'
include '../Subroutine/source_adm_mass_peos_irrot.f90'
include '../Subroutine/source_adm_mass_peos_spin.f90'
include '../Subroutine/source_ang_mom_asymp.f90'
include '../Subroutine/source_admmom_asympto.f90'
include '../Subroutine/source_ang_mom_peos.f90'
include '../Subroutine/source_ang_mom_peos_irrot.f90'
include '../Subroutine/source_ang_mom_peos_spin.f90'
include '../Subroutine/source_angmom_asympto.f90'
include '../Subroutine/source_circ_line_peos.f90'
include '../Subroutine/source_circ_line_peos_irrot.f90'
include '../Subroutine/source_circ_line_peos_spin.f90'
include '../Subroutine/source_circ_line_peos_shift.f90'
include '../Subroutine/source_circ_surf_peos.f90'
include '../Subroutine/source_circ_surf_peos_irrot.f90'
include '../Subroutine/source_circ_surf_peos_spin.f90'
include '../Subroutine/source_komar_mass_compact_peos.f90'
include '../Subroutine/source_komar_mass_compact_peos_irrot.f90'
include '../Subroutine/source_komar_mass_compact_peos_spin.f90'
include '../Subroutine/source_komar_mass_peos.f90'
include '../Subroutine/source_komar_mass_peos_irrot.f90'
include '../Subroutine/source_komar_mass_peos_spin.f90'
include '../Subroutine/source_mass_asympto.f90'
include '../Subroutine/source_mp_minus_madm_peos.f90'
include '../Subroutine/source_proper_mass_peos.f90'
include '../Subroutine/source_proper_mass_peos_irrot.f90'
include '../Subroutine/source_proper_mass_peos_spin.f90'
include '../Subroutine/source_qua_loc_spin_out.f90'
include '../Subroutine/source_quad_pole_peos.f90'
include '../Subroutine/source_rest_mass_peos.f90'
include '../Subroutine/source_rest_mass_peos_irrot.f90'
include '../Subroutine/source_rest_mass_peos_spin.f90'
include '../Subroutine/surf_int_grav.f90'
include '../Subroutine/surf_int_grav_rg.f90'
include '../Subroutine/vol_int_fluid.f90'
include '../Subroutine/vol_int_grav.f90'
include '../Subroutine/IO_input_CF_grav_export.f90'
include '../Subroutine/IO_input_CF_flco_export.f90'
include '../Subroutine/IO_input_CF_flir_export.f90'
include '../Subroutine/IO_input_CF_flsp_export.f90'
include '../Subroutine/IO_input_CF_surf_export.f90'
include '../Subroutine/IO_output_3D_general.f90'
include '../Subroutine/IO_output_2D_general.f90'
include '../Subroutine/IO_output_1D_general.f90'

include '../Subroutine_mpatch/IO_input_converged_solution_3D_CF_NS_mpt.f90'
include '../Subroutine_mpatch/IO_input_converged_solution_3D_CF_irrot_NS_mpt.f90'
include '../Subroutine_mpatch/IO_input_converged_solution_3D_CF_spin_NS_mpt.f90'
include '../Subroutine_mpatch/allocate_coordinate_patch_kit_grav_mpt.f90'
include '../Subroutine_mpatch/allocate_def_bh_parameter_mpt.f90'
include '../Subroutine_mpatch/allocate_def_matter_parameter_mpt.f90'
!include '../Subroutine_mpatch/allocate_def_quantities_bh_mpt.f90'
!include '../Subroutine_mpatch/allocate_def_quantities_ns_mpt.f90'
include '../Subroutine_mpatch/allocate_def_quantities_derived_mpt.f90'
include '../Subroutine_mpatch/allocate_def_quantities_mpt.f90'
!include '../Subroutine_mpatch/allocate_def_vector_bh_mpt.f90'
include '../Subroutine_mpatch/allocate_def_vector_phi_mpt.f90'
include '../Subroutine_mpatch/allocate_def_vector_x_mpt.f90'
include '../Subroutine_mpatch/allocate_grid_parameter_binary_excision_mpt.f90'
include '../Subroutine_mpatch/allocate_grid_parameter_mpt.f90'
include '../Subroutine_mpatch/allocate_grid_points_asymptotic_patch_mpt.f90'
include '../Subroutine_mpatch/allocate_grid_points_binary_excision_mpt.f90'
include '../Subroutine_mpatch/allocate_legendre_fn_grav_mpt.f90'
!include '../Subroutine_mpatch/allocate_legendre_fn_irbns_grav_mpt.f90'
include '../Subroutine_mpatch/allocate_metric_CF_mpt.f90'
include '../Subroutine_mpatch/allocate_matter_mpt.f90'
include '../Subroutine_mpatch/allocate_matter_velocity_mpt.f90'
!include '../Subroutine_mpatch/allocate_metric_and_matter_mpt.f90'
include '../Subroutine_mpatch/allocate_mpatch_all_BNS_CF.f90'
include '../Subroutine_mpatch/allocate_radial_green_fn_grav_mpt.f90'
include '../Subroutine_mpatch/allocate_trigonometry_grav_phi_mpt.f90'
include '../Subroutine_mpatch/allocate_weight_midpoint_binary_excision_mpt.f90'
include '../Subroutine_mpatch/allocate_weight_midpoint_fluid_mpt.f90'
include '../Subroutine_mpatch/allocate_weight_midpoint_fluid_sphcoord_mpt.f90'
include '../Subroutine_mpatch/allocate_weight_midpoint_grav_mpt.f90'
include '../Subroutine_mpatch/copy_coordinate_grav_extended_from_mpt.f90'
include '../Subroutine_mpatch/copy_coordinate_grav_extended_to_mpt.f90'
include '../Subroutine_mpatch/copy_coordinate_grav_phi_from_mpt.f90'
include '../Subroutine_mpatch/copy_coordinate_grav_phi_to_mpt.f90'
include '../Subroutine_mpatch/copy_coordinate_grav_r_from_mpt.f90'
include '../Subroutine_mpatch/copy_coordinate_grav_r_to_mpt.f90'
include '../Subroutine_mpatch/copy_coordinate_grav_theta_from_mpt.f90'
include '../Subroutine_mpatch/copy_coordinate_grav_theta_to_mpt.f90'
!include '../Subroutine_mpatch/copy_def_bh_parameter_from_mpt.f90'
!include '../Subroutine_mpatch/copy_def_bh_parameter_to_mpt.f90'
include '../Subroutine_mpatch/copy_def_matter_parameter_from_mpt.f90'
include '../Subroutine_mpatch/copy_def_matter_parameter_to_mpt.f90'
include '../Subroutine_mpatch/copy_def_peos_parameter_from_mpt.f90'
include '../Subroutine_mpatch/copy_def_peos_parameter_to_mpt.f90'
include '../Subroutine_mpatch/copy_def_binary_parameter_from_mpt.f90'
include '../Subroutine_mpatch/copy_def_binary_parameter_to_mpt.f90'
include '../Subroutine_mpatch/copy_def_metric_from_mpt.f90'
include '../Subroutine_mpatch/copy_def_metric_to_mpt.f90'
include '../Subroutine_mpatch/copy_def_matter_from_mpt.f90'
include '../Subroutine_mpatch/copy_def_matter_to_mpt.f90'
include '../Subroutine_mpatch/copy_def_metric_and_matter_from_mpt.f90'
include '../Subroutine_mpatch/copy_def_metric_and_matter_to_mpt.f90'
!include '../Subroutine_mpatch/copy_def_quantities_ns_from_mpt.f90'
!include '../Subroutine_mpatch/copy_def_quantities_ns_to_mpt.f90'
include '../Subroutine_mpatch/copy_def_quantities_derived_from_mpt.f90'
include '../Subroutine_mpatch/copy_def_quantities_derived_to_mpt.f90'
include '../Subroutine_mpatch/copy_def_quantities_BNS_from_mpt.f90'
include '../Subroutine_mpatch/copy_def_quantities_BNS_to_mpt.f90'
!include '../Subroutine_mpatch/copy_from_mpatch_all_BNS_CF.f90'
include '../Subroutine_mpatch/copy_grid_parameter_binary_excision_from_mpt.f90'
include '../Subroutine_mpatch/copy_grid_parameter_binary_excision_to_mpt.f90'
include '../Subroutine_mpatch/copy_grid_parameter_from_mpt.f90'
include '../Subroutine_mpatch/copy_grid_parameter_to_mpt.f90'
include '../Subroutine_mpatch/copy_grid_points_asymptotic_patch_to_mpt.f90'
include '../Subroutine_mpatch/copy_grid_points_binary_excision_from_mpt.f90'
include '../Subroutine_mpatch/copy_grid_points_binary_excision_to_mpt.f90'
!include '../Subroutine_mpatch/copy_to_mpatch_all_BNS_CF.f90'
include '../Subroutine_mpatch/copy_trigonometry_grav_phi_from_mpt.f90'
include '../Subroutine_mpatch/copy_trigonometry_grav_phi_to_mpt.f90'
include '../Subroutine_mpatch/copy_trigonometry_grav_theta_from_mpt.f90'
include '../Subroutine_mpatch/copy_trigonometry_grav_theta_to_mpt.f90'
include '../Subroutine_mpatch/copy_weight_midpoint_binary_excision_from_mpt.f90'
include '../Subroutine_mpatch/copy_weight_midpoint_binary_excision_to_mpt.f90'
include '../Subroutine_mpatch/copy_weight_midpoint_fluid_from_mpt.f90'
include '../Subroutine_mpatch/copy_weight_midpoint_fluid_to_mpt.f90'
include '../Subroutine_mpatch/copy_weight_midpoint_grav_from_mpt.f90'
include '../Subroutine_mpatch/copy_weight_midpoint_grav_to_mpt.f90'
include '../Subroutine_mpatch/printout_physq_BNS_all_mpt.f90'
include '../Subroutine_mpatch/printout_physq_BNS_plot_mpt.f90'
include '../Subroutine_mpatch/printout_NS_shape_mpt.f90'
!include '../Subroutine_mpatch/read_parameter_bh_mpt.f90'
include '../Subroutine_mpatch/read_parameter_binary_excision_mpt.f90'
include '../Subroutine_mpatch/read_parameter_mpt.f90'
include '../Subroutine_mpatch/read_surf_parameter_mpt.f90'
include '../Subroutine_mpatch/set_allocate_size_mpt.f90'

