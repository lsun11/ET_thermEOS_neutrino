rm -rf Cocal_debug
cp -rfp ~/Cocal Cocal_debug
cd Cocal_debug
cp -rfp work_area_BNS work_area_poisson_test
cd compile_scripts
sh compile_debug_poisson_bh_2pot_mpt.sh
sh compile_debug_poisson_bh_2pot_mpt_plot.sh
cd ../
cp executable_files/exe_plot work_area_poisson_test/.
cp ctrl_area_BBH/* work_area_poisson_test/.

cp -rfp work_area_poisson_test work_area_poisson_test_E1
cp -rfp work_area_poisson_test work_area_poisson_test_E2
cp -rfp work_area_poisson_test work_area_poisson_test_E3
cp -rfp work_area_poisson_test work_area_poisson_test_E4
      
cp ../parameter_sample/bbh_mpt/E1/*.* work_area_poisson_test_E1/.
cp ../parameter_sample/bbh_mpt/E2/*.* work_area_poisson_test_E2/.
cp ../parameter_sample/bbh_mpt/E3/*.* work_area_poisson_test_E3/.
cp ../parameter_sample/bbh_mpt/E4/*.* work_area_poisson_test_E4/.

cd work_area_poisson_test_E1
./exe_bh_test > output_E1 &
cd ../work_area_poisson_test_E2
./exe_bh_test > output_E2 &
cd ../work_area_poisson_test_E3
./exe_bh_test > output_E3 &
cd ../work_area_poisson_test_E4
./exe_bh_test > output_E4 &

#cp ../../parameter_sample/bbh_mpt_eqm/*.* .
#./exe_plot
cd ../../
