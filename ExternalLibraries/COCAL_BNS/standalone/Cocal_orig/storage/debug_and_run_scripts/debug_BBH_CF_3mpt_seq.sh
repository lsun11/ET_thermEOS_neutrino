name_flag=H3
param_dir_name=../parameter_sample/BBH_CF_3mpt_seq
work_dir_name=work_area_BBH
array=( 08 09 10 11 12 13 14 15 16 17 18 19 20 )
array2=( 8.0d-02 9.0d-02 1.0d-01 1.1d-01 1.2d-01 1.3d-01 1.4d-01 1.5d-01 1.6d-01 1.7d-01 1.8d-01 1.9d-01 2.0d-01 )

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
sh compile_BBH_CF_3mpt.sh
sh compile_BBH_CF_3mpt_plot.sh

cd ../
cp executable_files/exe_BBH_CF      ${work_dir_name}/exe_bh_test
cp executable_files/exe_BBH_CF_plot ${work_dir_name}/exe_plot

cp ctrl_area_BBH/* ${work_dir_name}/.

i=0
while [ $i -lt `expr ${#array[*]}` ]
do
  cp -rfp ${work_dir_name} ${work_dir_name}_${name_flag}_ra0${array[$i]}
  cp ${param_dir_name}/${name_flag}/*.* ${work_dir_name}_${name_flag}_ra0${array[$i]}/.
  cd ${work_dir_name}_${name_flag}_ra0${array[$i]}
  sed -i "s!rginval!${array2[$i]}!" rnspar_mpt*.dat
  ./exe_bh_test > output_${name_flag}_ra0${array[$i]} &
  cd ../
  i=`expr $i + 1`
done

cd ../
