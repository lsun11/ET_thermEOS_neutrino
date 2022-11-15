cd Cocal_debug

cd work_area_BBH_D1
cp rnsflu_3D.las rnsflu_3D.ini
cp rnsgra_3D.las rnsgra_3D.ini
cp rnsgrids_3D.las rnsgrids_3D.ini
./exe_plot > output_D1_plot &
cd ../work_area_BBH_D2
cp rnsflu_3D.las rnsflu_3D.ini
cp rnsgra_3D.las rnsgra_3D.ini
cp rnsgrids_3D.las rnsgrids_3D.ini
./exe_plot > output_D2_plot &

cd ../../
