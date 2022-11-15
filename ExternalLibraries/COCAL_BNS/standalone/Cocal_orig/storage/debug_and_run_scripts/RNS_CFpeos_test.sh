param_flag=H2
eos_flag=K123.6
param_dir_name=../parameter_sample/RNS_CF
eos_dir_name=../parameter_sample/EOS
work_dir_name=work_area_RNS
ctrl_dir_name=ctrl_area_RNS
new_dir_name=rrrrr

rm -rf ${new_dir_name}
cp -rfp ./Cocal   ${new_dir_name}
cd ${new_dir_name}

cd compile_scripts
#sh select_grgrad_midpoint_r3rd_NS.sh
#sh select_grgrad_gridpoint_4th_NS.sh
sh select_weight_calc_midpoint_grav_th4th.sh
sh compile_TOV.sh
sh compile_1Dini.sh
#sh compile_TOV_isotr.sh
#sh compile_Import_isotr.sh

#sh compile_Main_RNS_CF_peos.sh
sh compile_Main_RNS_CF_peos_gp4th.sh
sh compile_Main_RNS_CF_peos_plot.sh
cd ../

cp executable_files/exe_RNS_CF_peos  ${work_dir_name}/exe_rns_test
cp executable_files/exe_RNS_plot  ${work_dir_name}/exe_rns_plot

cp ${param_dir_name}/${param_flag}/*.* ${work_dir_name}/.
cp ${param_dir_name}/${param_flag}/*.* ${ctrl_dir_name}/.

cp ${eos_dir_name}/${eos_flag}/*.dat  ./${work_dir_name}/.
cp ${eos_dir_name}/${eos_flag}/*.dat  ./${ctrl_dir_name}/.

cd ctrl_area_RNS
sed -i 's/MoverR_value/1.000000E-01/g' rnspar.dat
sh calc-1_model_parameter.sh
sh calc-2_update_rnspar.sh
sh calc-3_1D_initial.sh
#sh calc-3_1D_initial_iso.sh
sh calc-4_update_1D_initial.sh
sh calc-5_prepare_work_area_RNS.sh 
cd ../
cp -rfp ${work_dir_name} ${work_dir_name}_C010
cd ${work_dir_name}_C010/.

#sed -i 's/80  100/76  100/g' rnspar.dat
sed -i 's/DR/UR/g' rnspar_drot.dat
#sed -i 's/1.000000E-00/2.000000E-00/g' rnspar_drot.dat

./exe_RNS_CF_peos 
cd ../

cd ../
