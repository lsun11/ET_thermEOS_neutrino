# Gnuplot script file for plotting contours of Pse and LPse in the XY plane

reset ;   
x1=-3.0;  x2=5.0; 
y1=-4.0;  y2=4.0 ; 

bhp1=0.0  ;  bhp2=2.5 ;
re=1.125   ;  
ra1=0.2   ;  ra2=0.2   ;

set xtics x1,1.0,x2 ;
set ytics y1,1.0,y2 ; 
set grid;  set xrange [x1:x2];  set yrange [y1:y2];
set size 0.9,0.5 ;

set xlabel "x" font "Helvetica, 18" ;
set ylabel "y" font "Helvetica, 18" ; 

set pointsize 0.7 ;

set contour base;
unset surface;
set view 0,0;

#Data for the alph contours
#set cntrparam levels discrete 0.15,0.2,0.3,0.4,0.45,0.5,0.6,0.62,0.65,0.7,0.8,0.9  ;
set cntrparam level incremental 0.2, 0.04, 1.6
   
#Data for the Pse contours
#set cntrparam levels discrete 1.1,1.2,1.3,1.4,1.5,1.6,1.8,2.0,2.2,2.4,2.6,2.7  ;
#set cntrparam level incremental  1.0,0.04, 1.98

set table  "contour.dat" ;
#For plotting Pse we need 1:2:3 and for LPse 1:2:4 
splot "./Cocal_debug/work_area_BBH_D3/BBH_contour_xy_v1.dat" u 1:2:4 w lines
unset table
   
#set term x11
set term postscript portrait enhanced color solid "Helvetica, 10"
#set output "psi_contour.ps"
set output "alph_contour.ps"

set parametric
#set title "Conformal factor at the z=0 plane"
set title "Lapse function at the z=0 plane"
##set palette rgbformulae 33,13,10
#l '<./cont.sh contour.dat 0 30 0'
#p '<./cont.sh contour.dat 1 30 0' w l lt 1 
plot "contour.dat" u 1:2 notitle w l, bhp2+re*cos(t),re*sin(t) notitle lt  2, \
                                      ra1*cos(t),ra1*sin(t) notitle lt -1 lw 1.5, \
                                      bhp2+ra2*cos(t),ra2*sin(t) notitle lt -1 lw 1.5
