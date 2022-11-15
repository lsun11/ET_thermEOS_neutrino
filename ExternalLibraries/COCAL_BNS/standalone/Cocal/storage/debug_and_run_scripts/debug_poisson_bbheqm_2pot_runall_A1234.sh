rm -rf Cocal_debug
cp -rfp ~/Cocal Cocal_debug
cd Cocal_debug

cp -rfp work_area_BNS work_area_poisson_test
cd compile_scripts
sh compile_debug_poisson_bh_2pot.sh
sh compile_debug_poisson_bh_2pot_plot.sh
cd ..
cp executable_files/exe_plot work_area_poisson_test/.
cp ctrl_area_BBH/* work_area_poisson_test/.

cp -rfp work_area_poisson_test work_area_poisson_test_A1
cp -rfp work_area_poisson_test work_area_poisson_test_A2
cp -rfp work_area_poisson_test work_area_poisson_test_A3
cp -rfp work_area_poisson_test work_area_poisson_test_A4

cp ../parameter_sample/bbh_eqm/A1/*.* work_area_poisson_test_A1/.
cp ../parameter_sample/bbh_eqm/A2/*.* work_area_poisson_test_A2/.
cp ../parameter_sample/bbh_eqm/A3/*.* work_area_poisson_test_A3/.
cp ../parameter_sample/bbh_eqm/A4/*.* work_area_poisson_test_A4/.

cd work_area_poisson_test_A1
./exe_bh_test > output_A1 &
cd ../work_area_poisson_test_A2
./exe_bh_test > output_A2 &
cd ../work_area_poisson_test_A3
./exe_bh_test > output_A3 &
cd ../work_area_poisson_test_A4
./exe_bh_test > output_A4 &

#cp ../../parameter_sample/bbh_eqm/*.* .
#./exe_plot
cd ../../
