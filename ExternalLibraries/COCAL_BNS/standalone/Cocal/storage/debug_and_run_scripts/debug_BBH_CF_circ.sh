rm -rf Cocal_debug
cp -rfp ./Cocal Cocal_debug
cd Cocal_debug

cp -rfp work_area_BNS work_area_BBH
cd compile_scripts
sh compile_BBH_CF_circ.sh
#sh compile_BBH_CF_plot_type2.sh

cd ..
cp executable_files/exe_BBH_CF      work_area_BBH/exe_bh_test
#cp executable_files/exe_BBH_CF_plot work_area_BBH/exe_plot
cp ctrl_area_BBH/* work_area_BBH/.

#cp -rfp work_area_BBH work_area_BBH_D1
#cp ../parameter_sample/bbh_eqm/D1/*.* work_area_BBH_D1/.
cp -rfp work_area_BBH work_area_BBH_D2
cp ../parameter_sample/bbh_eqm/D2/*.* work_area_BBH_D2/.
#cp -rfp work_area_BBH work_area_BBH_I2
#cp ../parameter_sample/bbh_eqm/I2/D15/*.* work_area_BBH_I2/.

#cd work_area_BBH_D1
#./exe_bh_test 

cd work_area_BBH_D2
./exe_bh_test 

cd ../../
