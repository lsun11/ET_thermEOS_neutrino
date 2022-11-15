rm -rf Cocal_debug/code
cp -rfp ~/Cocal/code Cocal_debug/code
cd Cocal_debug
cp code/Module/phys_constant_3mpt.f90 code/Module/phys_constant.f90

cd compile_scripts
sh compile_BBH_CF_3mpt_plot.sh

cd ..
cp executable_files/exe_BBH_CF_plot work_area_BBH/exe_plot
cp executable_files/exe_BBH_CF_plot work_area_BBH_E1/exe_plot

cd work_area_BBH_E1
./exe_plot

cd ../../
