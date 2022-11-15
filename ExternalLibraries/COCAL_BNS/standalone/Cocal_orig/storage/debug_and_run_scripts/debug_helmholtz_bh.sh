rm -rf Cocal_debug_helm_bh/code
cp -rfp ~/Cocal/code Cocal_debug_helm_bh/.
cd Cocal_debug_helm_bh
#cp -rfp work_area_BNS work_area_helmholtz_test
cd compile_scripts
#sh compile_debug_helmholtz_bh.sh
sh compile_debug_helmholtz.sh
sh compile_debug_poisson_plot_mpt.sh
cd ../work_area_helmholtz_test
cp ../executable_files/exe_plot .
#cp ../ctrl_area_BBH/* .
#cp rnspar_helmholtz.dat rnspar.dat
#./exe_bh_test
./exe_helm_test
./exe_plot
cd ../../
