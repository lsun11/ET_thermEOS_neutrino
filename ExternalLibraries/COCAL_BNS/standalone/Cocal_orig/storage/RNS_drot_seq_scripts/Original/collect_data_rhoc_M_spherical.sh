dir_target=data_Gamma2and3_spherical
output_file_tag=data_rhoc_M
eos_type=( Gamma2 Gamma3 )

i=0
while [ $i -lt `expr ${#eos_type[*]}` ]
do
  output_file=${output_file_tag}_${eos_type[$i]}_spherical.dat
  rm ${output_file}
  data_file=${dir_target}/ovphy_TOV_seq_EOS_00.dat.${eos_type[$i]}
  grep -e 'M_ADM            ' ${data_file} | cut -c41- > tmp1.dat
  grep -e 'rho (cgs)'         ${data_file} | cut -c41- > tmp2.dat
  grep -e 'rest mass'         ${data_file} | cut -c41- > tmp3.dat
  paste tmp2.dat tmp1.dat >> tmp4.dat
  paste tmp4.dat tmp3.dat >> ${output_file}
  rm tmp*.dat
  i=`expr $i + 1`
done
