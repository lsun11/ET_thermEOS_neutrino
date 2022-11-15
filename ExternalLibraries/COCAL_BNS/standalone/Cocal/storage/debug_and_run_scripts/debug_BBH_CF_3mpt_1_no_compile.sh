name_flag=N2
param_dir_name=../parameter_sample/BBH_CF_3mpt
work_dir_name=work_area_BBH

cd Cocal_debug

cp -rfp work_area_BNS ${work_dir_name}

cp executable_files/exe_BBH_CF      ${work_dir_name}/exe_bh_test
cp executable_files/exe_BBH_CF_plot ${work_dir_name}/exe_plot

cp ctrl_area_BBH/* ${work_dir_name}/.

cp -rfp ${work_dir_name} ${work_dir_name}_${name_flag}
      
cp ${param_dir_name}/${name_flag}/*.* ${work_dir_name}_${name_flag}/.

cd ${work_dir_name}_${name_flag}
#./exe_bh_test > output_${name_flag} &
./exe_bh_test

#cp ../${param_dir_name}/*.* .
#./exe_plot
cd ../../
