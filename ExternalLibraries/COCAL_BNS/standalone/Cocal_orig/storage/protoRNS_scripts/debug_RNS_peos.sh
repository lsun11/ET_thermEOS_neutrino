name_flag=H2
rest_mass=1.60000E-00
param_dir_name=../parameter_sample/RNS_CF
work_dir_name=work_area_RNS
ctrl_dir_name=ctrl_area_RNS
#array_dir=( 01 02 )
#array_rho=( 5.59440e+14 5.72880e+14 )
#array_pre=( 2.22062e+34 2.41301e+34 )
array_dir=( 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 )
array_rho=(  5.60000e+14  5.74000e+14  5.88000e+14  6.02000e+14  6.16000e+14  6.30000e+14  6.44000e+14  6.58000e+14  6.72000e+14  6.86000e+14  7.00000e+14  7.14000e+14  7.28000e+14  7.42000e+14  7.56000e+14  7.70000e+14  7.84000e+14  7.98000e+14  8.12000e+14  8.26000e+14  8.40000e+14  )
array_pre=(  4.80653e+34  5.24041e+34  5.70157e+34  6.19101e+34  6.70975e+34  7.25881e+34  7.83924e+34  8.45209e+34  9.09842e+34  9.77930e+34  1.04958e+35  1.12491e+35  1.20402e+35  1.28703e+35  1.37404e+35  1.46518e+35  1.56056e+35  1.66029e+35  1.76449e+35  1.87328e+35  1.98679e+35  )

rm -rf Cocal_debug
cp -rfp ~/Cocal Cocal_debug
cd Cocal_debug

cd compile_scripts
sh select_grgrad_midpoint_r3rd_NS.sh
sh select_grgrad_gridpoint_4th_NS.sh
sh select_weight_calc_midpoint_grav_th4th.sh
sh compile_TOV.sh
sh compile_1Dini.sh
sh compile_Main_RNS_CF_peos.sh
sh compile_Main_RNS_CF_peos_plot.sh
cd ../

cp executable_files/exe_RNS_CF_peos  ${work_dir_name}/exe_rns_test
cp executable_files/exe_RNS_plot  ${work_dir_name}/exe_rns_plot

i=0
while [ $i -lt `expr ${#array_dir[*]}` ]
do
  cp ${param_dir_name}/${name_flag}/*.* ${work_dir_name}/.
  cp ${param_dir_name}/${name_flag}/*.* ${ctrl_dir_name}/.
  cd ctrl_area_RNS
  sed -i "s!restmass_val!${rest_mass}!" rnspar.dat
  sed -i "s!dividingRHO!${array_rho[$i]}!" peos_parameter.dat
  sed -i "s!dividingPRE!${array_pre[$i]}!" peos_parameter.dat
  sh calc-1_model_parameter.sh
  sh calc-2_update_rnspar.sh
  sh calc-3_1D_initial.sh
  sh calc-4_update_1D_initial.sh
  sh calc-5_prepare_work_area_RNS.sh 
  cd ../
  cp -rfp ${work_dir_name} ${work_dir_name}_EOS_${array_dir[$i]}
  cd ${work_dir_name}_EOS_${array_dir[$i]}/.
  (./exe_RNS_CF_peos > output_RNS_CF_peos ; \ 
   tail -n 50 rnsphyseq.dat > rns_parameter.las ) &
  cd ../
  i=`expr $i + 1`
done

cd ../
