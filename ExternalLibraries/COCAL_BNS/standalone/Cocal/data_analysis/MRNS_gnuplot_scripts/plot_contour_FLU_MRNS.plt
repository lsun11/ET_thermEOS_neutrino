set contour base
set nosurface
xy_range=1.5
set xrange [-xy_range:xy_range]
set yrange [-xy_range:xy_range]
set view 0,0

#set cntrparam levels incremental 0.0,0.02,1.0
set table
set output "table.dat"
splot "rns_contour_xy_FLU.dat" u 1:2:3 notitle w line
#pause -1
unset table

set term postscript enhanced eps color solid "Helvetica" 24
set output "fig_MRNS_contour_emd_xy-plane.eps"

set size sq 1.0,1.0
set zero 1e-20
set pointsize 1.6
set xtics  1
set ytics  1

set xlabel "{/Helvetica=40 x}"
set ylabel "{/Helvetica=40 y}"
set format x "%3.1f"
set format y "%3.1f"

plot "table.dat" using 1:2 notitle with lines lt 1 lw 2 

set format x
set format y

set table
set output "table.dat"
splot "rns_contour_xz_FLU.dat" u 1:2:3 notitle w line
#pause -1
unset table

set output "fig_MRNS_contour_emd_xz-plane.eps"

set size sq 1.0,1.0
set zero 1e-20
set pointsize 1.6
set xtics  1
set ytics  1

set xlabel "{/Helvetica=40 x}"
set ylabel "{/Helvetica=40 y}"
set format x "%3.1f"
set format y "%3.1f"

plot "table.dat" using 1:2 notitle with lines lt 1 lw 2 

set format x
set format y
