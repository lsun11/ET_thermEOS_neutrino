name_flag=H1
param_dir_name=../parameter_sample/RNS_CF
work_dir_name=work_area_RNS
ctrl_dir_name=ctrl_area_RNS
dir_flag=( C010 C020 C030 )
compactness=( 1.000000E-01  2.000000E-01  3.000000E-01 )

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
while [ $i -lt `expr ${#dir_flag[*]}` ]
do

cp ${param_dir_name}/${name_flag}/*.* ${work_dir_name}/.
cp ${param_dir_name}/${name_flag}/*.* ${ctrl_dir_name}/.

cd ctrl_area_RNS
sed -i "s!MoverR_value!${compactness[$i]}!" rnspar.dat
sh calc-1_model_parameter.sh
sh calc-2_update_rnspar.sh
cp ../spherical_data/initial_isotropic_coord/INI_data/INI_N05_C025.flu \
   ../spherical_data/initial_isotropic_coord/work_area_1D_peos/rnsflu_1D.ini
cp ../spherical_data/initial_isotropic_coord/INI_data/INI_N05_C025.gra \
   ../spherical_data/initial_isotropic_coord/work_area_1D_peos/rnsgra_1D.ini
sh calc-3_1D_initial.sh
sh calc-4_update_1D_initial.sh
sh calc-5_prepare_work_area_RNS.sh 
cd ../
cp -rfp ${work_dir_name} ${work_dir_name}_${dir_flag[$i]}
cd ${work_dir_name}_${dir_flag[$i]}/.

#sed -i 's/DR/UR/g' rnspar_drot.dat
sed -i 's/3.000000E+01/4.000000E-01/g' rnspar_drot.dat
#./exe_RNS_CF_peos
./exe_RNS_CF_peos > output.dat &
cd ../

  i=`expr $i + 1`
done

cd ../
