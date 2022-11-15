rm -rf Cocal_debug_1bh
cp -rfp ~/Cocal Cocal_debug_1bh
cd Cocal_debug_1bh

cp -rfp work_area_BNS work_area_poisson_test
cd compile_scripts
sh compile_debug_poisson_1bh_2pot.sh
sh compile_debug_poisson_1bh_plot.sh
cd ..
cp executable_files/exe_plot work_area_poisson_test/.
cp ctrl_area_BBH/* work_area_poisson_test/.

cp -rfp work_area_poisson_test work_area_poisson_test_B1
cp -rfp work_area_poisson_test work_area_poisson_test_B2
cp -rfp work_area_poisson_test work_area_poisson_test_B3
cp -rfp work_area_poisson_test work_area_poisson_test_B4

cp ../parameter_sample/1bh/B1/*.* work_area_poisson_test_B1/.
cp ../parameter_sample/1bh/B2/*.* work_area_poisson_test_B2/.
cp ../parameter_sample/1bh/B3/*.* work_area_poisson_test_B3/.
cp ../parameter_sample/1bh/B4/*.* work_area_poisson_test_B4/.

cd work_area_poisson_test_B1
./exe_bh_test > output_B1 &
cd ../work_area_poisson_test_B2
./exe_bh_test > output_B2 &
cd ../work_area_poisson_test_B3
./exe_bh_test > output_B3 &
cd ../work_area_poisson_test_B4
./exe_bh_test > output_B4 &

#cp ../../parameter_sample/bbh_eqm/*.* .
#./exe_plot
cd ../../
