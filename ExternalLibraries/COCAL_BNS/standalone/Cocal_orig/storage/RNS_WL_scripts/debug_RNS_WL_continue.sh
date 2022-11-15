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

cd Cocal_debug

cp ${param_dir_name}/${name_flag}/*.* \
   ${work_dir_name}_${array_dir[$i]}/.
cd ${work_dir_name}_${array_dir[$i]}

sed -i "s!restmass_val!${rest_mass}!" rnspar.dat
sed -i "s!MoverR_value!${MoverR_va}!" rnspar.dat
sed -i "s!dividingRHO!${array_rho[$i]}!" peos_parameter.dat
sed -i "s!dividingPRE!${array_pre[$i]}!" peos_parameter.dat
sed -i "s!gamma_val_1!${ad_gamma1}!" peos_parameter.dat
sed -i "s!gamma_val_2!${ad_gamma2}!" peos_parameter.dat
sed -i "s!2000!1000!" rnspar.dat
#  (./exe_rns_test > output_RNS ; \ 
#   tail -n 62 rnsphyseq.dat > rns_parameter.las ) &
  ./exe_rns_test
  tail -n 62 rnsphyseq.dat > rns_parameter.las

cd ../../
