name_flag=H3
num_seq=110
param_dir_name=../parameter_sample/RNS_CF
work_dir_name=work_area_RNS
ctrl_dir_name=ctrl_area_RNS
dir_flag=( 1 2 3 4 5 6 7 8 )
deform_par=( 112 \ 96 \ 80 \ 64 \ 48 \ 32 \ 16 \ \ 2 )

cd Cocal_debug

i=0
while [ $i -lt `expr ${#dir_flag[*]}` ]
do
  cd ${work_dir_name}_${dir_flag[$i]}/.
  cp rnspar.dat rnspar.dat.tmp
  sed -i 's/1.016648E-01/central_emdc/g' rnspar.dat.tmp
  sed -i 's/1D   3D/3D   3D/g' rnspar.dat.tmp
  {
  j=0
  while [ $j -le `expr ${num_seq}` ]
  do
    sh copy_lasini_3D.sh
    cp rnspar.dat.tmp rnspar.dat
    emdc=`echo "scale=2;0.1+$j/100" | bc -l | sed -e "s/^\./0./"`0000E+00
    sed -i "s!central_emdc!${emdc}!" rnspar.dat
    ./exe_RNS_CF_peos > output.dat
    cat rnsphyseq.dat >> rns_parameter.las
    j=`expr $j + 1`
  done
  } &
  cd ../
  i=`expr $i + 1`
done

cd ../
