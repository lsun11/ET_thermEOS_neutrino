set term table
set output "table.dat"
set cntrparam levels auto $2
splot "rns_contour_xy.dat" u 1:2:$0 notitle w line
set output
#set term x11 $1 
set term postscript enhanced eps color solid  "Helvetica" 24
set output "$3"
set xlabel "{/Helvetica=32 x/R_0}"
set ylabel "{/Helvetica=32 y/R_0}"
set format x "%3.1f"
set format y "%3.1f"
plot "table.dat" using 1:2 notitle with lines lt $4 lw $6 , \
     "rnsshape_seq_xy.dat" u 1:2 notitle with lines lt $5 lw $6
set format x
set format y
