#dir_target=data_Gamma2_j_const
#dir_target=data_Gamma3_j_const
#dir_target=data_Gamma3_v_const
#dir_flag=( 1 2 3 4 5 6 7 8 )
#deform_par=( 112 096 080 064 048 032 016 002 )
##dir_target=data_Gamma3_q04
##dir_flag=( 1 2 3 4 5 )
##deform_par=( 112 096 080 064 048 )
###dir_target=data_Gamma3_q08
###dir_flag=( 1 2 3 4 )
###deform_par=( 112 096 080 064 )
#dir_target=data_Gamma3_q16
#dir_flag=( 1 2 3 4 )
#deform_par=( 112 096 080 068 )
####dir_target=data_Gamma3_BSS
####dir_flag=( 1 2 3 4 5 6 7 )
####deform_par=( 112 096 080 064 048 032 016 )
dir_target=data_Gamma2_q01_A1
dir_flag=( 1 2 3 4 5b 6b 7b )
deform_par=( 112 096 080 064 048 032 016 )

output_file=data_rhoc_M_${dir_target}.dat

rm ${output_file}
i=0
while [ $i -lt `expr ${#dir_flag[*]}` ]
do
  data_file=${dir_target}/rnsphyseq.dat.${deform_par[$i]}
  grep -e 'M_ADM            ' ${data_file} | cut -c23-45 > tmp1.dat
  grep -e 'rho_c'             ${data_file} | cut -c47-   > tmp2.dat
  grep -e 'Rest mass M_0'     ${data_file} | cut -c23-45 > tmp3.dat
  paste tmp2.dat tmp1.dat >> tmp4.dat
  paste tmp4.dat tmp3.dat >> ${output_file}
  rm tmp*.dat
  echo '  ' >> ${output_file}
  i=`expr $i + 1`
done
