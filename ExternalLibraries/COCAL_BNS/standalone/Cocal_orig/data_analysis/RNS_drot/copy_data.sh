#dir_source=RNS_drot_seq_1
#dir_target=data_Gamma2_j_const
#dir_source=RNS_drot_seq_2
#dir_target=data_Gamma3_j_const
#dir_source=RNS_drot_seq_3
#dir_target=data_Gamma3_v_const
#dir_flag=( 1 2 3 4 5 6 7 8 )
#deform_par=( 112 096 080 064 048 032 016 002 )
dir_source=RNS_drot_seq_3
dir_target=data_Gamma3_v_const
dir_flag=( 1 2 3 4 5 6 7 )
deform_par=( 112 096 080 064 048 032 016 )
##dir_source=RNS_drot_seq_4
##dir_target=data_Gamma3_q04
##dir_source=RNS_drot_seq_5
##dir_target=data_Gamma3_q08
##dir_flag=( 1 2 3 4 )
##deform_par=( 112 096 080 064 )
###dir_source=RNS_drot_seq_6a
###dir_target=data_Gamma3_q16
###dir_flag=( 1 2 3 4 )
###deform_par=( 112 096 080 068 )
####dir_source=RNS_drot_seq_7
####dir_target=data_Gamma3_q01_A1
####dir_flag=( 1 2 3 4 5 6 7 )
####deform_par=( 112 096 080 064 048 032 016 )
#####dir_source=RNS_drot_seq_8
#####dir_target=data_Gamma2_q01_A1_BSS
#####dir_flag=( 1 2 3 4 5b 6b 7b )
#####deform_par=( 112 096 080 064 048 032 016 )

mkdir ${dir_target}

i=0
while [ $i -lt `expr ${#dir_flag[*]}` ]
do
  cp ~/${dir_source}/Cocal_debug/work_area_RNS_${dir_flag[$i]}/rns_parameter.las ${dir_target}/rnsphyseq.dat.${deform_par[$i]}
  i=`expr $i + 1`
done
