cd Cocal_debug
cd work_area_poisson_test_small_l=12
./exe_plot > output_small_l=12_plot &
cd ../work_area_poisson_test_middle_l=12
./exe_plot > output_middle_l=12_plot &
cd ../work_area_poisson_test_large_l=12
./exe_plot > output_large_l=12_plot &
cd ../work_area_poisson_test_large_l=16
./exe_plot > output_large_l=16_plot &
cd ../work_area_poisson_test_large_l=20
./exe_plot > output_large_l=20_plot &

cd ../../
