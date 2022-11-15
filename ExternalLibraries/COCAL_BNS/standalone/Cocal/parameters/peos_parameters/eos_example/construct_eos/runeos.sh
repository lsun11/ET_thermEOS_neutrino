#Initially peos_parameter should look something like this:
#
#            2  3.47187d+14     : nphase, rhoini
#  5.01187d+14  3.16227d+34     : rho_0, pre_0
#  1.00000d+18  3.00000d+00     : rho, gamma
#  1.00000d+15  3.00000d+00     : rho, gamma
#  5.01187d+14  3.00000d+00     : rho, gamma
#
# Modify from peos_parameter.dat only pre_0 (this is p_1 from JR paper)
# of second line and run this script. Then attach output to the peos_parameter.dat 
# and change number of interval from 2 to 4. This is going to be the
#final peos_parameter.dat

gfortran phys_constant.f90 def_peos_parameter.f90 peos_lookup.f90 find_crust_rho.f90

rm -f *.mod
