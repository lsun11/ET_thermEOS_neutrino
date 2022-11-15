name_flag=H2
param_dir_name=../parameter_sample/RNS_CF
work_dir_name=work_area_RNS
ctrl_dir_name=ctrl_area_RNS
num_seq=105
#G2 num_seq=105
#G3 num_seq=120
dir_flag=(`seq -f %03g 1 $num_seq`)
deform_par=( \ 60 )

compactness=( 2.000000E-01 )
ad_gamma1=2.00000d+00
ad_gamma2=2.00000d+00
rho_div=5.60000e+14
pre_div=3.24059e+34
#G2 pre_div=3.24059e+34
#G3 pre_div=1.98103e+34
DROT=5.000000E-01
index_DR=2.500000E-01
A2DR=1.189207E+00
#type0 DR A2DR=1.000000E-03

rm -rf Cocal_debug
cp -rfp ~/Cocal Cocal_debug
cd Cocal_debug

cd compile_scripts
sh select_grgrad_midpoint_r3rd_NS.sh
sh select_grgrad_gridpoint_4th_NS.sh
sh select_weight_calc_midpoint_grav_th4th.sh
sh select_reset_fluid_radius_le_1.sh
sh select_correct_matter_source_out.sh
sh select_calc_surface_quad.sh
sh select_robust_convergence.sh
#sh select_surface_nrf_minus_2.sh
sh select_rotation_law_type1.sh
sh compile_TOV.sh
sh compile_1Dini.sh
sh compile_Main_RNS_CF_peos.sh
#sh compile_Main_RNS_CF_peos_plot.sh

cd ../

cp executable_files/exe_RNS_CF_peos  ${work_dir_name}/exe_rns_test
cp executable_files/exe_RNS_CF_peos  ${work_dir_name}/.

cp ${param_dir_name}/${name_flag}/*.* ${work_dir_name}/.
cp ${param_dir_name}/${name_flag}/*.* ${ctrl_dir_name}/.

cd ${ctrl_dir_name}
sed -i "s!MoverR_value!${compactness[$i]}!" rnspar.dat
sed -i "s!dividingRHO!${rho_div}!" peos_parameter.dat
sed -i "s!dividingPRE!${pre_div}!" peos_parameter.dat
sed -i "s!gamma_val_1!${ad_gamma1}!" peos_parameter.dat
sed -i "s!gamma_val_2!${ad_gamma2}!" peos_parameter.dat
#sed -i 's/8.00000d+14/9.00000d+14/g' peos_parameter.dat 
#sed -i 's/8.00000d+14/3.00000d+14/g' peos_parameter.dat 
#sed -i 's/8.00000d+14/3.00000d+13/g' peos_parameter.dat 
sed -i 's/rhoini_cgsV/3.00000d+13/g' peos_parameter.dat 
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
#sed -i 's/ 0.4d-00   0.4d-00/ 0.3d-00   0.3d-00/g' rnspar.dat
sed -i 's/JB   XZ/ML   XZ/g' rnspar.dat
sed -i 's/y    n/n    n/g' rnspar.dat
sed -i 's/    3   -8/    1   -8/g' rnspar.dat
sed -i "s! 60   80!${deform_par[0]}   80!" rnspar.dat
sed -i "s!index_DR_val!${index_DR}!" rnspar_drot.dat
sed -i "s!A2DR___value!${A2DR}!"     rnspar_drot.dat
sed -i "s!DROT___value!${DROT}!"     rnspar_drot.dat
cp rnspar.dat rnspar.dat.tmp
sed -i 's/3.449275E-03/central_emdc/g' rnspar.dat.tmp
#G2  sed -i 's/3.449275E-03/central_emdc/g' rnspar.dat.tmp
#G3  sed -i 's/1.129609E-02/central_emdc/g' rnspar.dat.tmp
cd ../

{
i=0
cp -rfp ${work_dir_name} ${work_dir_name}_${dir_flag[$i]}
cd ${work_dir_name}_${dir_flag[$i]}/.

while [ $i -lt `expr ${#dir_flag[*]}` ]
do
if [ $i -ne 0 ] ; then
  cp -rfp ${work_dir_name}_${dir_flag[$i-1]} ${work_dir_name}_${dir_flag[$i]}
  cd ${work_dir_name}_${dir_flag[$i]}/.
  sed -i 's/1D   3D/3D   3D/g' rnspar.dat.tmp
  sh copy_lasini_3D.sh
fi
cp rnspar.dat.tmp rnspar.dat
j=$i
emdc=`echo "scale=3;0.004+$j/250" | bc -l | sed -e "s/^\./0./"`000E+00
#G2    emdc=`echo "scale=3;0.004+$j/250" | bc -l | sed -e "s/^\./0./"`000E+00
#G3    emdc=`echo "scale=2;0.01+$j/100" | bc -l | sed -e "s/^\./0./"`0000E+00
sed -i "s!central_emdc!${emdc}!" rnspar.dat
./exe_RNS_CF_peos > output.dat
cd ../
  i=`expr $i + 1`
done
} &
cd ../
