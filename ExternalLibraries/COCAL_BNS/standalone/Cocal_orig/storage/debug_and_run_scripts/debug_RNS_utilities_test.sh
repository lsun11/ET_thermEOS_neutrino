work_dir1=work_area_RNS_C020

cd Cocal_debug

cd ${work_dir1}
sed -i 's/1D   3D/3D   3D/g' rnspar.dat
cp ../../copy_lasini_3D.sh .
sh copy_lasini_3D.sh

cp ../data_analysis/MRNS_gnuplot_scripts/plot_contour*plt .
cp ../../parameter_sample/contour_plot/rnspar_cartesian.dat_RNS_contour \
        rnspar_cartesian.dat
(./exe_rns_plot > output_plot ; gnuplot plot_contour_FLU_RNS.plt ) &

#cp ../../parameter_sample/contour_plot/rnspar_cartesian.dat_RNS_vector \
#        rnspar_cartesian.dat
#./exe_rns_plot > output_plot &


#cd ../work_area_poisson_test_${name_flag}2
#./exe_plot > output_${name_flag}2_plot &

cd ../../
