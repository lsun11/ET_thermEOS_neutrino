#rm -rf Cocal_debug_2mpt
#cp -rfp ~/Cocal Cocal_debug_2mpt
#cd Cocal_debug_2mpt
rm -rf Cocal_debug_2mpt_noneqm
cp -rfp ~/Cocal Cocal_debug_2mpt_noneqm
cd Cocal_debug_2mpt_noneqm

cp -rfp work_area_BNS work_area_poisson_test
cd compile_scripts
sh compile_debug_poisson_bh_2pot_mpt.sh
sh compile_debug_poisson_bh_2pot_mpt_plot.sh
cd ../
cp executable_files/exe_plot work_area_poisson_test/.
cp ctrl_area_BBH/* work_area_poisson_test/.

cp -rfp work_area_poisson_test work_area_poisson_test_G1
cp -rfp work_area_poisson_test work_area_poisson_test_G2
cp -rfp work_area_poisson_test work_area_poisson_test_G3

#cp ../parameter_sample/bbh_mpt_eqm/G1/*.* work_area_poisson_test_G1/.
#cp ../parameter_sample/bbh_mpt_eqm/G2/*.* work_area_poisson_test_G2/.
#cp ../parameter_sample/bbh_mpt_eqm/G3/*.* work_area_poisson_test_G3/.
cp ../parameter_sample/bbh_mpt/G1/*.* work_area_poisson_test_G1/.
cp ../parameter_sample/bbh_mpt/G2/*.* work_area_poisson_test_G2/.
cp ../parameter_sample/bbh_mpt/G3/*.* work_area_poisson_test_G3/.

cd work_area_poisson_test_G1
./exe_bh_test > output_G1 &
cd ../work_area_poisson_test_G2
./exe_bh_test > output_G2 &
cd ../work_area_poisson_test_G3
./exe_bh_test > output_G3 &

#cp ../../parameter_sample/bbh_mpt_eqm/*.* .
#./exe_plot
cd ../../
