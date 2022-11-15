#set terminal postscript enhanced eps color dashed "Helvetica" 16
set terminal postscript enhanced eps color solid "Helvetica" 16
set xlabel "{/Helvetica=38 x}"
set grid
set mxtics 5
set mytics 2

set logscale y
set format y "10^{%L}"
set zero 1e-20
set mxtics 4 ; set mytics 10
set pointsize 1.6
set ticscale  2 1

set xrange [-20:20]
set yrange [0.001:100]
set ylabel "{/Symbol=32 dy}/{/Symbol=32 y}[%]"
#set term x11 1
set output 'plot_2pot_averaged_error_3mpt_psi.eps'
plot \
"../work_area_poisson_test_small_l=12/plot_averaged_error_mpt1.dat" \
u 1:2 w l lt 1 lw 2 notitle, \
"../work_area_poisson_test_small_l=12/plot_averaged_error_mpt2.dat" \
u 1:2 w l lt 1 lw 2 notitle, \
"../work_area_poisson_test_small_l=12/plot_averaged_error_mpt3.dat" \
u 1:2 w l lt 1 lw 2 notitle, \
"../work_area_poisson_test_middle_l=12/plot_averaged_error_mpt1.dat" \
u 1:2 w l lt 2 lw 2 notitle, \
"../work_area_poisson_test_middle_l=12/plot_averaged_error_mpt2.dat" \
u 1:2 w l lt 2 lw 2 notitle, \
"../work_area_poisson_test_middle_l=12/plot_averaged_error_mpt3.dat" \
u 1:2 w l lt 2 lw 2 notitle, \
"../work_area_poisson_test_large_l=12/plot_averaged_error_mpt1.dat" \
u 1:2 w l lt 3 lw 2 notitle, \
"../work_area_poisson_test_large_l=12/plot_averaged_error_mpt2.dat" \
u 1:2 w l lt 3 lw 2 notitle, \
"../work_area_poisson_test_large_l=12/plot_averaged_error_mpt3.dat" \
u 1:2 w l lt 3 lw 2 notitle


set ylabel "{/Symbol=32 da}/{/Symbol=32 a}[%]"
#set term x11 2
set output 'plot_2pot_averaged_error_3mpt_alpha.eps'
plot \
"../work_area_poisson_test_small_l=12/plot_averaged_error_mpt1.dat" \
u 1:3 w l lt 1 lw 2 notitle, \
"../work_area_poisson_test_small_l=12/plot_averaged_error_mpt2.dat" \
u 1:3 w l lt 1 lw 2 notitle, \
"../work_area_poisson_test_small_l=12/plot_averaged_error_mpt3.dat" \
u 1:3 w l lt 1 lw 2 notitle, \
"../work_area_poisson_test_middle_l=12/plot_averaged_error_mpt1.dat" \
u 1:3 w l lt 2 lw 2 notitle, \
"../work_area_poisson_test_middle_l=12/plot_averaged_error_mpt2.dat" \
u 1:3 w l lt 2 lw 2 notitle, \
"../work_area_poisson_test_middle_l=12/plot_averaged_error_mpt3.dat" \
u 1:3 w l lt 2 lw 2 notitle, \
"../work_area_poisson_test_large_l=12/plot_averaged_error_mpt1.dat" \
u 1:3 w l lt 3 lw 2 notitle, \
"../work_area_poisson_test_large_l=12/plot_averaged_error_mpt2.dat" \
u 1:3 w l lt 3 lw 2 notitle, \
"../work_area_poisson_test_large_l=12/plot_averaged_error_mpt3.dat" \
u 1:3 w l lt 3 lw 2 notitle


pause -1