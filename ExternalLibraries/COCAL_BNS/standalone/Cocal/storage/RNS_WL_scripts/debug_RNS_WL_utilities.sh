work_dir_name=work_area_RNS
array_dir=( C020 )

cd Cocal_debug
cp executable_files/exe_RNS_plot  ./${work_dir_name}/.
cp executable_files/exe_RNS_plot  ./${work_dir_name}_${array_dir[$i]}/.

cd ${work_dir_name}_${array_dir[$i]}
sed -i 's/1D   3D/3D   3D/g' rnspar.dat
cp ../../copy_lasini_3D.sh .
sh copy_lasini_3D.sh

cp ../data_analysis/MRNS_gnuplot_scripts/plot*plt .
#cp ../../parameter_sample/contour_plot/rnspar_cartesian.dat_RNS_contour \
#        rnspar_cartesian.dat
#./exe_RNS_plot > output_plot &

cp ../../parameter_sample/contour_plot/rnspar_cartesian.dat.low \
        rnspar_cartesian.dat
./exe_RNS_plot > output_plot_low
mkdir data_vector_plot
mv rns_contour*.dat data_vector_plot/.
mv rnspar_cartesian.dat data_vector_plot/.

cp ../../parameter_sample/contour_plot/rnspar_cartesian.dat.mid \
        rnspar_cartesian.dat
./exe_RNS_plot > output_plot_mid
mkdir data_vector_plot_mid
mv rns_contour*.dat data_vector_plot_mid/.
mv rnspar_cartesian.dat data_vector_plot_mid/.

cp ../../parameter_sample/contour_plot/rnspar_cartesian.dat.high \
        rnspar_cartesian.dat
./exe_RNS_plot > output_plot
#./exe_RNS_plot > output_plot &

cd ../../
