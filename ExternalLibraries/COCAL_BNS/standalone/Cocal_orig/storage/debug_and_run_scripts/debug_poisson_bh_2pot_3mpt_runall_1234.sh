name_flag=I
param_dir_name=../parameter_sample/bbh_3mpt
work_dir_name=work_area_poisson_test

rm -rf Cocal_debug
cp -rfp ~/Cocal Cocal_debug
cd Cocal_debug
cp -rfp work_area_BNS ${work_dir_name}

cd compile_scripts
sh select_3patch.sh
#sh select_grid_r_bhex.sh
sh select_grgrad_midpoint_r3rd_bhex.sh
sh select_grgrad_gridpoint_4th_bhex.sh
sh select_weight_calc_midpoint_grav_th4th.sh
#sh compile_debug_poisson_bh_2pot_3mpt.sh
#sh compile_debug_poisson_bh_2pot_mpt_plot.sh
sh compile_debug_poisson_bh_2pot_3mpt_test2.sh
sh compile_debug_poisson_bh_2pot_mpt_plot_test2.sh
cd ../
cp executable_files/exe_plot ${work_dir_name}/.
cp ctrl_area_BBH/* ${work_dir_name}/.

cp -rfp ${work_dir_name} ${work_dir_name}_${name_flag}1
cp -rfp ${work_dir_name} ${work_dir_name}_${name_flag}2
cp -rfp ${work_dir_name} ${work_dir_name}_${name_flag}3
cp -rfp ${work_dir_name} ${work_dir_name}_${name_flag}4
      
cp ${param_dir_name}/${name_flag}1/*.* ${work_dir_name}_${name_flag}1/.
cp ${param_dir_name}/${name_flag}2/*.* ${work_dir_name}_${name_flag}2/.
cp ${param_dir_name}/${name_flag}3/*.* ${work_dir_name}_${name_flag}3/.
cp ${param_dir_name}/${name_flag}4/*.* ${work_dir_name}_${name_flag}4/.

cd ${work_dir_name}_${name_flag}1
./exe_bh_test > output_${name_flag}1 &
cd ../${work_dir_name}_${name_flag}2
./exe_bh_test > output_${name_flag}2 &
cd ../${work_dir_name}_${name_flag}3
./exe_bh_test > output_${name_flag}3 &
cd ../${work_dir_name}_${name_flag}4
./exe_bh_test > output_${name_flag}4 &

#cp ../${param_dir_name}/*.* .
#./exe_plot
cd ../../
