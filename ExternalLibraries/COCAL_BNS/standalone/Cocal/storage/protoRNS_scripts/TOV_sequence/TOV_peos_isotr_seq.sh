param_flag=H3
eos_flag=K123.6
eos_dir_name=../parameter_sample/EOS
param_dir_name=../parameter_sample/RNS_CF
work_dir_name=work_area_RNS
num_seq=600
new_dir_name=tov${eos_flag}_seq_g3

ad_gamma1=2.00000d+00
array_peos=( 00 )
array_rho=( 7.90558e+14 )   # Corresponds to k=123.6, for gamma=2
array_pre=( 1.12410e+35 )   # or k=179861 in cgs units.

rm -rf ${new_dir_name}
rm -rf tmpdir
mkdir tmpdir
tar czf tmpcoc.tar.gz ./Cocal  --exclude='.svn'
mv tmpcoc.tar.gz  ./tmpdir/
cd tmpdir
tar xzf tmpcoc.tar.gz
mv Cocal ../${new_dir_name}
cd ..
rm -rf tmpdir
cd ${new_dir_name}
pwd

#rm -rf ${new_dir_name}
#cp -rfp ./Cocal   ${new_dir_name}
#cd ${new_dir_name}

cd compile_scripts
sh compile_TOV_isotr.sh
cd ../

cp executable_files/exe_TOV_peos                           ${work_dir_name}/.
cp ${param_dir_name}/${param_flag}/*.*                     ${work_dir_name}/.
cp ${eos_dir_name}/${eos_flag}/peos_parameter.dat_gamma_3  ${work_dir_name}/peos_parameter.dat

cd ${work_dir_name} 
sed -i "2s:\(.\{0\}\)\(.\{10\}\):\1    1    0:"   ovpar_peos.dat

i=0
while [ $i -lt `expr ${#array_peos[*]}` ]
do
#  cp peos_parameter.dat.org peos_parameter.dat.tmp
#  sed -i "s!dividingRHO!${array_rho[$i]}!" peos_parameter.dat.tmp
#  sed -i "s!dividingPRE!${array_pre[$i]}!" peos_parameter.dat.tmp
#  sed -i "s!gamma_val_1!${ad_gamma1}!" peos_parameter.dat.tmp

  for ((j=1; j <= ${num_seq}; j++))
  do 
#    cp peos_parameter.dat.tmp peos_parameter.dat
#    rhoc=`echo "scale=2;0.5+$j/100" | bc -l | sed -e "s/^\./0./"`000e+15

    rhoc1=$(($j * 1 * 10**13))       # Good starting point for K123.6 approximately
#    rhoc1=$(($j * 1 * 10**15))        # Good starting point for K1 approximately
    rhoc=$(printf "%1.5e\n"  "$rhoc1")
    sed -i "1s:\(.\{13\}\)\(.\{13\}\):\1  ${rhoc}:"  peos_parameter.dat
#    sed -i "s!central_RHO!${rhoc}!" peos_parameter.dat
#    sed -i "s!central_RHO!7.90558e+14!" peos_parameter.dat
    ./exe_TOV_peos
    cat ovphy_plot.dat >> ovphy_plot_${eos_flag}_EOS_${array_peos[$i]}.dat
    cat ovphy.dat      >> ovphy_${eos_flag}_EOS_${array_peos[$i]}.dat
  done
  i=`expr $i + 1`
done

cd ../../
