rm -rf Cocal_debug
cp -rfp ~/Cocal Cocal_debug
cd Cocal_debug
cp -rfp work_area_BNS work_area_poisson_test
cd compile_scripts
sh compile_debug_poisson_1bh_2pot.sh
sh compile_debug_poisson_1bh_plot.sh
cd ../work_area_poisson_test
cp ../executable_files/exe_plot .
cp ../ctrl_area_BBH/* .
#cp ../../parameter_sample/*.* .
cp ../../parameter_sample/1bh/G1/*.* .
./exe_bh_test
./exe_plot
cd ../../
