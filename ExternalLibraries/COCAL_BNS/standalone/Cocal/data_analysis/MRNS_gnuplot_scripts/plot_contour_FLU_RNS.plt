xy_range=1.5
set xrange [-xy_range:xy_range]
set yrange [-xy_range:xy_range]

set size sq 1.0,1.0
set zero 1e-20
set pointsize 1.6
set tics front
set xtics  1
set ytics  1
set mxtics 4
set mytics 4

#--
#set palette model XYZ functions gray**0.35, gray**0.5, gray**0.8
set palette defined (-1 "blue", 0 "white", 1 "red")
set view map
set table 'table_shift_y.dat'
splot 'rns_contour_xz.dat' u 1:2:(-$10)
unset table
#

set contour base
set view 0,0
set nosurface

#set cntrparam levels incremental 0.0,0.02,1.0
set cntrparam levels incremental 0.0,0.01,0.1
set table
set output "table.dat"
splot "rns_contour_xz.dat" u 1:2:3 notitle w line
#pause -1
unset table

set term postscript enhanced eps color solid "Helvetica" 24
set output "fig_RNS_contour_emd_xz-plane.eps"

set xlabel "{/Helvetica=40 x}"
set ylabel "{/Helvetica=40 y}"
set format x "%3.1f"
set format y "%3.1f"

plot "table_shift_y.dat" notitle with image, \
     "table.dat" using 1:2 notitle with lines lt -1 lw 1.5, \
     "rnsshape_seq_xz.dat" using 1:2 notitle w lines lw 1.5 lt -1 

set format x
set format y
