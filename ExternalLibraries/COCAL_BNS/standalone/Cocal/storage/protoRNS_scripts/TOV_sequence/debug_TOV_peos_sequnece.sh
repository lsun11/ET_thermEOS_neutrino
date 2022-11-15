name_flag=TOV_seq
param_dir_name=../../../parameter_sample/RNS_CF
work_dir_name=Cocal_debug/spherical_data/TOV_schwartzshild_coord
num_seq=200

#array_peos=( 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 )
#array_rho=(  5.60000e+14  5.74000e+14  5.88000e+14  6.02000e+14  6.16000e+14  6.30000e+14  6.44000e+14  6.58000e+14  6.72000e+14  6.86000e+14  7.00000e+14  7.14000e+14  7.28000e+14  7.42000e+14  7.56000e+14  7.70000e+14  7.84000e+14  7.98000e+14  8.12000e+14  8.26000e+14  8.40000e+14  )
#array_pre=(  4.80653e+34  5.24041e+34  5.70157e+34  6.19101e+34  6.70975e+34  7.25881e+34  7.83924e+34  8.45209e+34  9.09842e+34  9.77930e+34  1.04958e+35  1.12491e+35  1.20402e+35  1.28703e+35  1.37404e+35  1.46518e+35  1.56056e+35  1.66029e+35  1.76449e+35  1.87328e+35  1.98679e+35  )
array_peos=( 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 )
array_rho=(  8.54000e+14  8.68000e+14  8.82000e+14  8.96000e+14  9.10000e+14  9.24000e+14  9.38000e+14  9.52000e+14  9.66000e+14  9.80000e+14  9.94000e+14  1.00800e+15  1.02200e+15  1.03600e+15  1.05000e+15  1.06400e+15  1.07800e+15  1.09200e+15  1.10600e+15  1.12000e+15  )
array_pre=(  2.10511e+35  2.22839e+35  2.35675e+35  2.49029e+35  2.62916e+35  2.77348e+35  2.92336e+35  3.07895e+35  3.24036e+35  3.40772e+35  3.58117e+35  3.76084e+35  3.94685e+35  4.13935e+35  4.33846e+35  4.54432e+35  4.75706e+35  4.97682e+35  5.20375e+35  5.43796e+35  )

cd ${work_dir_name}

i=0
while [ $i -lt `expr ${#array_peos[*]}` ]
do
  cp ${param_dir_name}/${name_flag}/*.* .
  cp peos_parameter.dat.org peos_parameter.dat.tmp
  sed -i "s!dividingRHO!${array_rho[$i]}!" peos_parameter.dat.tmp
  sed -i "s!dividingPRE!${array_pre[$i]}!" peos_parameter.dat.tmp
  j=0
  while [ $j -le `expr ${num_seq}` ]
  do 
    cp peos_parameter.dat.tmp peos_parameter.dat
    rhoc=`echo "scale=2;0.5+$j/100" | bc -l | sed -e "s/^\./0./"`000e+15
    sed -i "s!central_RHO!${rhoc}!" peos_parameter.dat
    ./exe_TOV_peos
    cat ovphy_plot.dat >> ovphy_plot_${name_flag}_EOS_${array_peos[$i]}.dat
    cat ovphy.dat      >> ovphy_${name_flag}_EOS_${array_peos[$i]}.dat
    j=`expr $j + 1`
  done
  i=`expr $i + 1`
done

cd ../../../
