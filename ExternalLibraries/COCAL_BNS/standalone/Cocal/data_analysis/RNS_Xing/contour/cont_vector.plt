set contour base
set nosurface
set xrange [-2:2]
set yrange [-2:2]
set view 0,0
set term table

set term x11 0
set size sq 1.0,1.0
set zero 1e-20
set key 3,5.3 title "Shift vector in xy-plane"
#set pointsize 0.6
#set tmargin 1
set xtics  1
set ytics  1
set xlabel "x/R"
set ylabel "y/R"
plot "rns_fig_sft.dat" notitle w vector lw 1.5, \
     "rns_fig_rseq.dat" using 1:2 notitle with lines lw 1.5


set xrange [-3:3]
set yrange [-3:3]
set view 0,0
set term table
set cntrparam levels auto 10

set size sq 1.0,1.0
set zero 1e-20
set pointsize 0.6
set xtics  1
set ytics  1
set xlabel "x/R"
set ylabel "z/R"
set key 2,3.2 title "Rest density and velocity field in xy-plane"

set term table
set output "table.dat"
set cntrparam levels auto 10
splot "gnb_fig_xy.dat" u 1:2:3 notitle w line
set output
set term x11 1
set xlabel "x/R"
set ylabel "y/R"
plot "table.dat" using 1:2 notitle with lines lw 1.5 , \
     "gnb_fig_rseq.dat" u 1:2 notitle with lines lw 1.5, \
     "gnb_fig_vel.dat" notitle w vector lw 1.5
     
pause -1
