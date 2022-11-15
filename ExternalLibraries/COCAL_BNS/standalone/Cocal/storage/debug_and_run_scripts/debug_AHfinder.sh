workdir_name=Cocal_AHfinder_debug

rm -rf ${workdir_name}
cp -rfp ~/Cocal ${workdir_name}
cd ${workdir_name}

cp -rfp work_area_BNS work_area_BBH
cp -rfp ../work_area_samples/AH_finder_test/work_area_BBH_D* .
cp -rfp ../work_area_samples/AH_finder_test/work_area_BBH_D* .
cd compile_scripts
sh select_grgrad_midpoint_r3rd_bhex.sh
sh compile_AHfinder.sh


cd ..
cp executable_files/exe_AHfinder  work_area_BBH_D1/.
cp executable_files/exe_AHfinder  work_area_BBH_D2/.

cd work_area_BBH_D2
sed -i 's/IN   3D/3D   3D/g' rnspar.dat
cp rnsflu_3D.las rnsflu_3D.ini
cp rnsgra_3D.las rnsgra_3D.ini
cp rnsgrids_3D.las rnsgrids_3D.ini
./exe_AHfinder
#cd ../work_area_BBH_D1
#cp rnsflu_3D.las rnsflu_3D.ini
#cp rnsgra_3D.las rnsgra_3D.ini
#cp rnsgrids_3D.las rnsgrids_3D.ini
#./exe_AHfinder
###
cd ../../
