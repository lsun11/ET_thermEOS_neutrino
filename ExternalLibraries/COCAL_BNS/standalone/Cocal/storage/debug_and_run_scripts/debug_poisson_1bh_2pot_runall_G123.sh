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

cp -rfp work_area_poisson_test work_area_poisson_test_G1
cp -rfp work_area_poisson_test work_area_poisson_test_G2
cp -rfp work_area_poisson_test work_area_poisson_test_G3

cp ../parameter_sample/1bh/G1/*.* work_area_poisson_test_G1/.
cp ../parameter_sample/1bh/G2/*.* work_area_poisson_test_G2/.
cp ../parameter_sample/1bh/G3/*.* work_area_poisson_test_G3/.

cd work_area_poisson_test_G1
./exe_bh_test > output_G1 &
cd ../work_area_poisson_test_G2
./exe_bh_test > output_G2 &
cd ../work_area_poisson_test_G3
./exe_bh_test > output_G3 &

#cp ../../parameter_sample/bbh_eqm/*.* .
#./exe_plot
cd ../../
