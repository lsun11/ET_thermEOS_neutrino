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

cp -rfp work_area_poisson_test work_area_poisson_test_C1
cp -rfp work_area_poisson_test work_area_poisson_test_C2
cp -rfp work_area_poisson_test work_area_poisson_test_C3
cp -rfp work_area_poisson_test work_area_poisson_test_C4

cp ../parameter_sample/bbh_eqm/C1/*.* work_area_poisson_test_C1/.
cp ../parameter_sample/bbh_eqm/C2/*.* work_area_poisson_test_C2/.
cp ../parameter_sample/bbh_eqm/C3/*.* work_area_poisson_test_C3/.
cp ../parameter_sample/bbh_eqm/C4/*.* work_area_poisson_test_C4/.

cd work_area_poisson_test_C1
./exe_bh_test > output_C1 &
cd ../work_area_poisson_test_C2
./exe_bh_test > output_C2 &
cd ../work_area_poisson_test_C3
./exe_bh_test > output_C3 &
cd ../work_area_poisson_test_C4
./exe_bh_test > output_C4 &

#cp ../../parameter_sample/bbh_eqm/*.* .
#./exe_plot
cd ../../
