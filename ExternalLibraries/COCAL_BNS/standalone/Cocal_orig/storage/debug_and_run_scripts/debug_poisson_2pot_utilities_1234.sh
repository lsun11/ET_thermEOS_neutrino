name_flag=G

cd Cocal_debug
cd work_area_poisson_test_${name_flag}1
./exe_plot > output_${name_flag}1_plot &
cd ../work_area_poisson_test_${name_flag}2
./exe_plot > output_${name_flag}2_plot &
cd ../work_area_poisson_test_${name_flag}3
./exe_plot > output_${name_flag}3_plot &
cd ../work_area_poisson_test_${name_flag}4
./exe_plot > output_${name_flag}4_plot &

cd ../../
