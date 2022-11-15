set contour base
set nosurface
set xrange [-3:5]
set yrange [-4:4]
set view 0,0

set cntrparam levels incremental 0.0,0.05,1.0
set table
set output "table.dat"
splot "BBH_contour_xy.dat" u 1:2:4 notitle w line
#pause -1
unset table

set term postscript enhanced eps color solid "Helvetica" 24
set output "fig_bbh_contour_alpha_xy-plane.eps"

set size sq 1.0,1.0
set zero 1e-20
set pointsize 1.6
set xtics  1
set ytics  1

set xlabel "{/Helvetica=40 x}"
set ylabel "{/Helvetica=40 y}"
set format x "%3.1f"
set format y "%3.1f"

set object circle at   0,0 size 0.2 front fc rgbcolor "white" \
                          fs solid border lc rgbcolor "black" 
set object circle at 2.5,0 size 0.2 front fc rgbcolor "white" \
                          fs solid border lc rgbcolor "black" 
set object circle at 2.5,0 size 1.125 fs border lc rgbcolor "green" 

plot "table.dat" using 1:2 notitle with lines lt 1 lw 2 

set format x
set format y
