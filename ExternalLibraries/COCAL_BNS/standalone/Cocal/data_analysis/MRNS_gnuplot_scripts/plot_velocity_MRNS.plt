set contour base
set nosurface
set xrange [-1.5:1.5]
set yrange [-1.5:1.5]
set view 0,0
amp = 100

set size sq 1.0,1.0
set zero 1e-20
#set key 3,5.3 title "Shift vector in xy-plane"

set xtics  1
set ytics  1

set output
set term postscript eps color enhanced solid "Helvetica" 24
set output "fig_MRNS_velocity_xz-plane.eps"
set xlabel "{/Helvetica=40 x}"
set ylabel "{/Helvetica=40 z}"
set format x "%3.1f"
set format y "%3.1f"

amp = 10000000

plot "rns_contour_xz_FLU.dat" u 1:2:(amp*($4)):(amp*($6)) notitle w vectors lw 1.5

set output "fig_MRNS_velocity_xy-plane.eps"
set xlabel "{/Helvetica=40 x}"
set ylabel "{/Helvetica=40 y}"
set format x "%3.1f"
set format y "%3.1f"

amp = 1

plot "rns_contour_xy_FLU.dat" u 1:2:(amp*($4)):(amp*($5)) notitle w vectors lw 1.5

