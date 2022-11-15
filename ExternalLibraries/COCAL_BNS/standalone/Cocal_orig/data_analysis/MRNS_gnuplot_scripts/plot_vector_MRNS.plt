set contour base
set nosurface
set xrange [-4:4]
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
set output "fig_MRNS_vector_shift_xz-plane.eps"
set xlabel "{/Helvetica=40 x}"
set ylabel "{/Helvetica=40 z}"
set format x "%3.1f"
set format y "%3.1f"

plot "rns_contour_xz_EMF.dat" u 1:2:(amp*($10)):(amp*($12)) notitle w vectors lw 1.5

