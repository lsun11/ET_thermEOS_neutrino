set terminal postscript enhanced eps color dashed "Helvetica" 24
set output 'plot_n05_OmegaMvsEccentricity.eps'
#set terminal x11 0
set xlabel "{/Helvetica=32 e}"
set ylabel "{/Symbol=32 W}{/Helvetica=32 M}"
set pointsize 1.5
set ticscale 2

#set format x "%3.1t{/Symbol \264}10^{%L}"
set format x "%3.1f"
set format y "%4.3f"
#set format y "%3.2t{/Symbol \264}10^{%L}"

set origin 0.0, 0.0
set size   1.0, 1.2
set xrange [0.5:0.9]
set yrange [0.01:0.032]
set xtics 0.1
set ytics 0.005
set mxtics 4
set mytics 5

#set key left top
set key below reverse Left
set key width -4
set key box lw 0.2
#set key spacing 1.3
set key title "n=0.5"

plot \
'n05_C014/n05_ML_C014_nr64_rnsphyplot.dat' \
 u 17:18 w lp lw 2.0 lt  3 pt 2 title "{M/R=0.14 ML}", \
'n05_C012/n05_ML_C012_nr64_rnsphyplot.dat' \
 u 17:18 w lp lw 2.0 lt  3 pt 1 title "{M/R=0.12 ML}" ,\
'n05_C010/n05_ML_C010_nr64_rnsphyplot.dat' \
 u 17:18 w lp lw 2.0 lt  3 pt 3 title "{M/R=0.1   ML}", \
'n05_C014/n05_JB_C014_nr64_rnsphyplot_pickup.dat' \
 u 17:18 w lp lw 2.0 lt  1 pt 4 title "{M/R=0.14 JB }", \
'n05_C012/n05_JB_C012_nr64_rnsphyplot_pickup.dat' \
 u 17:18 w lp lw 2.0 lt  1 pt 5 title "{M/R=0.12 JB }", \
'n05_C010/n05_JB_C010_nr64_rnsphyplot_pickup.dat' \
 u 17:18 w lp lw 2.0 lt  1 pt 6 title "{M/R=0.1   JB }", \
'n05_C014/n05_EXT_C014_nr64_rnsphyplot.dat' \
 u 17:18 w l  lw 0.2 lt -1    notitle, \
'n05_C012/n05_EXT_C012_nr64_rnsphyplot.dat' \
 u 17:18 w l  lw 0.2 lt -1    notitle, \
'n05_C010/n05_EXT_C010_nr64_rnsphyplot.dat' \
 u 17:18 w l  lw 0.2 lt -1    notitle

