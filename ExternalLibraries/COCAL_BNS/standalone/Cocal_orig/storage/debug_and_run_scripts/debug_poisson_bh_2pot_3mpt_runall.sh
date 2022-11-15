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

cp -rfp work_area_poisson_test work_area_poisson_test_small
cp -rfp work_area_poisson_test work_area_poisson_test_middle
cp -rfp work_area_poisson_test work_area_poisson_test_large
      
cp ../parameter_sample/bbh_3mpt/mpt12_rgout=100_small/*.* work_area_poisson_test_small/.
cp ../parameter_sample/bbh_3mpt/mpt12_rgout=100_middle/*.* work_area_poisson_test_middle/.
cp ../parameter_sample/bbh_3mpt/mpt12_rgout=100_large/*.* work_area_poisson_test_large/.

cd work_area_poisson_test_small
./exe_bh_test > output_small &
cd ../work_area_poisson_test_middle
./exe_bh_test > output_middle &
cd ../work_area_poisson_test_large
./exe_bh_test > output_large &

#cp ../../parameter_sample/bbh_mpt_eqm/*.* .
#./exe_plot
cd ../../
