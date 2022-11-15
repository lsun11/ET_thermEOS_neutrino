# Gnuplot script file for plotting result data 

set term x11 0
reset ;
x1=-7 ; x2=7.0 ; 
set grid ; set xrange [x1:x2] ; 
set xlabel "x"  font "Helvetica, 18" ;
set ylabel "{/Symbol a}"  font "Helvetica, 18" ;
set size 0.9,0.5 ;
set terminal postscript portrait enhanced color "Helvetica" 14 ;
set output "alph_x.ps" ;
plot "./Cocal_debug/work_area_BBH_D3/plot_x.dat"  u 1:3 w l lw 2 lt 1 notitle
#plot "./Cocal_debug/work_area_BBH_D2/line_it24_ip0.txt"    u     1:3 w l lw 2 lt 1 notitle,\
#     "./Cocal_debug/work_area_BBH_D2/line_it24_ip24.txt"   u (-$1):3 w l lw 2 lt 1 notitle

set term x11 1
reset ;
y1=-7 ; y2=7.0 ; 
set grid ; set xrange [y1:y2] ; 
set xlabel "y"  font "Helvetica, 18" ;
set ylabel "{/Symbol a}"  font "Helvetica, 18" ;
set size 0.9,0.5 ;
set terminal postscript portrait enhanced color "Helvetica" 14 ;
set output "alph_y.ps" ;
plot "./Cocal_debug/work_area_BBH_D3/plot_y.dat"   u 1:3 w l lw 2 lt 1 notitle
#plot "./Cocal_debug/work_area_BBH_D2/plot_x.dat"  u 1:3 w l lw 2 lt 1 notitle
#     "./Cocal_debug/work_area_BBH_D2/line_it24_ip36.txt"   u (-$1):3 w l lw 2 lt 1 notitle


set term x11 2
reset ;
z1=-7 ; z2=7.0 ; 
set grid ; set xrange [z1:z2] ; 
set xlabel "z"  font "Helvetica, 18" ;
set ylabel "{/Symbol a}"  font "Helvetica, 18" ;
set size 0.9,0.5 ;
set terminal postscript portrait enhanced color "Helvetica" 14 ;
set output "alph_z.ps" ;
plot "./Cocal_debug/work_area_BBH_D3/plot_z.dat"  u 1:3 w l lw 2 lt 1 notitle
#plot "./Cocal_debug/work_area_BBH_D2/line_it0_ip0.txt"   u     1:3 w l lw 2 lt 1 notitle,\
#     "./Cocal_debug/work_area_BBH_D2/line_it48_ip0.txt"  u (-$1):3 w l lw 2 lt 1 notitle


# LINE COLORS, STYLES 
# Differs from x11 to postscript
# lt chooses a particular line type: -1=black 1=red 2=grn 3=blue 4=purple 5=aqua 6=brn 7=orange 8=light-brn
# lt must be specified before pt for colored points
# for postscipt -1=normal, 1=grey, 2=dashed, 3=hashed, 4=dot, 5=dot-dash
# lw chooses a line width 1=normal, can use 0.8, 0.3, 1.5, 3, etc.
# ls chooses a line style