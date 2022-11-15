set term table
set output "table.dat"
set cntrparam levels auto $2
splot "rns_contour_$5.dat" u 1:2:$0 notitle w line
set output
#set term x11 $1 
set term postscript eps color solid 22
set output "$3"
set xlabel "x/R_0"
set ylabel "y/R_0"
plot "table.dat" using 1:2 notitle with lines lt $4 lw $6 , \
     "rnsshape_seq_xy.dat" u 1:2 notitle with lines lt $5 lw $6
