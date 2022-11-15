rm -rf Cocal_debug
cp -rfp ~/Cocal Cocal_debug
cd Cocal_debug
cp code/Module/phys_constant_3mpt.f90 code/Module/phys_constant.f90

cp -rfp work_area_BNS work_area_BBH
cd compile_scripts
sh compile_BBH_CF_3mpt.sh
sh compile_BBH_CF_3mpt_plot.sh

cd ..
cp executable_files/exe_BBH_CF      work_area_BBH/exe_bh_test
cp executable_files/exe_BBH_CF_plot work_area_BBH/exe_plot
cp ctrl_area_BBH/* work_area_BBH/.

cp -rfp work_area_BBH work_area_BBH_E2
cp ../parameter_sample/BBH_CF_3mpt/E2/*.* work_area_BBH_E2/.

cd work_area_BBH_E2
./exe_bh_test
./exe_plot

cd ../../
