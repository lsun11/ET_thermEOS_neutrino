name_flag=seq_H2t
num_seq=120
#G2 num_seq=105
#G3 num_seq=120
work_dir_name=work_area_RNS
ctrl_dir_name=ctrl_area_RNS
num_dir_ini=1
num_dir_end=45
num_dir_inc=1
dir_flag=(`seq -f %02g $num_dir_ini $num_dir_inc $num_dir_end`)
echo "${dir_flag[@]}"

cd Cocal_debug

i=0
while [ $i -lt `expr ${#dir_flag[*]}` ]
do
  cp -rp ${work_dir_name}_${dir_flag[$i]} \
         ${work_dir_name}_${name_flag}_${dir_flag[$i]}
  cd     ${work_dir_name}_${name_flag}_${dir_flag[$i]}
  cp rnspar.dat rnspar.dat.tmp
  sed -i 's/1.129609E-02/central_emdc/g' rnspar.dat.tmp
#G2  sed -i 's/3.449275E-03/central_emdc/g' rnspar.dat.tmp
#G3  sed -i 's/1.129609E-02/central_emdc/g' rnspar.dat.tmp
  sed -i 's/1D   3D/3D   3D/g' rnspar.dat.tmp
  sed -i 's/48   48   12/96   48   20/g' rnspar.dat.tmp
  sed -i 's/2000/ 700/g' rnspar.dat.tmp
  {
  j=0
  while [ $j -le `expr ${num_seq}` ]
  do
    sh copy_lasini_3D.sh
    cp rnspar.dat.tmp rnspar.dat
    emdc=`echo "scale=2;0.01+$j/100" | bc -l | sed -e "s/^\./0./"`0000E+00
#G2    emdc=`echo "scale=3;0.004+$j/250" | bc -l | sed -e "s/^\./0./"`000E+00
#G3    emdc=`echo "scale=2;0.01+$j/100" | bc -l | sed -e "s/^\./0./"`0000E+00
    sed -i "s!central_emdc!${emdc}!" rnspar.dat
    ./exe_RNS_CF_peos > output.dat
    cat rnsphyseq.dat >> rns_parameter.las
    cat rnsquadpole.dat >> rnsquadpole.las
    j=`expr $j + 1`
  done
  } &
  cd ../
  i=`expr $i + 1`
done

cd ../
