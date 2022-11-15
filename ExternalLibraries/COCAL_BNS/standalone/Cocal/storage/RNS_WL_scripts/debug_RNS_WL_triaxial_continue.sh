name_flag=H1
param_dir_name=../parameter_sample/RNS_WL
work_dir_name=work_area_RNS
ctrl_dir_name=ctrl_area_RNS
dir_flag=( C020 )
compactness=( 2.000000E-01 )
ad_gamma1=3.00000d+00
ad_gamma2=3.00000d+00
rho_div=9.35057d+14
pre_div=1.00000d+35

cd Cocal_debug

i=0
while [ $i -lt `expr ${#dir_flag[*]}` ]
do

cd ${work_dir_name}_${dir_flag[$i]}/.
  cp ../../copy_lasini_3D.sh .
  sh copy_lasini_3D.sh
  cat rnspar.dat

sed -i 's/DR/UR/g' rnspar_drot.dat
sed -i 's/JB   XZ/JB   XY/g' rnspar.dat
sed -i 's/y    n/y    y/g'   rnspar.dat
sed -i 's/1D   3D/3D   3D/g' rnspar.dat
#sed -i 's/1.000000E-00/2.000000E-00/g' rnspar_drot.dat
#sed -i 's/ 0.4d-00   0.4d-00/ 0.3d-00   0.3d-00/g' rnspar.dat
#sed -i 's/    3   -4/    5   -2/g' rnspar.dat
sed -i 's/    3   -4/    8   -2/g' rnspar.dat
sed -i 's/    8   -2/    3   -1/g' rnspar.dat
sed -i 's/3.000000E+01/5.000000E-03/g' rnspar_drot.dat
#./exe_RNS_CF_peos
./exe_RNS_WL_peos > output.dat &
cd ../

  i=`expr $i + 1`
done

cd ../
