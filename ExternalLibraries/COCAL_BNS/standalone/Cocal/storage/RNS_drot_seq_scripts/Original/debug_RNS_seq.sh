name_flag=H3
param_dir_name=../parameter_sample/RNS_CF
work_dir_name=work_area_RNS
ctrl_dir_name=ctrl_area_RNS
dir_flag=( 1 2 3 4 5 6 7 8 )
deform_par=( 112 \ 96 \ 80 \ 64 \ 48 \ 32 \ 16 \ \ 2 )
compactness=( 2.000000E-01 )
ad_gamma1=3.00000d+00
ad_gamma2=3.00000d+00
rho_div=5.60000e+14
pre_div=1.98103e+34

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
cp ${param_dir_name}/${param_dir_name_peos}/peos_parameter.dat_Gamma=2 \
                           ${work_dir_name}/peos_parameter.dat

cp ${param_dir_name}/${name_flag}/*.* ${work_dir_name}/.
cp ${param_dir_name}/${name_flag}/*.* ${ctrl_dir_name}/.

cd ctrl_area_RNS
sed -i "s!MoverR_value!${compactness[$i]}!" rnspar.dat
sed -i "s!dividingRHO!${rho_div}!" peos_parameter.dat
sed -i "s!dividingPRE!${pre_div}!" peos_parameter.dat
sed -i "s!gamma_val_1!${ad_gamma1}!" peos_parameter.dat
sed -i "s!gamma_val_2!${ad_gamma2}!" peos_parameter.dat
sed -i 's/8.00000d+14/9.00000d+14/g' peos_parameter.dat 
sed -i "s/    0    1/    1    1/g" ovpar_peos.dat
sed -i "s/    0    0/    1    1/g" ovpar_peos.dat

cat rnspar.dat
cat peos_parameter.dat
sh calc-1_model_parameter.sh
sh calc-2_update_rnspar.sh
sh calc-3_1D_initial.sh
sh calc-4_update_1D_initial.sh
sh calc-5_prepare_work_area_RNS.sh 
cd ../

cd ${work_dir_name}/.
cp ../../copy_lasini_3D.sh .
#sed -i 's/DR/UR/g' rnspar_drot.dat
#sed -i 's/1.000000E-00/2.000000E-00/g' rnspar_drot.dat
#sed -i 's/ 0.4d-00   0.4d-00/ 0.3d-00   0.3d-00/g' rnspar.dat

sed -i 's/y    n/n    n/g' rnspar.dat
sed -i 's/    3  -16/    1  -16/g' rnspar.dat
sed -i 's/1.000000E-00  3.000000E+01/2.000000E-00  1.000000E-03/g' rnspar_drot.dat

cd ../

i=0
cp -rfp ${work_dir_name} ${work_dir_name}_${dir_flag[$i]}

cd ${work_dir_name}_${dir_flag[$i]}/.
sed -i "s!120  160!${deform_par[$i]}  160!" rnspar.dat

./exe_RNS_CF_peos > output.dat

cd ../
i=`expr $i + 1`
while [ $i -lt `expr ${#dir_flag[*]}` ]
do

cp -rfp ${work_dir_name}_${dir_flag[$i-1]} ${work_dir_name}_${dir_flag[$i]}
cd ${work_dir_name}_${dir_flag[$i]}/.
sed -i "s!${deform_par[$i-1]}  160!${deform_par[$i]}  160!" rnspar.dat
sed -i 's/1D   3D/3D   3D/g' rnspar.dat
sh copy_lasini_3D.sh

./exe_RNS_CF_peos > output.dat

cd ../

  i=`expr $i + 1`
done

cd ../
