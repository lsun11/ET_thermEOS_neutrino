amp = 10
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
set table 'table_Btor_xz.dat'
splot 'rns_contour_xz_EMF.dat' u 1:2:11
unset table
#--

set contour base
set view 0,0
set nosurface

#--
#set cntrparam levels incremental 0.0,0.02,1.0
set table
set output "table_xy.dat"
splot "rns_contour_xy_FLU.dat" u 1:2:3 notitle w line
unset table

set table
set output "table_xz.dat"
splot "rns_contour_xz_FLU.dat" u 1:2:3 notitle w line
unset table

set table
set parametric 
set output "table_circle.dat"
plot [0:2*pi] cos(t),sin(t)
unset parametric
unset table

#--
set term postscript enhanced eps color solid "Helvetica" 24
set output "fig_MRNS_Bfield_emd_xy-plane.eps"

set xlabel "{/Helvetica=40 x/R}_{/Helvetica=26 0}"
set ylabel "{/Helvetica=40 y/R}_{/Helvetica=26 0}"
set format x "%3.1f"
set format y "%3.1f"
set object 1 circle at 0,0 size 1 lw 2
plot "data_vector_plot/rns_contour_xy_EMF.dat" u 1:2:(amp*($10)):(amp*($11)) \
      notitle w vectors lw 1.5 lt 1, \
     "table_xy.dat" using 1:2 notitle w lines lw 2 lt 2, \
     "table_circle.dat" using 1:2 notitle w lines lw 2 lt 2
#     "rnsshape_seq_xy.dat" using 1:2 notitle w lines lw 2 lt 2, \
     
#--
set output "fig_MRNS_Bfield_emd_xz-plane.eps"

set xlabel "{/Helvetica=40 x/R}_{/Helvetica=26 0}"
set ylabel "{/Helvetica=40 z/R}_{/Helvetica=26 0}"
set format x "%3.1f"
set format y "%3.1f"

plot "table_Btor_xz.dat" with image, \
     "data_vector_plot/rns_contour_xz_EMF.dat" u 1:2:(amp*($10)):(amp*($12)) \
      notitle w vectors lw 1.5 lt 8, \
     "table_xz.dat" using 1:2 notitle w lines lw 1.5 lt -1, \
     "rnsshape_seq_xz.dat" using 1:2 notitle w lines lw 1.5 lt -1 \
