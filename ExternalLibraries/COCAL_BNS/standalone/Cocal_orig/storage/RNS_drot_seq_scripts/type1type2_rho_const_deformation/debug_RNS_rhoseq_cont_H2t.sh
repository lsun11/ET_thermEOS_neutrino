work_dir_name=work_area_RNS
name_flag=seq_H2t
num_seq_ini=4
num_seq_end=92
num_seq_inc=4
num_sol_seq=\ 60
deform_par=\ -1

dir_flag=(`seq -f %03g $num_seq_ini $num_seq_inc $num_seq_end`)
echo "${dir_flag[@]}"
cd Cocal_debug

i=0
while [ $i -lt `expr ${#dir_flag[*]}` ]
do
  cp -rp ${work_dir_name}_${dir_flag[$i]} \
         ${work_dir_name}_${name_flag}_${dir_flag[$i]}
  cd     ${work_dir_name}_${name_flag}_${dir_flag[$i]}
  sh copy_lasini_3D.sh
  rm rns*.tmp
  sed -i 's/1D   3D/3D   3D/g' rnspar.dat
  sed -i "s!    1   -8!  ${num_sol_seq}  ${deform_par}!" rnspar.dat
  sed -i 's/48   48   12/96   48   20/g' rnspar.dat
{
  ./exe_RNS_CF_peos > output.dat
} &
  cd ../
  i=`expr $i + 1`
done
cd ../
