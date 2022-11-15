rm -rf Cocal_debug
cp -rfp ~/Cocal Cocal_debug
cd Cocal_debug
cp -rfp work_area_BNS work_area_poisson_test
cd compile_scripts
sh compile_debug_poisson_bh_2pot_mpt.sh
sh compile_debug_poisson_bh_2pot_mpt_plot.sh
cd ../work_area_poisson_test
cp ../executable_files/exe_plot .
cp ../ctrl_area_BBH/* .
#cp ../../parameter_sample/bbh_mpt_eqm/*.* .
cp ../../parameter_sample/bbh_mpt/*.* .
./exe_bh_test
./exe_plot
cd ../../
