name_flag=H3
file_physeq=rnsphyseq.dat
#file_physeq=bbhphyseq.dat
work_dir_name=work_area_RNS_EOS

file_dir=../${work_dir_name}
file_physeq_ext=rnsphyseq_extracted

#array=( 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 )
array=( 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 )

i=0
while [ $i -lt `expr ${#array[*]}` ]
do 
  grep -e 'Omega' ${file_dir}_${array[$i]}/${file_physeq} >> tmp1.dat
  grep -e 'M_ADM              ' ${file_dir}_${array[$i]}/${file_physeq} >> tmp2.dat
  grep -e 'J/M^2' ${file_dir}_${array[$i]}/${file_physeq} >> tmp3.dat
  grep -e 'rho_c' ${file_dir}_${array[$i]}/${file_physeq} >> tmp4.dat
  grep -e 'E/M =' ${file_dir}_${array[$i]}/${file_physeq} >> tmp5.dat
  grep -e 'T/|W|' ${file_dir}_${array[$i]}/${file_physeq} >> tmp6.dat
  grep -e '1 - M' ${file_dir}_${array[$i]}/${file_physeq} >> tmp7.dat
  grep -e 'Axis ratio y' ${file_dir}_${array[$i]}/${file_physeq} >> tmp8.dat
  grep -e 'Axis ratio z' ${file_dir}_${array[$i]}/${file_physeq} >> tmp9.dat

  cut -c23-45  tmp1.dat > tmp_1a.dat
  cut -c24-45  tmp2.dat > tmp_2a.dat
  cut -c24-45  tmp3.dat > tmp_3a.dat
  cut -c47-68  tmp4.dat > tmp_4a.dat
  cut -c24-45  tmp5.dat > tmp_5a.dat
  cut -c24-45  tmp6.dat > tmp_6a.dat
  cut -c24-45  tmp7.dat > tmp_7a.dat
  cut -c24-45  tmp8.dat > tmp_8a.dat
  cut -c24-45  tmp9.dat > tmp_9a.dat

  echo '# OmegaM  M_ADM  J  rho_c  E/M  T/|W|  Virial  y/x  z/x' > \
     ${file_physeq_ext}_${array[$i]}.dat
  paste tmp_1a.dat tmp_2a.dat > tmp_c3.dat
  paste tmp_c3.dat tmp_3a.dat > tmp_c4.dat
  paste tmp_c4.dat tmp_4a.dat > tmp_c5.dat
  paste tmp_c5.dat tmp_5a.dat > tmp_c6.dat
  paste tmp_c6.dat tmp_6a.dat > tmp_c7.dat
  paste tmp_c7.dat tmp_7a.dat > tmp_c8.dat
  paste tmp_c8.dat tmp_8a.dat > tmp_c9.dat
  paste tmp_c9.dat tmp_9a.dat > tmp_all.dat
  
  cat tmp_all.dat >> ${file_physeq_ext}_${array[$i]}.dat
  rm tmp*.dat

  i=`expr $i + 1`
done
