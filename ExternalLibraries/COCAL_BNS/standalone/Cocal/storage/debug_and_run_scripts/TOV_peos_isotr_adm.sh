name_flag=eosK123.6
param_dir_name=../parameter_sample/RNS_CF
work_dir_name=work_area_RNS

rm -rf Cocal_debug
cp -rfp ./Cocal Cocal_debug
cd Cocal_debug/compile_scripts
sh compile_TOV_isotr.sh

#sh compile_TOV.sh

cd ../
cp executable_files/exe_TOV_peos  ${work_dir_name}/exe_TOV_peos
cp ${param_dir_name}/${name_flag}/*.* ${work_dir_name}/.
cd ${work_dir_name}
#sed -i "1s:\(.\{13\}\)\(.\{13\}\):\1  1.00000e+14:"  peos_parameter.dat

# the following lines for compactness
#sed -i "2s:\(.\{0\}\)\(.\{10\}\):\1    0    0:"   ovpar_peos.dat
#sed -i "15s:\(.\{0\}\)\(.\{14\}\):\1  1.800000E-01:"   rnspar.dat

# the following lines for rest mass
#sed -i "2s:\(.\{0\}\)\(.\{10\}\):\1    0    1:"   ovpar_peos.dat
#sed -i "14s:\(.\{0\}\)\(.\{14\}\):\1  1.625010E+00:"   rnspar.dat

# the following lines for adm mass
sed -i "2s:\(.\{0\}\)\(.\{10\}\):\1    0    2:"   ovpar_peos.dat
sed -i "14s:\(.\{14\}\)\(.\{14\}\):\1  1.514810E+00:"   rnspar.dat

./exe_TOV_peos
cd ../../
#mv Cocal_debug  TOV_${name_flag}_adm1.35
