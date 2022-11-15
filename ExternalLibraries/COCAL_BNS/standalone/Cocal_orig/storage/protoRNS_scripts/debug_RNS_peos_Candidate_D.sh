name_flag=H2
rest_mass=1.350000E-00
param_dir_name=../parameter_sample/RNS_CF
work_dir_name=work_area_RNS
ctrl_dir_name=ctrl_area_RNS
#array_dir=( 01 02 )
#array_rho=( 5.59440e+14 5.72880e+14 )
#array_pre=( 2.22062e+34 2.41301e+34 )
array_dir=( 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 )
array_rho=(  5.59440e+14  5.72880e+14  5.86880e+14  6.01440e+14  6.16000e+14  6.31120e+14  6.46520e+14  6.62200e+14  6.78440e+14  6.94960e+14  7.12040e+14  7.29400e+14  7.47040e+14  7.65240e+14  7.84000e+14  8.03040e+14  8.22640e+14  8.42800e+14 )
array_pre=(  2.22062e+34  2.41301e+34  2.62578e+34  2.86094e+34  3.11078e+34  3.38632e+34  3.68445e+34  4.00681e+34  4.36140e+34  4.74456e+34  5.16537e+34  5.61974e+34  6.10998e+34  6.64704e+34  7.23507e+34  7.86894e+34  8.56191e+34  9.31906e+34 )

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
