STARTTIME=$(date +%s)

######################### Create the BNS ID directory ############################
#
#ID_dir_name="/home/atsok/irHd2.0_2H_230_ID"
ID_dir_name="/home/atsok/spHf2.0_SLy_231_2cor/work_area_BNS"
#ID_dir_name="/home/astro/shared/Cocal_ID/K123_ir_15vs15_Hs2d_45km"
#ID_dir_name="/home/bruno/scratch/initial_data/Cocal_ID/K123_ir_15vs15_Hs2d_45km"

sed -i "s/d/e/g" ${ID_dir_name}/peos_parameter*.dat
sed -i "s/E/e/g" ${ID_dir_name}/peos_parameter*.dat

if [ ! -d "ID_BNS" ]; then
  echo "Create folder ID_BNS..."
  mkdir ID_BNS
else
  echo "Remove existing folder ID_BNS and create a new one..."
  rm -rf  ID_BNS
  mkdir ID_BNS
#  exit 1
fi
#
##################################################################################

new_dir_name=tmpdir_eraseme

rm -rf ${new_dir_name}
cp -rfp ./Cocal   ${new_dir_name}
cd ${new_dir_name}

cd compile_scripts
echo "compile_coc2cac_ini.sh..."

#sh compile_coc2cac.sh            # Original coc2cac. Only for irrotational.
#sh compile_coc2cac_co.sh         # Only for corotating.
#sh compile_coc2cac_ir.sh         # Only for irrotational.
#sh compile_coc2cac_sp.sh         # Only for spinning.
sh compile_coc2cac_ini.sh         # All cases

cd ../../ID_BNS
for i in `/bin/ls $ID_dir_name `; do  ln -s ${ID_dir_name}/$i ;  done
rm -rf *.plt *.f90 exe_BNS*

./exe_coc2cac
#coc2cac_pid=`echo $!`
#echo $! > coc2cac_pid.txt

cd ..  # Now we are in Coc2Cac
cd ..

ENDTIME=$(date +%s)
echo "----------------------------------------------------------------"
echo "It took $(($ENDTIME - $STARTTIME)) seconds to complete this run."


