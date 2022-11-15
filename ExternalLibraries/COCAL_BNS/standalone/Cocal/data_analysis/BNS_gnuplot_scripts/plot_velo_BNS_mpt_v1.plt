set terminal postscript enhanced eps color solid "Helvetica" 24
# Gnuplot script file for plotting fluid velocity in the XY plane
# For the NS shape plot in COCP2 (Xcm,Ycm)=(dis-x2, -y2)
# For the velocity inside COCP2 the vector direction is taken care inside code.
#
reset ;
x1=-1.25;  x2=3.75;
y1=-2.5;  y2=2.5 ; xns1=-1.25  ;  xns2=1.25 ;
rs1=0.76;  rs2=0.76;  ds=2.5   ;
rs1=0.76;  rs2=0.76;  ds=2.5;
xns1=-1.25  ;  xns2=1.25 ;
set size sq 1.0,1.0;
set grid;  set xrange [x1:x2];  set yrange [y1:y2];
set xtics x1+0.25,1.0,x2-0.25 ;
set ytics y1+0.5,1.0,y2-0.5 ;
set xlabel "{/Helvetica=28 x}" ;
set ylabel "{/Helvetica=28 y}" ;

set pointsize 0.7 ;
set parametric;
mf=2 ;
set output "bns_contour_xy_mpt1_vxy.eps"
#plot "./BBH_contour_xy.dat" u 1:2:(mf*($5)):(mf*($6)) w vec notitle lt 1 lw 2, bhp2+re*cos(t),re*sin(t) notitle lt  2, \
#                                                                          ra1*cos(t),ra1*sin(t) notitle lt -1 lw 1.5, \
#                                                                     bhp2+ra2*cos(t),ra2*sin(t) notitle lt -1 lw 1.5
plot "bnsshape_xy_mpt1.dat" u (rs1*($1)):(rs1*($2))  w filledcurve fs solid 0.1 lc rgb '#0000FF' notitle,\
     "bnsshape_xy_mpt2.dat" u (ds-rs2*($1)):(-rs2*($2))  w filledcurve fs solid 0.1 lc rgb '#0000FF' notitle,\
     "bns_contour_xy_mpt1.dat" u 1:2:(mf*($4)):(mf*($5)) every 4:4 w vec notitle lt 1 lw 2,\
     "bns_contour_xy_mpt2.dat" u (ds-($1)):2:(mf*($4)):(mf*($5)) every 4:4  w vec notitle lt 1 lw 2
