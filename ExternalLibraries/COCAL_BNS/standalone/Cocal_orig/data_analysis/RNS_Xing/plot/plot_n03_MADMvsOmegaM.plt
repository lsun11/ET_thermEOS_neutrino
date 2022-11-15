#set terminal postscript enhanced eps color dashed "Helvetica" 24
#set output 'plot_test1.eps'
#set terminal x11 0
set xlabel "{/Symbol=32 W}{/Helvetica=32 M}"
set ylabel "{/Helvetica=32 M_{ADM}}"
#set ylabel "{/Helvetica=32 T/|W|}"
set pointsize 1.5
set tics scale 2

#set format x "%3.1t{/Symbol \264}10^{%L}"
#set format y "%4.2f"
#set format y "%3.2t{/Symbol \264}10^{%L}"

set origin 0.0, 0.0
set size   1.0, 1.0
#set xrange [0.015:0.06]
#set yrange [0.0:0.22]
#set xtics 0.01
#set ytics 0.05
#set mxtics 5
#set mytics 5

set key right bottom
set key box lw 0.2
set key spacing 1.3

plot \
'n03_C010/n03_ML_C010_nr64_rnsphyplot.dat' \
 u 18:20 w lp lw 2.0 lt  3 pt 1 title " n=0.3 ML " ,\
'n03_C010/n03_JB_C010_nr64_rnsphyplot_pickup.dat' \
 u 18:20 w lp lw 2.0 lt  1 pt 5 title " n=0.3 JB ", \
'n05_C010/n05_ML_C010_nr64_rnsphyplot.dat' \
 u 18:20 w lp lw 2.0 lt  3 pt 1 title " n=0.5 ML ", \
'n05_C010/n05_JB_C010_nr64_rnsphyplot_pickup.dat' \
 u 18:20 w lp lw 2.0 lt  1 pt 5 title " n=0.5 JB " \

pause -1
