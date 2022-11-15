set terminal postscript enhanced eps color solid "Helvetica" 24 
# Gnuplot script file for plotting shift in the XY plane wrt the Central CS (ARCP)
# For the NS shape plot in COCP2 (Xcm,Ycm)=(dis-x2, -y2)
# For the shift inside COCP2 the vector direction is taken care inside code.

x1=-2;   x2=5.0; 
y1=-3.5;   y2=3.5 ; 
ds=3.0;
xns1=-1.5  ;  xns2=1.5 ;
re=1.125 ;  
set size sq 1.0,1.0;
set xtics x1,1.0,x2 ;
set ytics y1+0.5,1.0,y2-0.5 ;
set grid;  set xrange [x1:x2];  set yrange [y1:y2];
set xlabel "{/Helvetica=28 x}" ;
set ylabel "{/Helvetica=28 y}" ; 
set pointsize 0.7 ;
set parametric;
mf=1.2*10**5 ;
set style arrow 1 head filled size screen 0.01,15,30 lt 1 lw 2

set output "bns_contour_xy_mpt1_bvxy.eps"
#plot "./BBH_contour_xy.dat" u 1:2:(mf*($5)):(mf*($6)) w vec notitle lt 1 lw 2, bhp2+re*cos(t),re*sin(t) notitle lt  2, \
#                                                                          ra1*cos(t),ra1*sin(t) notitle lt -1 lw 1.5, \
#                                                                     bhp2+ra2*cos(t),ra2*sin(t) notitle lt -1 lw 1.5
set object circle at 3,0 size 1.25 fs border lc rgbcolor "green"
plot "bnsshape_xy_mpt1.dat" u ($1):2  w filledcurve fs solid 0.1 lc rgb '#0000FF' notitle,\
     "bnsshape_xy_mpt2.dat" u (ds-$1):(-($2))  w filledcurve fs solid 0.1 lc rgb '#0000FF' notitle,\
     "bns_contour_xy_mpt1.dat" u ($1):2:(mf*($9)):(mf*($10))  w vec lw 1.5 lc rgb '#FF0000' notitle

#     "bnsshape_xy_mpt2.dat" u (3-$1):(-($2))  w filledcurve fs solid 0.1 lc rgb '#0000FF' notitle,\
#     "bns_contour_xy_mpt1.dat" u ($1+xns1):2:(mf*($9)):(mf*($10)) every 6:6 w vec notitle arrowstyle 1
