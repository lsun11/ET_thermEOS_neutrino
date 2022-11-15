reset
#set terminal postscript enhanced eps color dashed "Helvetica" 24
set terminal postscript enhanced eps color solid "Helvetica" 16
set output 'plot_NS_surface.eps'

set xlabel "{/Helvetica=38 x}"
set ylabel "{/Helvetica=38 y}"
set zlabel "{/Helvetica=38 z}"

set mapping spherical
set hidden3d
set xrange [-1.1:1.1]
set yrange [-1.1:1.1]
set zrange [-1.1:1.1]
set size square
set view equal
set view 60,30,1,1.5
set pm3d depthorder
splot 'rnsshape_NS_gnuplot.dat' u 1:2:3:3 w pm3d  notitle
