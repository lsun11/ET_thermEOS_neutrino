rm -rf Cocal_debug
cp -rfp ~/Cocal Cocal_debug
cd Cocal_debug

cp -rfp work_area_BNS work_area_BBH
cd compile_scripts
sh compile_BBH_CF.sh
sh compile_BBH_CF_plot_type1.sh

cd ..
cp executable_files/exe_BBH_CF      work_area_BBH/exe_bh_test
cp executable_files/exe_BBH_CF_plot work_area_BBH/exe_plot
cp ctrl_area_BBH/* work_area_BBH/.

cp -rfp work_area_BBH work_area_BBH_D3_TU
cp ../parameter_sample/bbh_CF_test/D3_TU/*.* work_area_BBH_D3_TU/.
cp -rfp work_area_BBH work_area_BBH_D3_TU2007
cp ../parameter_sample/bbh_CF_test/D3_TU2007/*.* work_area_BBH_D3_TU2007/.
cp -rfp work_area_BBH work_area_BBH_D3_AH_n0=0.1
cp ../parameter_sample/bbh_CF_test/D3_AH_n0=0.1/*.* work_area_BBH_D3_AH_n0=0.1/.
cp -rfp work_area_BBH work_area_BBH_D3_AH_n0=0.005
cp ../parameter_sample/bbh_CF_test/D3_AH_n0=0.005/*.* work_area_BBH_D3_AH_n0=0.005/.


cd work_area_BBH_D3_TU
./exe_bh_test > output_D3 &

cd ../work_area_BBH_D3_TU2007
./exe_bh_test > output_D3 &

cd ../work_area_BBH_D3_AH_n0=0.1
./exe_bh_test > output_D3 &

cd ../work_area_BBH_D3_AH_n0=0.005
./exe_bh_test > output_D3 &

cd ../../
