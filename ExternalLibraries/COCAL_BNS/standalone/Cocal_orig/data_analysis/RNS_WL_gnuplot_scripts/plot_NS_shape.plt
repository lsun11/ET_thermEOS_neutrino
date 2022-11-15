reset
#set terminal postscript enhanced eps color dashed "Helvetica" 24
#set terminal postscript enhanced eps color solid "Helvetica" 16
set terminal postscript enhanced eps color solid "Helvetica" 20
set output 'fig_NS_surface.eps'

set mapping spherical
#set hidden3d
set size square
#set view equal
set view equal xyz
set view 60,30,1,1.5
#set pm3d depthorder
set pm3d depthorder # interpolate 2,2
set colorbox user origin 0.7,0.38 size  0.02,0.3

#set xlabel "{/Helvetica=38 x/R}"
#set ylabel "{/Helvetica=38 y}"
#set zlabel "{/Helvetica=38 z}"
set xlabel "{/Helvetica=32 x/R}_{/Helvetica=20 0}" offset 0.0,-0.2,0.0
set ylabel "{/Helvetica=32 y/R}_{/Helvetica=20 0}" offset 0.2,0.0,0.0
set zlabel "{/Helvetica=32 z/R}_{/Helvetica=20 0}" offset -0.2,0.0,0.0

set xrange [-1.1:1.1]
set yrange [-1.1:1.1]
set zrange [-1.1:1.1]
set xtics 0.5 offset 0.0,-0.2,0.0
set ytics 0.5 offset 0.2,0.0,0.0
set ztics 0.5 offset 0.5,0.0,0.0
#set mxtics 2
#set mytics 2
#set mztics 2

set cbrange [0:1]
set format cb "%.1f"
set cbtics 0.2
set mcbtics 2
#set palette defined ( 0 "blue", 1 "red", 2 "orange" )
#set palette defined ( 0 "black", 1 "red", 2 "orange" )
set palette defined ( 0 "black", 1 "dark-red", 2 "red", 3 "orange" )

set ticslevel 0

splot 'rnsshape_NS_gnuplot.dat' u 1:2:3:3 w pm3d  notitle



