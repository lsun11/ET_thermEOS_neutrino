include '../Subroutine/allocate_BBH_CF_AH.f90'
include '../Subroutine/allocate_horizon.f90'
include '../Subroutine/allocate_pBH_CF.f90'
include '../Subroutine/calc_AHarea_AHfinder.f90'
include '../Subroutine/calc_TrpBH.f90'
include '../Subroutine/calc_admmom_asympto.f90'
include '../Subroutine/calc_angmom_asympto.f90'
include '../Subroutine/calc_eqsolver_TrpBH.f90'
include '../Subroutine/calc_fnc_moment_asympto.f90'
include '../Subroutine/calc_mass_asympto.f90'
include '../Subroutine/calc_vector_bh.f90'
include '../Subroutine/calc_vector_phi_grav.f90'
include '../Subroutine/calc_vector_x_grav.f90'
include '../Subroutine/compute_fnc_inversion_index.f90'
include '../Subroutine/compute_wme2psi.f90'
include '../Subroutine/copy_Aij_pBH_to_tfkij.f90'
include '../Subroutine/copy_to_hgfn_and_gfnsf.f90'
include '../Subroutine/error_adjust_parameter.f90'
include '../Subroutine/error_metric_type0.f90'
include '../Subroutine/error_surface.f90'
include '../Subroutine/excurve.f90'
include '../Subroutine/excurve_CF_gridpoint_bhex.f90'
include '../Subroutine/grdr_gridpoint_type0.f90'
include '../Subroutine/grdr_gridpoint_type0_3rd_nosym.f90'
include '../Subroutine/grdr_gridpoint_type0_nosym.f90'
include '../Subroutine/grdtp_2Dsurf_midpoint_type0.f90'
include '../Subroutine/grgrad_4th_gridpoint_bhex.f90'
include '../Subroutine/grgrad_midpoint.f90'
include '../Subroutine/grgrad_midpoint_r3rd_type0.f90'
include '../Subroutine/initial_AHfinder.f90'
include '../Subroutine/interpo_linear_surface_type0.f90'
include '../Subroutine/interpo_linear_type0.f90'
include '../Subroutine/interpo_linear_type0_2Dsurf.f90'
include '../Subroutine/iteration_AHfinder.f90'
include '../Subroutine/minv.f90'
include '../Subroutine/outer_boundary_d_BBH_CF_pBH.f90'
include '../Subroutine/poisson_solver.f90'
include '../Subroutine/poisson_solver_AHfinder.f90'
include '../Subroutine/poisson_solver_asymptotic_patch_homosol.f90'
include '../Subroutine/poisson_solver_bhex_surf_int.f90'
include '../Subroutine/poisson_solver_binary_star_homosol.f90'
include '../Subroutine/poisson_solver_binary_surf_int.f90'
include '../Subroutine/poisson_solver_binary_vol_int.f90'
include '../Subroutine/printout_error.f90'
include '../Subroutine/printout_error_metric.f90'
include '../Subroutine/reset_bh_boundary_AH.f90'
include '../Subroutine/reset_outer_boundary_BBH_CF.f90'
include '../Subroutine/source_AHarea_AHfinder.f90'
include '../Subroutine/source_admmom_asympto.f90'
include '../Subroutine/source_angmom_asympto.f90'
include '../Subroutine/source_fnc_moment_asympto.f90'
include '../Subroutine/source_mass_asympto.f90'
include '../Subroutine/sourceterm_AHfinder.f90'
include '../Subroutine/sourceterm_HaC_CF_pBH.f90'
include '../Subroutine/sourceterm_exsurf_binary_parity.f90'
include '../Subroutine/sourceterm_surface_int_homosol.f90'
include '../Subroutine/sourceterm_trG_CF_pBH.f90'
include '../Subroutine/surf_int_grav_rg.f90'
include '../Subroutine/surf_int_grav_solidangle.f90'
include '../Subroutine/update_grfield.f90'
include '../Subroutine/update_surface.f90'
include '../Subroutine_mpatch/IO_input_initial_3D_CF_BH_mpt.f90'
include '../Subroutine_mpatch/IO_output_AHfinder_gnuplot_mpt.f90'
include '../Subroutine_mpatch/IO_output_plot_xyz_pBH_CF_mpt.f90'
include '../Subroutine_mpatch/IO_output_solution_3D_CF_BH_mpt.f90'
include '../Subroutine_mpatch/adjust_calc_fncval_Virial_Py_Mratio_mpt.f90'
include '../Subroutine_mpatch/adjust_copy_trpPunc_from_mpt.f90'
include '../Subroutine_mpatch/adjust_copy_trpPunc_to_mpt.f90'
include '../Subroutine_mpatch/adjust_multi_parameter_trpPunc_mpt.f90'
include '../Subroutine_mpatch/allocate_BBH_CF_AH_mpt.f90'
include '../Subroutine_mpatch/allocate_coordinate_patch_kit_grav_mpt.f90'
include '../Subroutine_mpatch/allocate_def_bh_parameter_mpt.f90'
include '../Subroutine_mpatch/allocate_def_quantities_bh_mpt.f90'
include '../Subroutine_mpatch/allocate_def_quantities_derived_mpt.f90'
include '../Subroutine_mpatch/allocate_def_quantities_mpt.f90'
include '../Subroutine_mpatch/allocate_def_vector_bh_mpt.f90'
include '../Subroutine_mpatch/allocate_def_vector_phi_mpt.f90'
include '../Subroutine_mpatch/allocate_def_vector_x_mpt.f90'
include '../Subroutine_mpatch/allocate_grid_parameter_binary_excision_mpt.f90'
include '../Subroutine_mpatch/allocate_grid_parameter_mpt.f90'
include '../Subroutine_mpatch/allocate_grid_points_asymptotic_patch_mpt.f90'
include '../Subroutine_mpatch/allocate_grid_points_binary_excision_mpt.f90'
include '../Subroutine_mpatch/allocate_grid_points_binary_in_asympto_mpt.f90'
include '../Subroutine_mpatch/allocate_horizon_mpt.f90'
include '../Subroutine_mpatch/allocate_legendre_fn_grav_mpt.f90'
include '../Subroutine_mpatch/allocate_metric_and_matter_mpt.f90'
include '../Subroutine_mpatch/allocate_mpatch_all_BBH_CF.f90'
include '../Subroutine_mpatch/allocate_pBH_CF_mpt.f90'
include '../Subroutine_mpatch/allocate_radial_green_fn_grav_mpt.f90'
include '../Subroutine_mpatch/allocate_trigonometry_grav_phi_mpt.f90'
include '../Subroutine_mpatch/allocate_weight_midpoint_binary_excision_mpt.f90'
include '../Subroutine_mpatch/allocate_weight_midpoint_fluid_mpt.f90'
include '../Subroutine_mpatch/allocate_weight_midpoint_grav_mpt.f90'
include '../Subroutine_mpatch/calc_physical_quantities_BBH_trpPunc_CF_mpt.f90'
include '../Subroutine_mpatch/compute_alps2wmeN_mpt.f90'
include '../Subroutine_mpatch/coordinate_patch_kit_grav_mpt.f90'
include '../Subroutine_mpatch/copy_coordinate_grav_extended_from_mpt.f90'
include '../Subroutine_mpatch/copy_coordinate_grav_extended_interpo_from_mpt.f90'
include '../Subroutine_mpatch/copy_coordinate_grav_extended_to_mpt.f90'
include '../Subroutine_mpatch/copy_coordinate_grav_phi_from_mpt.f90'
include '../Subroutine_mpatch/copy_coordinate_grav_phi_to_mpt.f90'
include '../Subroutine_mpatch/copy_coordinate_grav_r_from_mpt.f90'
include '../Subroutine_mpatch/copy_coordinate_grav_r_to_mpt.f90'
include '../Subroutine_mpatch/copy_coordinate_grav_theta_from_mpt.f90'
include '../Subroutine_mpatch/copy_coordinate_grav_theta_to_mpt.f90'
include '../Subroutine_mpatch/copy_def_bh_parameter_from_mpt.f90'
include '../Subroutine_mpatch/copy_def_bh_parameter_to_mpt.f90'
include '../Subroutine_mpatch/copy_def_binary_parameter_from_mpt.f90'
include '../Subroutine_mpatch/copy_def_binary_parameter_to_mpt.f90'
include '../Subroutine_mpatch/copy_def_horizon_from_mpt.f90'
include '../Subroutine_mpatch/copy_def_horizon_to_mpt.f90'
include '../Subroutine_mpatch/copy_def_metric_from_mpt.f90'
include '../Subroutine_mpatch/copy_def_metric_pBH_from_mpt.f90'
include '../Subroutine_mpatch/copy_def_metric_pBH_to_mpt.f90'
include '../Subroutine_mpatch/copy_def_metric_to_mpt.f90'
include '../Subroutine_mpatch/copy_def_quantities_bh_from_mpt.f90'
include '../Subroutine_mpatch/copy_def_quantities_bh_to_mpt.f90'
include '../Subroutine_mpatch/copy_def_quantities_derived_from_mpt.f90'
include '../Subroutine_mpatch/copy_def_quantities_derived_to_mpt.f90'
include '../Subroutine_mpatch/copy_def_quantities_from_mpt.f90'
include '../Subroutine_mpatch/copy_def_quantities_to_mpt.f90'
include '../Subroutine_mpatch/copy_def_vector_bh_from_mpt.f90'
include '../Subroutine_mpatch/copy_def_vector_bh_to_mpt.f90'
include '../Subroutine_mpatch/copy_def_vector_phi_from_mpt.f90'
include '../Subroutine_mpatch/copy_def_vector_phi_to_mpt.f90'
include '../Subroutine_mpatch/copy_def_vector_x_from_mpt.f90'
include '../Subroutine_mpatch/copy_def_vector_x_to_mpt.f90'
include '../Subroutine_mpatch/copy_from_mpatch_all_BBH_CF.f90'
include '../Subroutine_mpatch/copy_from_mpatch_exsurf_binary_COCP.f90'
include '../Subroutine_mpatch/copy_grid_parameter_binary_excision_from_mpt.f90'
include '../Subroutine_mpatch/copy_grid_parameter_binary_excision_interpo_from_mpt.f90'
include '../Subroutine_mpatch/copy_grid_parameter_binary_excision_to_mpt.f90'
include '../Subroutine_mpatch/copy_grid_parameter_from_mpt.f90'
include '../Subroutine_mpatch/copy_grid_parameter_interpo_from_mpt.f90'
include '../Subroutine_mpatch/copy_grid_parameter_to_mpt.f90'
include '../Subroutine_mpatch/copy_grid_points_asymptotic_patch_from_mpt.f90'
include '../Subroutine_mpatch/copy_grid_points_asymptotic_patch_to_mpt.f90'
include '../Subroutine_mpatch/copy_grid_points_binary_excision_from_mpt.f90'
include '../Subroutine_mpatch/copy_grid_points_binary_excision_to_mpt.f90'
include '../Subroutine_mpatch/copy_grid_points_binary_in_asympto_from_mpt.f90'
include '../Subroutine_mpatch/copy_grid_points_binary_in_asympto_to_mpt.f90'
include '../Subroutine_mpatch/copy_legendre_fn_grav_from_mpt.f90'
include '../Subroutine_mpatch/copy_legendre_fn_grav_to_mpt.f90'
include '../Subroutine_mpatch/copy_to_mpatch_all_BBH_CF.f90'
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
include '../Subroutine_mpatch/excurve_TrpBH_gridpoint_mpt.f90'
include '../Subroutine_mpatch/excurve_TrpBH_mpt.f90'
include '../Subroutine_mpatch/initial_metric_CF_pBH_mpt.f90'
include '../Subroutine_mpatch/interpo_gr2gr_4th_mpt.f90'
include '../Subroutine_mpatch/interpo_patch_to_active_patch_mpt.f90'
include '../Subroutine_mpatch/interpolation_fillup_binary_COCP.f90'
include '../Subroutine_mpatch/interpolation_fillup_binary_parity_mpt.f90'
include '../Subroutine_mpatch/iteration_BBH_CF_trpPunc_3mpt.f90'
include '../Subroutine_mpatch/next_solution_BBH_mpt.f90'
include '../Subroutine_mpatch/printout_physq_BBH_trpPunc_mpt.f90'
include '../Subroutine_mpatch/read_parameter_binary_excision_mpt.f90'
include '../Subroutine_mpatch/read_parameter_mpt.f90'
include '../Subroutine_mpatch/read_parameter_pbh_mpt.f90'
include '../Subroutine_mpatch/set_allocate_size_mpt.f90'
include '../Subroutine_mpatch/sourceterm_exsurf_binary_COCP_pBH.f90'
include '../Subroutine_mpatch/sourceterm_insurf_ARCP_from_COCP_pBH.f90'
include '../Subroutine_mpatch/sourceterm_insurf_asympto_interpo_from_mpt.f90'
include '../Subroutine_mpatch/sourceterm_outsurf_COCP_from_ARCP_pBH.f90'
include '../Subroutine_mpatch/sourceterm_outsurf_interpo_from_asympto_parity_mpt.f90'
include '../Subroutine_mpatch/update_coordinates_mpt.f90'
