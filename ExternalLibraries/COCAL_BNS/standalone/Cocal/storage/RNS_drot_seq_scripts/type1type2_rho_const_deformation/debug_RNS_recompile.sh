param_dir_name=../parameter_sample/RNS_CF
work_dir_name=work_area_RNS
ctrl_dir_name=ctrl_area_RNS
array_dir=( 016 )

rm -rf Cocal_debug/code
cp -rfp ~/Cocal/code Cocal_debug/.
cp -rfp ~/Cocal/compile_scripts Cocal_debug/.
cd Cocal_debug

cd compile_scripts
sh select_grgrad_midpoint_r3rd_NS.sh
sh select_grgrad_gridpoint_4th_NS.sh
sh select_weight_calc_midpoint_grav_th4th.sh
sh select_reset_fluid_radius_le_1.sh
sh select_correct_matter_source_out.sh
sh select_calc_surface_quad.sh
sh select_robust_convergence.sh
#sh select_surface_nrf_minus_2.sh
sh select_rotation_law_type1.sh
sh compile_TOV.sh
sh compile_1Dini.sh
sh compile_Main_RNS_CF_peos.sh
#sh compile_Main_RNS_CF_peos_plot.sh

cd ../
cp executable_files/exe_RNS_CF_peos  ./${work_dir_name}/.
cp executable_files/exe_RNS_CF_peos  ./${work_dir_name}_${array_dir[$i]}/.
#cp executable_files/exe_RNS_plot  ${work_dir_name}/.
#cp executable_files/exe_RNS_plot ./${work_dir_name}_${array_dir[$i]}/.

cd ../
