rm -rf Cocal_debug
cp -rfp ~/Cocal Cocal_debug
cp Cocal_debug/code/Module/phys_constant_3mpt.f90 Cocal_debug/code/Module/phys_constant.f90
cd Cocal_debug
cp -rfp work_area_BNS work_area_poisson_test
cd compile_scripts
sh compile_debug_poisson_bh_2pot_3mpt.sh
sh compile_debug_poisson_bh_2pot_mpt_plot.sh
cd ../
cp executable_files/exe_plot work_area_poisson_test/.
cp ctrl_area_BBH/* work_area_poisson_test/.

cp -rfp work_area_poisson_test work_area_poisson_test_D1
cp -rfp work_area_poisson_test work_area_poisson_test_D2
cp -rfp work_area_poisson_test work_area_poisson_test_D3
cp -rfp work_area_poisson_test work_area_poisson_test_D4
      
cp ../parameter_sample/bbh_3mpt/D1/*.* work_area_poisson_test_D1/.
cp ../parameter_sample/bbh_3mpt/D2/*.* work_area_poisson_test_D2/.
cp ../parameter_sample/bbh_3mpt/D3/*.* work_area_poisson_test_D3/.
cp ../parameter_sample/bbh_3mpt/D4/*.* work_area_poisson_test_D4/.

cd work_area_poisson_test_D1
./exe_bh_test > output_D1 &
cd ../work_area_poisson_test_D2
./exe_bh_test > output_D2 &
cd ../work_area_poisson_test_D3
./exe_bh_test > output_D3 &
cd ../work_area_poisson_test_D4
./exe_bh_test > output_D4 &

#cp ../../parameter_sample/bbh_mpt_eqm/*.* .
#./exe_plot
cd ../../
