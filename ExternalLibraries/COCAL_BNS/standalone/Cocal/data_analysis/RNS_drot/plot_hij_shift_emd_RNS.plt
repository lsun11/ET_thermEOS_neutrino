#amp1 = 10
amp1 = 1
amp = 10000
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
set table 'table_By_xz.dat'
splot 'rns_contour_xz_CF.dat' u 1:2:6
unset table
#--

set contour base
set view 0,0
set nosurface

#-- For xy-plane

set cntrparam levels incremental 1.0,0.05,2.0
set table
set output "table_xy.dat"
splot "rns_contour_xy_CF.dat" u 1:2:3 notitle w line
unset table

set table

data=4
cnt_inc=0.005
cnt_max=0.05

set cntrparam levels incremental cnt_inc,cnt_inc,cnt_max
set output "table_xy_pl.dat"
splot "rns_contour_hij_xy.dat" u 1:2:data notitle w line

set cntrparam levels incremental -cnt_max,cnt_inc,-cnt_inc
set output "table_xy_mi.dat"
splot "rns_contour_hij_xy.dat" u 1:2:data notitle w line

unset table

set table

cnt_inc=0.02
cnt_max=2.0

set cntrparam levels incremental cnt_inc,cnt_inc,cnt_max
set output "table_xy_emd.dat"
splot "rns_contour_xy_FLU.dat" u 1:2:3 notitle w line

unset table

#-- For xz-plane

set cntrparam levels incremental 1.0,0.05,2.0
set table
set output "table_xz.dat"
splot "rns_contour_xz_CF.dat" u 1:2:3 notitle w line
unset table

set table

data=5
cnt_inc=0.005
cnt_max=0.05

set cntrparam levels incremental cnt_inc,cnt_inc,cnt_max
set output "table_xz_pl.dat"
splot "rns_contour_hij_xz.dat" u 1:2:data notitle w line

set cntrparam levels incremental -cnt_max,cnt_inc,-cnt_inc
set output "table_xz_mi.dat"
splot "rns_contour_hij_xz.dat" u 1:2:data notitle w line

#splot "rns_contour_hij_xz.dat" u 1:2:(($3)-($8)) notitle w line
unset table

set table

cnt_inc=0.02
cnt_max=2.0

set cntrparam levels incremental cnt_inc,cnt_inc,cnt_max
set output "table_xz_emd.dat"
splot "rns_contour_xz_FLU.dat" u 1:2:3 notitle w line

unset table

#--
set term postscript enhanced eps color solid "Helvetica" 24
set output "fig_RNS_shift_hxy_xy-plane.eps"

set xlabel "{/Helvetica=40 x/R}_{/Helvetica=26 0}"
set ylabel "{/Helvetica=40 y/R}_{/Helvetica=26 0}"
set format x "%3.1f"
set format y "%3.1f"

plot "data_vector_plot/rns_contour_xy_CF.dat" u 1:2:(amp1*($5)):(amp1*($6)) \
      notitle w vectors lw 1.5 lt 1, \
     "table_xy.dat" using 1:2 notitle w lines lw 1 lt 2, \
     "table_xy_pl.dat" using 1:2 notitle w lines lw 1 lt 1, \
     "table_xy_mi.dat" using 1:2 notitle w lines lw 1 lt 3, \
     "table_xy_emd.dat" using 1:2 notitle w lines lw 1.5 lt -1, \
     "rnsshape_seq_xy.dat" using 1:2 notitle w lines lw 1.5 lt -1
     
#--
set output "fig_RNS_shift_hxz_xz-plane.eps"

set xlabel "{/Helvetica=40 x/R}_{/Helvetica=26 0}"
set ylabel "{/Helvetica=40 z/R}_{/Helvetica=26 0}"
set format x "%3.1f"
set format y "%3.1f"

plot "table_By_xz.dat" with image, \
     "table_xz.dat" using 1:2 notitle w lines lw 1 lt 2, \
     "table_xz_pl.dat" using 1:2 notitle w lines lw 1 lt 1, \
     "table_xz_mi.dat" using 1:2 notitle w lines lw 1 lt 3, \
     "table_xz_emd.dat" using 1:2 notitle w lines lw 1.5 lt -1, \
     "rnsshape_seq_xz.dat" using 1:2 notitle w lines lw 1.5 lt -1 \

