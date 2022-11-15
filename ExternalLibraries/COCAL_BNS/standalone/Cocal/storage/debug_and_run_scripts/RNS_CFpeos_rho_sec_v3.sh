param_flag=H2
eos_flag=K123.6
eos_dir_name=../parameter_sample/EOS
param_dir_name=../parameter_sample/RNS_CF
work_dir_name=work_area_RNS
ctrl_dir_name=ctrl_area_RNS
new_dir_name=rns_gamma2_64_40
ID_dir_name=rns_gamma2_64_44
num_seq=70

array_peos=( 00 )
array_rho=( 7.90558e+14 )   # Corresponds to k=123.6, for gamma=2
array_pre=( 1.12410e+35 )   # or k=179861 in cgs units.

rm -rf ${new_dir_name}
cp -rfp ./Cocal   ${new_dir_name}
cd ${new_dir_name}

cd compile_scripts
sh select_grgrad_midpoint_r3rd_NS.sh
sh select_grgrad_gridpoint_4th_NS.sh
sh select_weight_calc_midpoint_grav_th4th.sh
#sh compile_TOV.sh
#sh compile_1Dini.sh
sh compile_TOV_isotr.sh
sh compile_Import_isotr.sh
sh compile_Main_RNS_CF_peos.sh
sh compile_Main_RNS_CF_peos_plot.sh
cd ../

cp executable_files/exe_TOV_peos     ${work_dir_name}/exe_TOV_peos
cp executable_files/exe_RNS_CF_peos  ${work_dir_name}/exe_rns_test
cp executable_files/exe_RNS_plot     ${work_dir_name}/exe_rns_plot

cp ${param_dir_name}/${param_flag}/*.* ${work_dir_name}/.
cp ${param_dir_name}/${param_flag}/*.* ${ctrl_dir_name}/.

cp ${eos_dir_name}/${eos_flag}/peos_parameter.dat  ./${work_dir_name}/.
cp ${eos_dir_name}/${eos_flag}/peos_parameter.dat  ./${ctrl_dir_name}/.

for ((j=0; j <= ${num_seq}; j++))
do
  if [ $j -le 9 ]; then
    seqj=00${j}
  elif [ $j -gt 9 -a $j -le 99 ]; then
    seqj=0${j}
  else
    seqj=${j}
  fi 
  cp -rfp ../${ID_dir_name}/${work_dir_name}_${seqj}  ./.
  cd ${work_dir_name}_${seqj}/.
  mv rnsflu_3D.las    rnsflu_3D.ini
  mv rnsgra_3D.las    rnsgra_3D.ini
  mv rnsgrids_3D.las  rnsgrids_3D.ini
# Input now is 3D
  sed -i "9s:\(.\{0\}\)\(.\{5\}\):\1   3D:"    rnspar.dat
  sed -i "3s:\(.\{0\}\)\(.\{5\}\):\1   40:"    rnspar.dat
  sed -i 's/DR/UR/g' rnspar_drot.dat
  ./exe_RNS_CF_peos
  cd ../ 
done

cd ../../
