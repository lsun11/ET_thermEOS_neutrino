rm -rf Cocal_test
cp -rfp ~/Cocal Cocal_test
cd Cocal_test/compile_scripts
sh update_all.sh
cd ../
cp -rfp ../work_area_RNS_2 .
cp executable_files/exe_RNS_CF_peos work_area_RNS_2/.
cp executable_files/exe_RNS_WL_peos work_area_RNS_2/.
cd work_area_RNS_2 
./exe_RNS_WL_peos
./exe_RNS_CF_peos
cd ../../
