# Last modified 30/01/2018 
#
STARTTIME=$(date +%s)

#############################################################################
#  Select what kind of system to simulate:                                  #
#  BNS  : Binary neutron stars                                              #
#  BBH  : Binary black holes                                                #
#  BHT  : Black hole torus system                                           #
#  RNS  : Rotating NS is conformal flat approximation                       #
#  RNSwl: Rotating NS is waveless formalism                                 #
#                                                                           #
compact_object=BNS
#                                                                           #
#############################################################################

original_code=Cocal_orig
new_dir_name=Cocal
FCOMP=gfortran
#FCOMP=ifort
FFLAGS=
#-O2

if [ ! -d "${original_code}" ]; then
  echo "Directory ${original_code} does not exist."
  echo "${original_code} should have the new version of the standalone COCAL code...exiting"
  exit 1
fi

rm -rf ${new_dir_name}
cp -rfp ./Cocal_orig   ${new_dir_name}

echo "Preparing files..."
cd ${new_dir_name}/compile_scripts

if [ ${compact_object} == BNS ]; then
  echo "Compact object is BNS."
  sh select_weight_calc_midpoint_grav_th4th.sh
elif [ ${compact_object} == BBH ]; then
  echo "Compact object is BBH."
  sh select_grid_r_bhex.sh
  sh select_grgrad_midpoint_r3rd_bhex.sh
  sh select_grgrad_gridpoint_4th_bhex.sh
  sh select_weight_calc_midpoint_grav_th4th.sh
elif [ ${compact_object} == BHT ]; then
  echo "Compact object is BHT."
  sh select_grgrad_midpoint_r3rd_bhex.sh
  sh select_grgrad_gridpoint_4th_bhex.sh
  sh select_weight_calc_midpoint_grav_th4th.sh
elif [ ${compact_object} == RNS ]; then
  echo "Compact object is RNS in conformal flat approximation."
  sh select_grgrad_midpoint_r3rd_NS.sh
  sh select_grgrad_gridpoint_4th_NS.sh
  sh select_weight_calc_midpoint_grav_th4th.sh
  sh select_reset_fluid_radius_le_1.sh
  sh select_correct_matter_source_out.sh
  sh select_calc_surface_quad.sh
  sh select_robust_convergence.sh
elif [ ${compact_object} == RNSwl ]; then
  echo "Compact object is RNS in waveless formalism."
  sh select_grgrad_midpoint_r3rd_NS.sh
  sh select_grgrad_gridpoint_4th_NS.sh
  sh select_weight_calc_midpoint_grav_th4th.sh
  sh select_reset_fluid_radius_le_1.sh
  sh select_correct_matter_source_out.sh
  sh select_calc_surface_quad.sh
  sh select_robust_convergence.sh
else
  echo "Flag ${compact_object} should be one of {BNS,BBH,BHT,RNS,RNSwl}...exiting"
  exit 1
fi
sh cactus_eps_conflict.sh


echo "Copying files to src directory..."
cd ../code/Main_utility
/bin/cp -f coc2cac_ini.f90 coc2cac_ini_sub.F90    ../../../../src/Main_utility/
cd ..
/bin/cp -rf Analysis ../../../src/
/bin/cp -rf EOS ../../../src/
/bin/cp -rf Function ../../../src/
/bin/cp -rf Include_file ../../../src/
/bin/cp -rf Module ../../../src/
/bin/cp -rf Module_interface ../../../src/
/bin/cp -rf Module_mpatch ../../../src/
/bin/cp -rf Subroutine ../../../src/
/bin/cp -rf Subroutine_mpatch ../../../src/


ENDTIME=$(date +%s)
echo "----------------------------------------------------------------"
echo "It took $(($ENDTIME - $STARTTIME)) seconds to complete this run."
