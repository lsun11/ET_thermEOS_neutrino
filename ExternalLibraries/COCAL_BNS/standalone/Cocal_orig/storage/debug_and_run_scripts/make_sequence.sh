name_flag=H2
param_dir_name=../parameter_sample/BBH_CF_3mpt_seq
work_dir_name=work_area_BBH

file_bbhphy=../Cocal_debug_seq_ref/${work_dir_name}_${name_flag}
file_bbhphy_ext=bbhphyseq_extracted_${name_flag}.dat
file_bbhphy_all=bbhphyseq_all_${name_flag}.dat

array=( 08 09 10 11 12 13 14 15 16 17 18 19 20 )

rm ${file_bbhphy_ext}
rm ${file_bbhphy_all}

i=0
while [ $i -lt `expr ${#array[*]}` ]
do 
  grep -e 'Omega' ${file_bbhphy}_ra0${array[$i]}/bbhphyseq.dat >> tmp1.dat
  grep -e 'M_ADM' ${file_bbhphy}_ra0${array[$i]}/bbhphyseq.dat >> tmp2.dat
  grep -e 'J    ' ${file_bbhphy}_ra0${array[$i]}/bbhphyseq.dat >> tmp3.dat
  grep -e 'AH mass   1st BH' ${file_bbhphy}_ra0${array[$i]}/bbhphyseq.dat >> \
                                                                  tmp4.dat
  cat ${file_bbhphy}_ra0${array[$i]}/bbhphyseq.dat >> ${file_bbhphy_all}
  i=`expr $i + 1`
done

sed -i '/1 - /d' tmp2.dat
sed -i 's/^.\{22\}//g' tmp1.dat
sed -i 's/^.\{22\}//g' tmp2.dat
sed -i 's/^.\{22\}//g' tmp3.dat
sed -i 's/^.\{22\}//g' tmp4.dat

echo '# Omega  M_ADM  J  AH mass  ' > ${file_bbhphy_ext}
paste tmp1.dat tmp2.dat  > tmp_a.dat
paste tmp_a.dat tmp3.dat > tmp_b.dat
paste tmp_b.dat tmp4.dat > tmp_c.dat

cat tmp_c.dat >> ${file_bbhphy_ext}
rm tmp*.dat
