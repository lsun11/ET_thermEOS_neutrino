name_flag=SA2
rest_mass=1.40000E-00
MoverR_va=1.70000E-00
ad_gamma1=2.00000d+00
ad_gamma2=2.00000d+00
param_dir_name=../parameter_sample/RNS_WL
work_dir_name=work_area_RNS
ctrl_dir_name=ctrl_area_RNS
array_dir=( 00 )
array_rho=(  8.73844d+14  )
array_pre=(  1.00000d+35  )
#array_rho=(  5.60000e+14  )
#array_pre=(  4.80652e+34  )

rm -rf Cocal_debug
cp -rfp ~/Cocal Cocal_debug
cd Cocal_debug

cd compile_scripts
sh select_grgrad_midpoint_r3rd_NS.sh
sh select_grgrad_gridpoint_4th_NS.sh
sh select_weight_calc_midpoint_grav_th4th.sh
sh compile_TOV.sh
sh compile_1Dini.sh
sh compile_Main_RNS_WL_peos.sh

cd ../
cp executable_files/exe_RNS_WL_peos  ./${work_dir_name}/exe_rns_test

i=0
while [ $i -lt `expr ${#array_dir[*]}` ]
do
  cp ${param_dir_name}/${name_flag}/*.* ${work_dir_name}/.
  cp ${param_dir_name}/${name_flag}/*.* ${ctrl_dir_name}/.
  cd ctrl_area_RNS
  sed -i "s!restmass_val!${rest_mass}!" rnspar.dat
  sed -i "s!MoverR_value!${MoverR_va}!" rnspar.dat
  sed -i "s!dividingRHO!${array_rho[$i]}!" peos_parameter.dat
  sed -i "s!dividingPRE!${array_pre[$i]}!" peos_parameter.dat
  sed -i "s!gamma_val_1!${ad_gamma1}!" peos_parameter.dat
  sed -i "s!gamma_val_2!${ad_gamma2}!" peos_parameter.dat
  sh calc-1_model_parameter.sh
  sh calc-2_update_rnspar.sh
  sh calc-3_1D_initial.sh
  sh calc-4_update_1D_initial.sh
  sh calc-5_prepare_work_area_RNS.sh 
  cd ../
  cp -rfp ${work_dir_name} ${work_dir_name}_${array_dir[$i]}
  cd ${work_dir_name}_${array_dir[$i]}/.
  sed -i "s! 2000    y!  100    y!" rnspar.dat
  rm output_RNS
#  (./exe_rns_test > output_RNS ; \ 
#   tail -n 62 rnsphyseq.dat > rns_parameter.las ) &
  ./exe_rns_test
  tail -n 62 rnsphyseq.dat > rns_parameter.las
  cd ../
  i=`expr $i + 1`
done

cd ../
