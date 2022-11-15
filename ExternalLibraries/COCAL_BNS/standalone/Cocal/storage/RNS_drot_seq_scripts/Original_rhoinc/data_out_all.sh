flag_name=G3_DRq04_rhoinc
dir_name=RNS_drot_${flag_name}
#in_file=rnsphyseq.dat
in_file=rns_parameter.las
out_file=seq_${flag_name}.dat
flag_dir=seq_H2t
num_seq_ini=1
num_seq_end=45
num_seq_inc=1
dir_num=(`seq -f %02g $num_seq_ini $num_seq_inc $num_seq_end`)
##num_seq_ini=1
##num_seq_end=60
##num_seq_inc=1
##dir_num=(`seq -f %03g $num_seq_ini $num_seq_inc $num_seq_end`)
#num_seq_ini=12
#num_seq_end=48
#num_seq_inc=4
#dir_num+=(`seq -f %03g $num_seq_ini $num_seq_inc $num_seq_end`)

echo "${dir_num[@]}"

physq_1="rho_c"
physq_2="dhdx"
physq_3="Rest mass M_0 1star"
physq_4="M_ADM              "
physq_5="Angular momentum J "
#physq_6="sqrt(1-(Rz/Rx)^2)  "
physq_6="Axis ratio z/x     "
physq_7="Axis ratio y/x     "
physq_8="Omega M and Omega  "
physq_9="T/|W|              "
#physq_2="surface on x axis"
#physq_2="Virial relation"
region1=23-45
region2=46-

rm ${out_file}
i=0
while [ $i -lt `expr ${#dir_num[*]}` ]
do 
  file_name=../../${dir_name}/Cocal_debug/work_area_RNS_${flag_dir}_${dir_num[$i]}/${in_file}
  grep -e "${physq_1}" ${file_name} | cut -c${region2} > test1.tmp
  grep -e "${physq_2}" ${file_name} | cut -c${region1} > test2.tmp
  grep -e "${physq_3}" ${file_name} | cut -c${region1} > test3.tmp
  grep -e "${physq_4}" ${file_name} | cut -c${region1} > test4.tmp
  grep -e "${physq_5}" ${file_name} | cut -c${region1} > test5.tmp
  grep -e "${physq_6}" ${file_name} | cut -c${region2} > test6.tmp
#  grep -e "${physq_6}" ${file_name} | cut -c${region1} > test6.tmp
  grep -e "${physq_7}" ${file_name} | cut -c${region2} > test7.tmp
  grep -e "${physq_8}" ${file_name} | cut -c${region2} > test8.tmp
  grep -e "${physq_9}" ${file_name} | cut -c${region2} > test9.tmp
  paste -d" " test1.tmp test2.tmp test3.tmp test4.tmp test5.tmp \
              test6.tmp test7.tmp test8.tmp test9.tmp >> ${out_file} 
  echo " " >> ${out_file} 
  rm test*.tmp
  i=`expr $i + 1`
done
sed -i '/  -/d' ${out_file} 
sed -i '/NaN/d' ${out_file} 
