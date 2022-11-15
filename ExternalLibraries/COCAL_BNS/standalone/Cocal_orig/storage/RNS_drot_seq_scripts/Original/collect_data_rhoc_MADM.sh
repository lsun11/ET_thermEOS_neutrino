#dir_source=RNS_drot_seq_1
#dir_target=data_Gamma2_j_const
#dir_source=RNS_drot_seq_2
#dir_target=data_Gamma3_j_const
dir_source=RNS_drot_seq_3
dir_target=data_Gamma3_v_const
dir_flag=( 1 2 3 4 5 6 7 8 )
deform_par=( 112 096 080 064 048 032 016 002 )
output_file=data_rhoc_MADM_${dir_target}.dat

rm ${output_file}
i=0
while [ $i -lt `expr ${#dir_flag[*]}` ]
do
  data_file=${dir_target}/rnsphyseq.dat.${deform_par[$i]}
  grep -e 'M_ADM            ' ${data_file} | cut -c23-45 > tmp1.dat
  grep -e 'rho_c'             ${data_file} | cut -c47-   > tmp2.dat
  paste tmp2.dat tmp1.dat >> ${output_file}
  rm tmp1.dat tmp2.dat
  echo '  ' >> ${output_file}
  i=`expr $i + 1`
done
