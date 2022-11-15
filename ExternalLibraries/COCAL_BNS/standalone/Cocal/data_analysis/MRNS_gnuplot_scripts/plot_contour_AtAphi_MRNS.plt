set contour base
set nosurface
xa = 1.5
set xrange [-xa:xa]
set yrange [-xa:xa]
set view 0,0

set table
set output "table_At.dat"
set cntrparam levels incremental -0.05,0.001,0.05
splot "rns_contour_xz_EMF.dat" u 1:2:13 notitle w line
#pause -1
unset table

set table
set output "table_Aphi.dat"
set cntrparam levels incremental -0.05,0.005,0.05
splot "rns_contour_xz_EMF.dat" u 1:2:14 notitle w line
#pause -1
unset table

set term postscript enhanced eps color solid "Helvetica" 24
set output "fig_MRNS_contour_AtAphi_xz-plane.eps"

set size sq 1.0,1.0
set zero 1e-20
set pointsize 1.6
set xtics  1
set ytics  1

set xlabel "{/Helvetica=40 x}"
set ylabel "{/Helvetica=40 z}"
set format x "%3.1f"
set format y "%3.1f"

plot "table_At.dat"   using 1:2 notitle with lines lt 1 lw 2, \
     "table_Aphi.dat" using 1:2 notitle with lines lt 3 lw 2, \
     "rnsshape_seq_xz.dat" using 1:2 notitle w lines lw 1.5 lt -1


set format x
set format y
