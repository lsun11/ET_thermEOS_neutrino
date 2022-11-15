set contour base
set nosurface
set xrange [-3:5]
set yrange [-4:4]
set view 0,0
amp = 10

set size sq 1.0,1.0
set zero 1e-20
#set key 3,5.3 title "Shift vector in xy-plane"

set xtics  1
set ytics  1

set output
set term postscript eps color enhanced solid "Helvetica" 24
set output "fig_bbh_vector_shift_xy-plane.eps"
set xlabel "{/Helvetica=40 x}"
set ylabel "{/Helvetica=40 y}"
set format x "%3.1f"
set format y "%3.1f"

set object circle at   0,0 size 0.2 front fc rgbcolor "white" \
                          fs solid border lc rgbcolor "black"
set object circle at 2.5,0 size 0.2 front fc rgbcolor "white" \
                          fs solid border lc rgbcolor "black"
set object circle at 2.5,0 size 1.125 fs border lc rgbcolor "green"

plot "BBH_contour_xy.dat" u 1:2:(amp*($5)):(amp*($6)) notitle w vectors lw 1.5

