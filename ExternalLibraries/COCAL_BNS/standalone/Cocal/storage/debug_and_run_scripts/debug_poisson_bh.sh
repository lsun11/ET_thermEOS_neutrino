rm -rf Cocal_debug_1mpt
cp -rfp ~/Cocal Cocal_debug_1mpt
cd Cocal_debug_1mpt
cp -rfp work_area_BNS work_area_poisson_test
cd compile_scripts
sh compile_debug_poisson_bh.sh
sh compile_debug_poisson_plot.sh
cd ../work_area_poisson_test
cp ../executable_files/exe_plot .
cp ../ctrl_area_BBH/* .
./exe_bh_test
./exe_plot
cd ../../
