set term x11 1
reset
set border
set grid
set xrange [-1.0:3.7];  set yrange [-2:2]; set zrange [-0.1:1];
set xlabel "X"
set ylabel "Y"
set zlabel "Z"
set dummy u,v
#set angles degrees
set parametric
set view 65,25, 1.0, 1.0
set samples 64,64
set isosamples 28, 28
#set mapping spherical
#set noxtics
#set noytics
#set noztics
set title "Shift at the z=0.1 plane"
#set urange [ -90.0000 : 90.0000 ] noreverse nowriteback
#set vrange [ 0.00000 : 360.000 ] noreverse nowriteback
set hidden nooffset
ra=0.2
rb=0.2
mf=7 ;

set size 0.9,0.5 ;
set term postscript portrait enhanced color solid
set output "bvxy3d_zc.ps"

splot ra*cos(u)*cos(v),ra*cos(u)*sin(v),ra*sin(u) notitle with lines lt 2,\
      2.5+rb*cos(u)*cos(v),rb*cos(u)*sin(v),rb*sin(u) notitle with lines lt 3,\
      u,v,0.1 with lines lt rgb "gray50" notitle,\
      "./sol_D12/work_area_BBH_D2/BBH_z1_vf.dat" u 1:2:3:(mf*$4):(mf*$5):(mf*$6) with vectors nohidden3d lt 1 notitle

# lt rgb "gray50"
