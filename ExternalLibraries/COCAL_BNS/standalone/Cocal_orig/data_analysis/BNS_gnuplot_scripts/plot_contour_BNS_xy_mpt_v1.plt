# Contour plot for conformal factor psi
reset
x1=-1.25;  x2=3.75;
y1=-2.5;  y2=2.5 ; xns1=-1.25  ;  xns2=1.25 ;
rs1=0.76;  rs2=0.76;  ds=2.5   ;
set grid ;
set size sq 1.0,1.0;
set xrange [x1:x2];  set yrange [y1:y2];
set xtics x1,1.0,x2 ;
set ytics y1,1.0,y2 ;
set xlabel "{/Helvetica=28 x}" ;
set ylabel "{/Helvetica=28 y}"  ;
set contour base;
unset surface;
unset key
set view map;
set cntrparam levels incremental  1.0, 0.01, 1.33
set table "ns1.dat"
splot "bns_contour_xy_mpt1.dat" u ($1):2:7 w lines
unset table
#
reset
set grid ;
set size sq 1.0,1.0;
set xrange [x1:x2];  set yrange [y1:y2];
set xtics x1+0.25,1.0,x2-0.25 ;
set ytics y1+0.5,1.0,y2-0.5 ;
set xlabel "{/Helvetica=28 x}" ;
set ylabel "{/Helvetica=28 y}"  ;
set pointsize 0.7 ;
set contour base;
unset surface;
unset key
set view map;
set cntrparam levels incremental  1.0, 0.01, 1.33
set terminal postscript enhanced eps solid color "Helvetica" 24
set output "bns_contour_xy_mpt1_psi.eps"
set object circle at 2.5,0 size 1.125 fs border lc rgbcolor "green"
plot "bnsshape_xy_mpt1.dat" u (rs1*($1)):(rs1*($2))  w filledcurve fs solid 0.1 lc rgb '#0000FF' notitle,\
     "bnsshape_xy_mpt2.dat" u (ds-rs2*($1)):(-rs2*($2))  w filledcurve fs solid 0.1 lc rgb '#0000FF' notitle,\
          "ns1.dat" w l lc rgb '#FF0000' notitle

#reset ;
#x1=-2;  x2=5;
#y1=-3.5;  y2=3.5 ; xns1=-1.25  ;  xns2=1.25 ;
#rs1=0.91;  rs2=0.91;  ds=2.5   ;
#set grid ;
#set size sq 1.0,1.0;
#set xtics x1,1.0,x2 ;
#set ytics y1,1.0,y2 ;
#set xrange [x1:x2];  
#set yrange [y1:y2];
#set xlabel "x"  font "Helvetica, 38"
#set ylabel "y" font "Helvetica, 38" ; 
#set pointsize 0.7 ;
#set contour base;
#unset surface;
#unset key
#set view map;
#set cntrparam levels incremental  1.0, 0.01, 1.16
#set terminal postscript enhanced eps solid color "Helvetica" 24
#set output "bns_contour_xy_mpt1_psi.eps"
##splot "bns_contour_xy_mpt1.dat" u ($1+xns1):2:7 w line palette 
#splot "bns_contour_xy_mpt1.dat" u ($1+xns1):2:7 w lines
#

# Contour plot for lapse alph
reset
set grid ;
set size sq 1.0,1.0;
set xrange [x1:x2];  set yrange [y1:y2];
set xtics x1+0.25,1.0,x2-0.25 ;
set ytics y1+0.5,1.0,y2-0.5 ;
set xlabel "{/Helvetica=28 x}" ;
set ylabel "{/Helvetica=28 y}"  ;
set contour base;
unset surface;
unset key
set view map;
set cntrparam levels incremental  0.51, 0.01, 1.0
set table "ns1.dat"
splot "bns_contour_xy_mpt1.dat" u ($1):2:8 w lines
unset table
#
reset
set grid ;
set size sq 1.0,1.0;
set xrange [x1:x2];  set yrange [y1:y2];
set xtics x1+0.25,1.0,x2-0.25 ;
set ytics y1+0.5,1.0,y2-0.5 ;
set xlabel "{/Helvetica=28 x}" ;
set ylabel "{/Helvetica=28 y}"  ;
set pointsize 0.7 ;
set contour base;
unset surface;
unset key
set view map;
set cntrparam levels incremental  0.51, 0.01, 1.0
set terminal postscript enhanced eps solid color "Helvetica" 24
set output "bns_contour_xy_mpt1_alph.eps"
set object circle at 2.5,0 size 1.125 fs border lc rgbcolor "green"
plot "bnsshape_xy_mpt1.dat" u (rs1*($1)):(rs1*($2))  w filledcurve fs solid 0.1 lc rgb '#0000FF' notitle,\
     "bnsshape_xy_mpt2.dat" u (ds-rs2*($1)):(-rs2*($2))  w filledcurve fs solid 0.1 lc rgb '#0000FF' notitle,\
          "ns1.dat" w l lc rgb '#FF0000' notitle

#
#reset
#x1=-4;  x2=4;
#y1=-4;  y2=4; xns1=-1.5  ;  xns2=1.5 ;
#re=1.125   ;
#set grid ;
#set size sq;
#set xtics x1,1.0,x2 ;
#set ytics y1,1.0,y2 ;
#set xrange [x1:x2];  set yrange [y1:y2];
#set xlabel "x"  font "Helvetica, 38" ;
#set ylabel "y" font "Helvetica, 38" ;
#set pointsize 0.7 ;
#set contour base;
#unset surface;
#unset key
#set view map;
#set cntrparam levels incremental  0.9995, 0.00003, 1.0
#set terminal postscript enhanced eps solid color "Helvetica" 24
#set output "bns_contour_xy_mpt1_alph.eps"
#splot "bns_contour_xy_mpt1.dat" u ($1+xns1):2:8 w lines

# Contour plot for emd
reset
set grid ;
set size sq 1.0,1.0;
set xrange [x1:x2];  set yrange [y1:y2];
set xtics x1+0.25,1.0,x2-0.25 ;
set ytics y1+0.5,1.0,y2-0.5 ;
set xlabel "{/Helvetica=28 x}" ;
set ylabel "{/Helvetica=28 y}"  ;
set pointsize 0.7 ;
set contour base;
unset surface;
unset key
set view map;
set cntrparam levels incremental 0.0, 0.01, 0.2
set table "ns1.dat"
splot "bns_contour_xy_mpt1.dat" u ($1):2:3
unset table
set table "ns2.dat"
splot "bns_contour_xy_mpt2.dat" u (ds-$1):2:3
unset table

reset
set grid ;
set size sq 1.0,1.0;
set xrange [x1:x2];  set yrange [y1:y2];
set xtics x1+0.25,1.0,x2-0.25 ;
set ytics y1+0.5,1.0,y2-0.5 ;
set xlabel "{/Helvetica=28 x}" ;
set ylabel "{/Helvetica=28 y}"  ;
set pointsize 0.7 ;
set contour base;
unset surface;
unset key
set view map;
set cntrparam levels incremental  0., 0.01, 0.2
set terminal postscript enhanced eps solid color "Helvetica" 24
set output "bns_contour_xy_mpt1_emd.eps"
plot "bnsshape_xy_mpt1.dat" u (rs1*($1)):(rs1*($2))  w filledcurve fs solid 0.1 lc rgb '#0000FF' notitle,\
     "bnsshape_xy_mpt2.dat" u (ds-rs2*($1)):(-rs2*($2))  w filledcurve fs solid 0.1 lc rgb '#0000FF' notitle,\
     "ns1.dat" w l lc rgb '#FF0000' notitle, "ns2.dat" w l lc rgb '#FF0000' notitle


# Contour plot for rest mass density
reset
set grid ;
set size sq 1.0,1.0;
set xrange [x1:x2];  set yrange [y1:y2];
set xtics x1+0.25,1.0,x2-0.25 ;
set ytics y1+0.5,1.0,y2-0.5 ;
set xlabel "{/Helvetica=28 x}" ;
set ylabel "{/Helvetica=28 y}"  ;
set pointsize 0.7 ;
set contour base;
unset surface;
unset key
set view map;
set cntrparam levels incremental 0.0, 0.01, 0.3
set table "ns1.dat"
splot "bns_contour_xy_mpt1.dat" u ($1):2:14
unset table
set table "ns2.dat"
splot "bns_contour_xy_mpt2.dat" u (ds-$1):2:14
unset table

reset
set grid ;
set size sq 1.0,1.0;
set xrange [x1:x2];  set yrange [y1:y2];
set xtics x1+0.25,1.0,x2-0.25 ;
set ytics y1+0.5,1.0,y2-0.5 ;
set xlabel "{/Helvetica=28 x}" ;
set ylabel "{/Helvetica=28 y}"  ;
set pointsize 0.7 ;
set contour base;
unset surface;
unset key
set view map;
set cntrparam levels incremental  0., 0.01, 0.3
set terminal postscript enhanced eps solid color "Helvetica" 24
set output "bns_contour_xy_mpt1_rho.eps"
plot "bnsshape_xy_mpt1.dat" u (rs1*($1)):(rs1*($2))  w filledcurve fs solid 0.1 lc rgb '#0000FF' notitle,\
     "bnsshape_xy_mpt2.dat" u (ds-rs2*($1)):(-rs2*($2))  w filledcurve fs solid 0.1 lc rgb '#0000FF' notitle,\
     "ns1.dat" w l lc rgb '#FF0000' notitle, "ns2.dat" w l lc rgb '#FF0000' notitle



# Contour plot for vep
 reset
 set grid ;
 set size sq 1.0,1.0;
set xtics x1+0.25,1.0,x2-0.25 ;
set ytics y1+0.5,1.0,y2-0.5 ;
 set xrange [x1:x2];  set yrange [y1:y2];
set xlabel "{/Helvetica=28 x}" ;
set ylabel "{/Helvetica=28 y}"  ;
 set pointsize 0.7 ;
 set contour base;
 unset surface;
 unset key
 set view map;
 set cntrparam levels incremental  -0.2, 0.01, 0.2
 set table "ns3.dat"
 splot "bns_contour_xy_mpt1.dat" u ($1):2:12
 unset table
 set table "ns4.dat"
 splot "bns_contour_xy_mpt2.dat" u (ds-$1):2:12
 unset table

reset
set grid ;
set size sq 1.0,1.0;
set xrange [x1:x2];  set yrange [y1:y2];
set xtics x1+0.25,1.0,x2-0.25 ;
set ytics y1+0.5,1.0,y2-0.5 ;
set xlabel "{/Helvetica=28 x}" ;
set ylabel "{/Helvetica=28 y}"  ;
set pointsize 0.7 ;
set contour base;
unset surface;
unset key
set view map;
set cntrparam levels incremental  -0.2, 0.01, 0.2
set terminal postscript enhanced eps solid color "Helvetica" 24
set output "bns_contour_xy_mpt1_vep.eps"
plot "bnsshape_xy_mpt1.dat" u (rs1*($1)):(rs1*($2))   w filledcurve fs solid 0.1 lc rgb '#0000FF' notitle,\
     "bnsshape_xy_mpt2.dat" u (ds-rs2*($1)):(-rs2*($2)) w filledcurve fs solid 0.1 lc rgb '#0000FF' notitle,\
          "ns3.dat" w l lc rgb '#FF0000' notitle, "ns4.dat" w l lc rgb '#FF0000' notitle



#set parametric
#plot "./BBH_contour_xy_new.dat" u 1:2 notitle w lines,  bhp2+re*cos(t),re*sin(t) notitle lt  2, \
#                                           ra1*cos(t),ra1*sin(t) notitle lt -1 lw 1.5, \
#                                           bhp2+ra2*cos(t),ra2*sin(t) notitle lt -1 lw 1.5
