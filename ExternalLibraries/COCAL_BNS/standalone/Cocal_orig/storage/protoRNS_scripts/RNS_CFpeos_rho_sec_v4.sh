#==============================================================================
#
# Starting from a number of TOV points compute vertical sequence (same density)
# of rotating stars with increasing deformation. There are 4 different variables
# used in this script which are:
#
# NUMBER_TOV_POINTS : is the number of initial TOV points. This is the number
#                     of sequences constructed.
#                     
# STARTING_DENSITY, STEP_DENSITY : The sequences constructed, start with lower
#                                  density STARTING_DENSITY and increase
#                                  at steps of STEP_DENSITY.
#
# In other words the densities of the vertical sequences belong to the interval
# [STARTING_DENSITY, STARTING_DENSITY + i*STEP_DENSITY]
# where i runs from 0 to NUMBER_TOV_POINTS-1.
#
# One should also set the initial deformation in variable "nrf_deform". This
# is usually set to be equal with nrf-1, according to param_flag.
#
#------------------------------------------------------------------------------
#
# Although the script can be used independently, it is designed to work with 
# another script called calc_rhoc.sh whose purpose is to create a number of
# scripts like this one with different STARTING_DENSITY in order to be used
# by different nodes in a HPC. Script calc_rhoc.sh will create scripts
# RNS_CFpeos_rho_sec_v4_iNODE.sh which can then be run immediately.
#
#==============================================================================
param_flag=H3
# Set first rotating model deformation. Change according to param_flag.
# Typical value nrf_deform=nrf-1
nrf_deform=126
 
eos_flag=K123.6
eos_dir_name=../parameter_sample/EOS
param_dir_name=../parameter_sample/RNS_CF
work_dir_name=work_area_RNS
ctrl_dir_name=ctrl_area_RNS
new_dir_name=rns${param_flag}_${eos_flag}_test_iNODE

#num_seq=10    # Number of TOV initial points
num_seq=NUMBER_TOV_POINTS

rm -rf ${new_dir_name}
rm -rf tmpdir
mkdir tmpdir
tar czf tmpcoc.tar.gz ./Cocal  --exclude='.svn'
mv tmpcoc.tar.gz  ./tmpdir/
cd tmpdir
tar xzf tmpcoc.tar.gz
mv Cocal ../${new_dir_name}
cd ..
rm -rf tmpdir
cd ${new_dir_name}
pwd

#rm -rf ${new_dir_name}
#cp -rfp ./Cocal   ${new_dir_name}
#cd ${new_dir_name}

cd compile_scripts
sh select_grgrad_midpoint_r3rd_NS.sh
sh select_grgrad_gridpoint_4th_NS.sh
sh select_weight_calc_midpoint_grav_th4th.sh
#sh compile_TOV.sh
#sh compile_1Dini.sh
sh compile_TOV_isotr.sh
sh compile_Import_isotr.sh
sh compile_Main_RNS_CF_peos.sh
sh compile_Main_RNS_CF_peos_plot.sh
cd ../

cp executable_files/exe_TOV_peos     ${work_dir_name}/.
cp executable_files/exe_RNS_CF_peos  ${work_dir_name}/.
cp executable_files/exe_RNS_plot     ${work_dir_name}/.

cp ${param_dir_name}/${param_flag}/*.* ${work_dir_name}/.
cp ${param_dir_name}/${param_flag}/*.* ${ctrl_dir_name}/.

cp ${eos_dir_name}/${eos_flag}/peos_parameter.dat  ./${work_dir_name}/.
cp ${eos_dir_name}/${eos_flag}/peos_parameter.dat  ./${ctrl_dir_name}/.

# Set the rotating sequence characteristics
sed -i 's/DR/UR/g'                                 ${work_dir_name}/rnspar_drot.dat
sed -i "3s:\(.\{10\}\)\(.\{10\}\):\1   ML   XZ:"   ${work_dir_name}/rnspar.dat
sed -i "12s:\(.\{0\}\)\(.\{10\}\):\1   70   -2:"   ${work_dir_name}/rnspar.dat
sed -i "6s:\(.\{5\}\)\(.\{5\}\):\1    n:"          ${work_dir_name}/rnspar.dat
sed -i "2s:\(.\{0\}\)\(.\{10\}\):\1    1    0:"    ${work_dir_name}/ovpar_peos.dat

sed -i 's/DR/UR/g'                                 ${ctrl_dir_name}/rnspar_drot.dat
sed -i "3s:\(.\{10\}\)\(.\{10\}\):\1   ML   XZ:"   ${ctrl_dir_name}/rnspar.dat
sed -i "12s:\(.\{0\}\)\(.\{10\}\):\1   70   -2:"   ${ctrl_dir_name}/rnspar.dat
sed -i "6s:\(.\{5\}\)\(.\{5\}\):\1    n:"          ${ctrl_dir_name}/rnspar.dat
sed -i "2s:\(.\{0\}\)\(.\{10\}\):\1    1    0:"    ${ctrl_dir_name}/ovpar_peos.dat

#======================================================================
# First central rest mass density, and step density. 
#rhoca=$(echo "0.1*10^(15)" | bc -l)
rhoca=$(echo "STARTING_DENSITY" | bc -l)
#drhoc=$(echo "0.0046*10^(15)" | bc -l)
drhoc=$(echo "STEP_DENSITY" | bc -l)

# Loop over the number of TOV initial points.
for ((j=0; j < ${num_seq}; j++))
do
  if [ $j -le 9 ]; then
    seqj=00${j}
  elif [ $j -gt 9 -a $j -le 99 ]; then
    seqj=0${j}
  else
    seqj=${j}
  fi 
##======================================================================
# Prepare appropriate TOV solution
#
  cd ctrl_area_RNS
# Make sure that 5 first decimals are different for different sequences.
  rhoc1=$(echo "$rhoca + ($j)*($drhoc)" | bc -l)
  rhoc=$(printf "%1.5e\n"  "$rhoc1")
  printf "\n\n"
  echo "**************** Sequence $((j+1)) at ${rhoc} *************************"
  sed -i "1s:\(.\{13\}\)\(.\{13\}\):\1  ${rhoc}:"  peos_parameter.dat

#  sh calc-1_model_parameter.sh
#  sh calc-2_update_rnspar.sh
#  sh calc-3_1D_initial_iso.sh
#  sh calc-4_update_1D_initial.sh
#  sh calc-5_prepare_work_area_RNS.sh
  sh prepare_TOV_iso.sh
  cd ../

#======================================================================
# Create new rotating solution sequence directory
#
  cp -rfp ${work_dir_name} ${work_dir_name}_${seqj}
  cd ${work_dir_name}_${seqj}/.

# Set first rotating model deformation. Change according to param_flag.
  if [ $nrf_deform -le 99 ]; then
    sed -i "3s:\(.\{0\}\)\(.\{5\}\):\1   ${nrf_deform}:"    rnspar.dat
  else
    sed -i "3s:\(.\{0\}\)\(.\{5\}\):\1  ${nrf_deform}:"    rnspar.dat
  fi

# Restrict output 3D initial data.
  if [ $j -eq 0 ] || [ $j -eq 2 ]; then
    sed -i "9s:\(.\{5\}\)\(.\{5\}\):\1   0D:"    rnspar.dat
  else
    sed -i "9s:\(.\{5\}\)\(.\{5\}\):\1   0D:"    rnspar.dat
  fi

  ./exe_RNS_CF_peos > output &
  RNSpid=`echo $!`
  echo $! > save_pid.txt
  cd ../ 
done

cd ../../
