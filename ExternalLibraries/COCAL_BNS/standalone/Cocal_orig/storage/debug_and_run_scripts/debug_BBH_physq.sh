workdir_name=Cocal_AHfinder_debug

rm -rf ${workdir_name}
cp -rfp ~/Cocal ${workdir_name}
#cp -rfp ~/Cocal_svn_check_inout/Cocal ${workdir_name}
cd ${workdir_name}

cp -rfp work_area_BNS work_area_BBH
cp -rfp ../work_area_samples/AH_finder_test/work_area_BBH_D* .
cp -rfp data_analysis/BBH_gnuplot_scripts/plot_*BBH.plt work_area_BBH_D2/.

cd compile_scripts
sh select_grgrad_midpoint_r3rd_bhex.sh
sh compile_BBH_CF_plot_type2.sh

cd ..
cp executable_files/exe_BBH_CF_plot  work_area_BBH_D1/.
cp executable_files/exe_BBH_CF_plot  work_area_BBH_D2/.

cd work_area_BBH_D2
sed -i 's/IN   3D/3D   3D/g' rnspar.dat
cp rnsflu_3D.las rnsflu_3D.ini
cp rnsgra_3D.las rnsgra_3D.ini
cp rnsgrids_3D.las rnsgrids_3D.ini

cp ../../parameter_sample/contour_plot/rnspar_cartesian.dat_BBH_contour \
        rnspar_cartesian.dat
./exe_BBH_CF_plot
gnuplot plot_contour_BBH.plt

cp ../../parameter_sample/contour_plot/rnspar_cartesian.dat_BBH_vector \
        rnspar_cartesian.dat
./exe_BBH_CF_plot
gnuplot plot_vector_BBH.plt

#cd ../work_area_BBH_D1
#cp rnsflu_3D.las rnsflu_3D.ini
#cp rnsgra_3D.las rnsgra_3D.ini
#cp rnsgrids_3D.las rnsgrids_3D.ini
#./exe_AHfinder
###
cd ../../
