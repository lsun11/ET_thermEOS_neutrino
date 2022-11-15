work_dir_name=work_area_RNS
array_dir=( C020 )

rm -rf Cocal_debug/code
cp -rfp ~/Cocal/code Cocal_debug/.
cd Cocal_debug

cd compile_scripts
sh select_grgrad_midpoint_r3rd_NS.sh
sh select_grgrad_gridpoint_4th_NS.sh
sh select_weight_calc_midpoint_grav_th4th.sh
sh compile_TOV.sh
sh compile_1Dini.sh
sh compile_Main_RNS_WL_peos.sh
sh compile_Main_RNS_WL_peos_plot.sh

cd ../
cp executable_files/exe_RNS_WL_peos  ./${work_dir_name}/.
cp executable_files/exe_RNS_WL_peos  ./${work_dir_name}/exe_mrns_test
cp executable_files/exe_RNS_WL_peos  ./${work_dir_name}_${array_dir[$i]}/.
cp executable_files/exe_RNS_WL_peos  ./${work_dir_name}_${array_dir[$i]}/exe_mrns_test

cd ../
