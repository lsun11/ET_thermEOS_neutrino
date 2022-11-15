name_flag=TOV_seq     # for single structure
param_dir_name=../parameter_sample/RNS_CF
work_dir_name=work_area_RNS
num_seq=1

ad_gamma1=2.00000d+00
#ad_gamma2=2.00000d+00

array_peos=( 00 )
array_rho=( 7.90558e+14 )   # Corresponds to k=100, for gamma=2
array_pre=( 9.09463e+34 ) 

rm -rf Cocal_debug
cp -rfp ./Cocal Cocal_debug
cd Cocal_debug/compile_scripts
sh compile_TOV_isotr.sh
cd ../
cp executable_files/exe_TOV_peos  ${work_dir_name}/exe_TOV_peos
cp ${param_dir_name}/${name_flag}/*.* ${work_dir_name}/.

cd ${work_dir_name} 

i=0
while [ $i -lt `expr ${#array_peos[*]}` ]
do
  cp peos_parameter.dat.org peos_parameter.dat.tmp
  sed -i "s!dividingRHO!${array_rho[$i]}!" peos_parameter.dat.tmp
  sed -i "s!dividingPRE!${array_pre[$i]}!" peos_parameter.dat.tmp
  sed -i "s!gamma_val_1!${ad_gamma1}!" peos_parameter.dat.tmp

  for ((j=1; j <= ${num_seq}; j++))
  do 
    cp peos_parameter.dat.tmp peos_parameter.dat
#    rhoc=`echo "scale=2;0.5+$j/100" | bc -l | sed -e "s/^\./0./"`000e+15
    rhoc1=$(($j * 10**13))
    rhoc=$(printf "%1.5e\n"  "$rhoc1")
#    sed -i "s!central_RHO!${rhoc}!" peos_parameter.dat
    sed -i "s!central_RHO!7.90558e+14!" peos_parameter.dat
    ./exe_TOV_peos
    cat ovphy_plot.dat >> ovphy_plot_${name_flag}_EOS_${array_peos[$i]}.dat
    cat ovphy.dat      >> ovphy_${name_flag}_EOS_${array_peos[$i]}.dat
  done
  i=`expr $i + 1`
done

cd ../../
mv Cocal_debug Cocal_debug_single_isotr
