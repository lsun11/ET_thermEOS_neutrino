name_flag=H2
rest_mass=2.20000E-00
param_dir_name=../parameter_sample/RNS_CF
work_dir_name=work_area_RNS
ctrl_dir_name=ctrl_area_RNS

array_dir=( 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 )
array_rho=(  7.00000e+14  7.14000e+14  7.28000e+14  7.42000e+14  7.56000e+14  7.70000e+14  7.84000e+14  7.98000e+14  8.12000e+14  8.26000e+14  8.40000e+14  8.54000e+14  8.68000e+14  8.82000e+14  8.96000e+14  9.10000e+14  9.24000e+14  9.38000e+14  9.52000e+14  9.66000e+14  9.80000e+14  )
array_pre=(  1.04958e+35  1.12491e+35  1.20402e+35  1.28703e+35  1.37404e+35  1.46518e+35  1.56056e+35  1.66029e+35  1.76449e+35  1.87328e+35  1.98679e+35  2.10511e+35  2.22839e+35  2.35675e+35  2.49029e+35  2.62916e+35  2.77348e+35  2.92336e+35  3.07895e+35  3.24036e+35  3.40772e+35  )

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
