rm -rf Cocal_debug
cp -rfp ~/Cocal Cocal_debug
cd Cocal_debug

cp -rfp work_area_BNS work_area_BBH
cd compile_scripts
sh select_grgrad_midpoint_r3rd_bhex.sh
sh compile_BBH_CF.sh
sh compile_BBH_CF_plot_type1.sh

cd ..
cp executable_files/exe_BBH_CF      work_area_BBH/exe_bh_test
cp executable_files/exe_BBH_CF_plot work_area_BBH/exe_plot
cp ctrl_area_BBH/* work_area_BBH/.

cp -rfp work_area_BBH work_area_BBH_D1
cp ../parameter_sample/bbh_eqm_TU/D1/*.* work_area_BBH_D1/.
cp -rfp work_area_BBH work_area_BBH_D2
cp ../parameter_sample/bbh_eqm_TU/D2/*.* work_area_BBH_D2/.

cd work_area_BBH_D2
#./exe_bh_test > output_D2 
./exe_bh_test > output_D2 &
#./exe_plot
cd ../work_area_BBH_D1
./exe_bh_test > output_D1 &
#./exe_bh_test

cd ../../
