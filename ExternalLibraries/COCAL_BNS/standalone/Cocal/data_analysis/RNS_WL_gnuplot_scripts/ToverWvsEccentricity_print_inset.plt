set terminal postscript enhanced eps color dashed "Helvetica" 24
set output 'fig_ToverWvsEccentricity_inset.eps'
#set terminal x11 0
#set xlabel "{/Symbol=32 W}{/Helvetica=32 M}"
#set ylabel "{/Helvetica=32 M_{ADM}}"
set xlabel "{/Helvetica=32 e}"     offset 0.0,0.5 #offset 0.0,1.0
set ylabel "{/Helvetica=32 T/|W|}" offset 1.0,0.0 #offset 2.0,0.0
set pointsize 2.0
set tics scale 2
#set tics font ",15"

set format x "%3.2f"
set format y "%4.2f"

set origin 0.0, 0.0
#set size   1.2, 1.4
set size   1.0, 1.3
set xrange [0.8:0.90]
set yrange [0.15:0.19]
set xtics 0.05  offset 0.0,0.4
set ytics 0.01
set mxtics 5
set mytics 5

set key below reverse Left
set key width 0.1
set key box lw 0.5
set key title "{/Symbol G}=4.0"
#set key font ",15"
set key spacing 1.1
#set logscale x

plot \
'data_seq/WL_ML_C030.dat' \
 u 14:(0.5*($7)*($11)/abs(($9)+0.5*($7)*($11)-($8))) w lp lw 3.0 lt 1 lc rgb "red" pt 1 title "{M/R=0.3  WL ML}" ,\
'data_seq/WL_ML_C020.dat' \
 u 14:(0.5*($7)*($11)/abs(($9)+0.5*($7)*($11)-($8))) w lp lw 3.0 lt 1 lc rgb "red" pt 2 title "{M/R=0.2  WL ML}", \
'data_seq/WL_ML_C010.dat' \
 u 14:(0.5*($7)*($11)/abs(($9)+0.5*($7)*($11)-($8))) w lp lw 3.0 lt 1 lc rgb "red" pt 3 title "{M/R=0.1  WL ML}", \
'data_seq/WL_JB_C030.dat' \
 u 14:(0.5*($7)*($11)/abs(($9)+0.5*($7)*($11)-($8))) w lp lw 3.0 lt 5 lc rgb "red" pt 12 title "{M/R=0.3  WL JB }" ,\
'data_seq/WL_JB_C020.dat' \
 u 14:(0.5*($7)*($11)/abs(($9)+0.5*($7)*($11)-($8))) w lp lw 3.0 lt 5 lc rgb "red" pt 10 title "{M/R=0.2  WL JB }", \
'data_seq/WL_JB_C010.dat' \
 u 14:(0.5*($7)*($11)/abs(($9)+0.5*($7)*($11)-($8))) w lp lw 3.0 lt 5 lc rgb "red" pt 14 title "{M/R=0.1  WL JB }", \
'data_seq/WL_EXT_C030.dat' \
 u 1:2 w l lw 3.0 lt 5 lc rgb "red" notitle, \
'data_seq/WL_EXT_C020.dat' \
 u 1:2 w l lw 3.0 lt 5 lc rgb "red" notitle, \
'data_seq/WL_EXT_C010.dat' \
 u 1:2 w l lw 3.0 lt 5 lc rgb "red" notitle, \
'data_seq/CF_ML_C030.dat' \
 u 14:(0.5*($7)*($11)/abs(($9)+0.5*($7)*($11)-($8))) w lp lw 3.0 lt 1 lc rgb "blue" pt 1 title "{M/R=0.3  CF ML}" ,\
'data_seq/CF_ML_C020.dat' \
 u 14:(0.5*($7)*($11)/abs(($9)+0.5*($7)*($11)-($8))) w lp lw 3.0 lt 1 lc rgb "blue" pt 2 title "{M/R=0.2  CF ML}", \
'data_seq/CF_ML_C010.dat' \
 u 14:(0.5*($7)*($11)/abs(($9)+0.5*($7)*($11)-($8))) w lp lw 3.0 lt 1 lc rgb "blue" pt 3 title "{M/R=0.1  CF ML}", \
'data_seq/CF_JB_C030.dat' \
 u 14:(0.5*($7)*($11)/abs(($9)+0.5*($7)*($11)-($8))) w lp lw 3.0 lt 5 lc rgb "blue" pt 12 title "{M/R=0.3  CF JB}" ,\
'data_seq/CF_JB_C020.dat' \
 u 14:(0.5*($7)*($11)/abs(($9)+0.5*($7)*($11)-($8))) w lp lw 3.0 lt 5 lc rgb "blue" pt 10 title "{M/R=0.2  CF JB}", \
'data_seq/CF_JB_C010.dat' \
 u 14:(0.5*($7)*($11)/abs(($9)+0.5*($7)*($11)-($8))) w lp lw 3.0 lt 5 lc rgb "blue" pt 14 title "{M/R=0.1  CF JB}" ,\
'data_seq/CF_EXT_C010.dat' \
 u 1:2 w l lw 3.0 lt 5 lc rgb "blue" notitle, \
'data_seq/CF_EXT_C020.dat' \
 u 1:2 w l lw 3.0 lt 5 lc rgb "blue" notitle, \
'data_seq/CF_EXT_C030.dat' \
 u 1:2 w l lw 3.0 lt 5 lc rgb "blue" notitle
