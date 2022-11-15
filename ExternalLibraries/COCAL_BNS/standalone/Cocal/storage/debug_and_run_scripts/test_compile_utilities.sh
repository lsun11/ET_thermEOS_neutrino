rm -rf Cocal_debug/code
cd Cocal_debug
cp -rfp ~/Cocal/code .
#cp code/Module/phys_constant_3mpt.f90 code/Module/phys_constant.f90
sed -i "s/!  call grid_r_bhex/  call grid_r_bhex/g" code/Analysis/Subroutine/coordinate_patch_kit_grav_noGreen.f90
cd compile_scripts
#sh compile_debug_poisson_bh_2pot_mpt_plot.sh

sh compile_debug_poisson_bh_2pot_plot.sh
cd ..

cp executable_files/exe_plot work_area_poisson_test/.
cp executable_files/exe_plot work_area_poisson_test_D1/.
cp executable_files/exe_plot work_area_poisson_test_D2/.
cp executable_files/exe_plot work_area_poisson_test_D3/.
cp executable_files/exe_plot work_area_poisson_test_D4/.
#./exe_plot
cd ../
