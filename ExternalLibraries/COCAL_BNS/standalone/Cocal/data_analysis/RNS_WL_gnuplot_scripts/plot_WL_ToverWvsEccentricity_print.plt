set terminal postscript enhanced eps color dashed "Helvetica" 24
set output 'fig_WL_ToverWvsEccentricity.eps'
#set terminal x11 0
#set xlabel "{/Symbol=32 W}{/Helvetica=32 M}"
#set ylabel "{/Helvetica=32 M_{ADM}}"
set xlabel "{/Helvetica=32 e}"     offset 0.0,0.5 #offset 0.0,1.0
set ylabel "{/Helvetica=32 T/|W|}" offset 1.0,0.0 #offset 2.0,0.0
set pointsize 1.5
set tics scale 2
#set tics font ",15"

set multiplot

#set format x "%3.1t{/Symbol \264}10^{%L}"
set format x "%3.1f"
set format y "%4.2f"
#set format y "%3.2t{/Symbol \264}10^{%L}"

set origin 0.0, 0.0
#set size   1.0, 1.0
set xrange [0.2:1.0]
set yrange [0.0:0.22]
set xtics 0.1  offset 0.0,0.0
set ytics 0.05
set mxtics 5
set mytics 5

set key below reverse Left
set key width 0.1
set key box lw 0.5
set key title "{/Symbol G}=4.0"
#set key font ",20"
set key spacing 1.0
#set logscale x

plot \
'data_seq/WL_ML_C030.dat' \
 u 14:(0.5*($7)*($11)/abs(($9)+0.5*($7)*($11)-($8))) w lp lw 3.0 lt 1 pt 1 ps 1.5 lc rgb "blue" title "{M/R=0.3  WL ML}" ,\
'data_seq/WL_ML_C020.dat' \
 u 14:(0.5*($7)*($11)/abs(($9)+0.5*($7)*($11)-($8))) w lp lw 3.0 lt 1 pt 2 ps 1.5 lc rgb "blue" title "{M/R=0.2  WL ML}", \
'data_seq/WL_ML_C010.dat' \
 u 14:(0.5*($7)*($11)/abs(($9)+0.5*($7)*($11)-($8))) w lp lw 3.0 lt 1 pt 3 ps 1.5 lc rgb "blue" title "{M/R=0.1  WL ML}", \
'data_seq/WL_JB_C030.dat' \
 u 14:(0.5*($7)*($11)/abs(($9)+0.5*($7)*($11)-($8))) w lp lw 3.0 lt 5 pt 4 ps 1.2 lc rgb "red" title "{M/R=0.3  WL JB}" ,\
'data_seq/WL_JB_C020.dat' \
 u 14:(0.5*($7)*($11)/abs(($9)+0.5*($7)*($11)-($8))) w lp lw 3.0 lt 5 pt 12 ps 1.2 lc rgb "red" title "{M/R=0.2  WL JB}", \
'data_seq/WL_JB_C010.dat' \
 u 14:(0.5*($7)*($11)/abs(($9)+0.5*($7)*($11)-($8))) w lp lw 3.0 lt 5 pt 6 ps 1.2 lc rgb "red" title "{M/R=0.1  WL JB}", \
'data_seq/WL_EXT_C030.dat' \
 u 1:2 w l lw 3.0 lt 5 lc rgb "red" notitle, \
'data_seq/WL_EXT_C020.dat' \
 u 1:2 w l lw 3.0 lt 5 lc rgb "red" notitle, \
'data_seq/WL_EXT_C010.dat' \
 u 1:2 w l lw 3.0 lt 5 lc rgb "red" notitle


set origin 0.08, 0.515
set size   0.47, 0.47
set xrange [0.8:0.90]
set yrange [0.15:0.185]
set xtics  0.05 offset 0.0,0.5
set ytics  0.01 offset 0.5,0.0
set mxtics 5
set mytics 5
set format x "%3.2f"
set format y "%4.2f"
unset xlabel
unset ylabel

set nokey
set tics scale 1
set tics font ",15"

replot

set nomultiplot
