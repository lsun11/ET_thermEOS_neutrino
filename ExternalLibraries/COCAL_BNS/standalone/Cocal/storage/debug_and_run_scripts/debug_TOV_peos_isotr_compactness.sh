name_flag=S1
param_dir_name=../parameter_sample/RNS_CF
work_dir_name=work_area_RNS

rm -rf Cocal_debug
cp -rfp ./Cocal Cocal_debug
cd Cocal_debug/compile_scripts
sh compile_TOV_isotr.sh
cd ../
cp executable_files/exe_TOV_peos  ${work_dir_name}/exe_TOV_peos
cp ${param_dir_name}/${name_flag}/*.* ${work_dir_name}/.
cd ${work_dir_name}
sed -i 's/MoverR_value/2.000000E-01/g' rnspar.dat 
./exe_TOV_peos

cd ../../
mv Cocal_debug  Cocal_debug_S1_compa_0.2
