work_dir_name=work_area_RNS

array_dir=( 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 )

cd Cocal_debug

i=0
while [ $i -lt `expr ${#array_dir[*]}` ]
do
  cd ${work_dir_name}_EOS_${array_dir[$i]}/.
  cp ../../copy_lasini_3D.sh .
  sh copy_lasini_3D.sh
  sed -i 's/60   80   JB   XZ/34   80   JB   XZ/g' rnspar.dat
  sed -i 's/y    n/y    y/g'   rnspar.dat
  sed -i 's/1D   3D/3D   3D/g' rnspar.dat
  sed -i 's/7   -4/3   -1/g'   rnspar.dat
  (./exe_RNS_CF_peos > output_RNS_CF_peos ; \ 
   tail -n 50 rnsphyseq.dat > rns_parameter.las ) &
  cd ../
  i=`expr $i + 1`
done

cd ../
