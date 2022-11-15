set terminal postscript enhanced eps color dashed "Helvetica" 24
set output 'plot_n03_ToverWvsEccentricity.eps'
#set terminal x11 0
#set xlabel "{/Symbol=32 W}{/Helvetica=32 M}"
#set ylabel "{/Helvetica=32 M_{ADM}}"
set xlabel "{/Helvetica=32 e}"
set ylabel "{/Helvetica=32 T/|W|}"
set pointsize 1.5
set ticscale 2

set multiplot

#set format x "%3.1t{/Symbol \264}10^{%L}"
set format x "%3.1f"
set format y "%4.2f"
#set format y "%3.2t{/Symbol \264}10^{%L}"

set origin 0.0, 0.0
set size   1.0, 1.2
set xrange [0.2:1.0]
set yrange [0.0:0.25]
set xtics 0.1
set ytics 0.05
set mxtics 4
set mytics 4

set key below reverse Left
set key width -4
set key box lw 0.2
set key title "n=0.3"
#set key spacing 1.3
#set logscale x

plot \
'n03_C020/n03_ML_C020_nr64_rnsphyplot.dat' \
 u 17:34 w lp lw 2.0 lt  3 pt 1 title "{M/R=0.2   ML}" ,\
'n03_C014/n03_ML_C014_nr64_rnsphyplot.dat' \
 u 17:34 w lp lw 2.0 lt  3 pt 2 title "{M/R=0.14 ML}", \
'n03_C010/n03_ML_C010_nr64_rnsphyplot.dat' \
 u 17:34 w lp lw 2.0 lt  3 pt 3 title "{M/R=0.1   ML}", \
'n03_C020/n03_JB_C020_nr64_rnsphyplot_pickup.dat' \
 u 17:34 w lp lw 2.0 lt  1 pt 5 title "{M/R=0.2   JB }", \
'n03_C014/n03_JB_C014_nr64_rnsphyplot_pickup.dat' \
 u 17:34 w lp lw 2.0 lt  1 pt 4 title "{M/R=0.14 JB }", \
'n03_C010/n03_JB_C010_nr64_rnsphyplot_pickup.dat' \
 u 17:34 w lp lw 2.0 lt  1 pt 6 title "{M/R=0.1   JB }", \
'n03_C020/n03_EXT_C020_nr64_rnsphyplot.dat' \
 u 17:34 w l  lw 0.2 lt -1    notitle, \
'n03_C014/n03_EXT_C014_nr64_rnsphyplot.dat' \
 u 17:34 w l  lw 0.2 lt -1    notitle, \
'n03_C010/n03_EXT_C010_nr64_rnsphyplot.dat' \
 u 17:34 w l  lw 0.2 lt -1    notitle  \

set origin 0.15, 0.62
set size   0.52, 0.52
set xrange [0.8:0.92]
set yrange [0.14:0.18]
set xtics  0.05
set ytics  0.01
set mxtics 5
set mytics 4
set format x "%3.2f"
set format y "%4.2f"
unset xlabel
unset ylabel

set nokey

replot

set nomultiplot
