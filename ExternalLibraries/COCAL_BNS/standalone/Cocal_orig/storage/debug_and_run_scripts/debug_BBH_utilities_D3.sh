cd Cocal_debug

cd work_area_BBH_D3_TU
mv rnsflu_3D.las rnsflu_3D.ini
mv rnsgra_3D.las rnsgra_3D.ini
mv rnsgrids_3D.las rnsgrids_3D.ini
./exe_plot > output_D3_plot &

cd ../work_area_BBH_D3_TU2007
mv rnsflu_3D.las rnsflu_3D.ini
mv rnsgra_3D.las rnsgra_3D.ini
mv rnsgrids_3D.las rnsgrids_3D.ini
./exe_plot > output_D3_plot &

cd ../work_area_BBH_D3_AH_n0=0.1
mv rnsflu_3D.las rnsflu_3D.ini
mv rnsgra_3D.las rnsgra_3D.ini
mv rnsgrids_3D.las rnsgrids_3D.ini
./exe_plot > output_D3_plot &

cd ../work_area_BBH_D3_AH_n0=0.005
mv rnsflu_3D.las rnsflu_3D.ini
mv rnsgra_3D.las rnsgra_3D.ini
mv rnsgrids_3D.las rnsgrids_3D.ini
./exe_plot > output_D3_plot &

cd ../../
