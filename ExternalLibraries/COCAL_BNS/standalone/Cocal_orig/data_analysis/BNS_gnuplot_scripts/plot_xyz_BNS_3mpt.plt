set terminal postscript enhanced eps color dashed "Helvetica" 24 \
fontfile "/usr/share/texmf/fonts/type1/bluesky/cm/cmsy10.pfb"

# set title "Plot of Potential" font "Times-Roman,40"
 xns1=-1.25
 xns2=+1.25
 rs1=0.76
 rs2=0.76

 set xlabel "{/Helvetica=38 x}"
 set ylabel "{/Symbol=32 y}"
 set format y "%.2f"
 set grid
 set mxtics 5
 set mytics 2
# set tics font 'Helvetica,22'
 #set yrange [-80:80]
 #set zrange [-0.0005:0.0005]
 #set view 30,80
 #set palette rgbformulae 23,28,3

 set xrange [-10:10]
 set yrange [1.0:1.40]
 set arrow from xns1+rs1, graph 0 to xns1+rs1, graph 1 nohead lt 2 lw 2 lc rgb "#000000"
 set arrow from xns1-rs1, graph 0 to xns1-rs1, graph 1 nohead lt 2 lw 2 lc rgb "#000000"
 set arrow from xns2+rs2, graph 0 to xns2+rs2, graph 1 nohead lt 2 lw 2 lc rgb "#000000"
 set arrow from xns2-rs2, graph 0 to xns2-rs2, graph 1 nohead lt 2 lw 2 lc rgb "#000000"
 set label 1 "star" at xns1-0.75,graph 0.1 rotate by 0
 set label 2 "star" at xns2-0.75,graph 0.1 rotate by 0
 set output 'psi_x_plot.eps'
 plot "plot_x_mpt1.dat" u 1:2 w l lw 2 notitle, \
      "plot_x_mpt2.dat" u 1:2 w l lw 2 notitle, \
      "plot_x_mpt3.dat" u 1:2 w l lw 2 notitle

 set yrange [0.4:1.0]
 set ylabel "{/Symbol=32 a}"
 set xlabel "{/Helvetica=38 x}"
 set format y "%.2f"
 set arrow from xns1+rs1, graph 0 to xns1+rs1, graph 1 nohead lt 2 lw 2 lc rgb "#000000"
 set arrow from xns1-rs1, graph 0 to xns1-rs1, graph 1 nohead lt 2 lw 2 lc rgb "#000000"
 set arrow from xns2+rs2, graph 0 to xns2+rs2, graph 1 nohead lt 2 lw 2 lc rgb "#000000"
 set arrow from xns2-rs2, graph 0 to xns2-rs2, graph 1 nohead lt 2 lw 2 lc rgb "#000000"
 set label 1 "star" at xns1-0.75,graph 0.9 rotate by 0 
 set label 2 "star" at xns2-0.75,graph 0.9 rotate by 0 
 set output 'alph_x_plot.eps'
 plot "plot_x_mpt1.dat" u 1:3 w l lw 2 notitle, \
      "plot_x_mpt2.dat" u 1:3 w l lw 2 notitle, \
      "plot_x_mpt3.dat" u 1:3 w l lw 2 notitle


# set xrange [-20:20]
# set yrange [0.8:2.2]
 set output 'bvxd_x_plot.eps'
 plot "plot_x_mpt1.dat" u 1:4 w l lw 2 notitle, \
      "plot_x_mpt2.dat" u 1:4 w l lw 2 notitle, \
      "plot_x_mpt3.dat" u 1:4 w l lw 2 notitle

 reset
 set grid
 set xrange [-10:10]
 set yrange [-0.15:0.15]
 set mxtics 5
 set mytics 2
 set ylabel "{/Symbol=32 b}_y"
  set xlabel "{/Helvetica=38 x}"
# set format y "%.1t*10^{%L}"
 set format y "%.2f"
 set arrow from xns1+rs1, graph 0 to xns1+rs1, graph 1 nohead lt 2 lw 2 lc rgb "#000000"
 set arrow from xns1-rs1, graph 0 to xns1-rs1, graph 1 nohead lt 2 lw 2 lc rgb "#000000"
 set arrow from xns2+rs2, graph 0 to xns2+rs2, graph 1 nohead lt 2 lw 2 lc rgb "#000000"
 set arrow from xns2-rs2, graph 0 to xns2-rs2, graph 1 nohead lt 2 lw 2 lc rgb "#000000"
 set label 1 "star" at xns1-0.75,graph 0.1 rotate by 0
 set label 2 "star" at xns2-0.75,graph 0.9 rotate by 0
 set output 'bvyd_x_plot.eps'
 plot "plot_x_mpt1.dat" u 1:(1*($5)) w l lw 2 notitle, \
      "plot_x_mpt2.dat" u 1:(1*($5)) w l lw 2 notitle, \
      "plot_x_mpt3.dat" u 1:(1*($5)) w l lw 2 notitle

 set output 'bvzd_x_plot.eps'
 plot "plot_x_mpt1.dat" u 1:6 w l lw 2 notitle, \
      "plot_x_mpt2.dat" u 1:6 w l lw 2 notitle, \
      "plot_x_mpt3.dat" u 1:6 w l lw 2 notitle

 reset
 set grid
 set xrange [-4:4]
 set yrange [0:0.2]
 set mxtics 5
 set mytics 2
 set ylabel "P/{/Symbol=32 r}"
 set xlabel "{/Helvetica=38 x}"
 set format y "%.2f"
 set arrow from xns1+rs1, graph 0 to xns1+rs1, graph 1 nohead lt 2 lw 2 lc rgb "#000000"
 set arrow from xns1-rs1, graph 0 to xns1-rs1, graph 1 nohead lt 2 lw 2 lc rgb "#000000"
 set arrow from xns2+rs2, graph 0 to xns2+rs2, graph 1 nohead lt 2 lw 2 lc rgb "#000000"
 set arrow from xns2-rs2, graph 0 to xns2-rs2, graph 1 nohead lt 2 lw 2 lc rgb "#000000"
 set label 1 "star" at xns1-0.75,graph 0.1 rotate by 0
 set label 2 "star" at xns2-0.75,graph 0.1 rotate by 0
 set output 'emd_x_plot.eps'
 plot "plot_x_mpt1.dat" u 1:((abs($1-xns1)<=rs1)?(1*($7)):0/0) w l lw 2 notitle, \
      "plot_x_mpt2.dat" u 1:((abs($1-xns2)<=rs2)?(1*($7)):0/0) w l lw 2 notitle
