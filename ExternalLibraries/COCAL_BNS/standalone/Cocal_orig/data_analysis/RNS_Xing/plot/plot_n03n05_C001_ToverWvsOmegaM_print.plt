set terminal postscript enhanced eps color dashed "Helvetica" 24
set output 'plot_n03n05_C0001_ToverWvsOmegaM.eps'
#set terminal x11 0
set xlabel "{/Symbol=32 W}{/Helvetica=32 M}"
set ylabel "{/Helvetica=32 T/|W|}"
set pointsize 1.5
set ticscale 2

set multiplot

set format x "%3.1t{/Symbol \264}10^{%L}"
set format y "%4.2f"

set origin 0.0, 0.0
set size   1.0, 1.2
set xrange [4.0e-6:2.0e-5]
set yrange [0.0:0.25]
set xtics 5.0e-6
set ytics 0.05
set mxtics 5
set mytics 5

#set key center bottom outside
set key below reverse Left
set key width -1
#set key at graph 1.15,0.32 
set key box lw 0.2
#set key spacing 1.2
set key title "M/R=0.001"

plot \
'n03n05_C0001/n03_ML_C0001_nr64_rnsphyplot_all.dat' \
 u 18:34 w lp lw 4.0 lt  3 pt 1 title "n=0.3 ML",\
'n03n05_C0001/n03_JB_C0001_nr64_rnsphyplot_all.dat' \
 u 18:34 w lp lw 4.0 lt  1 pt 5 title "n=0.3 JB ",\
'n03n05_C0001/n03_EXT_C0001_nr64_rnsphyplot_all.dat' \
 u 18:34 w l lw 0.2 lt -1       notitle,\
'n03n05_C0001/n05_ML_C0001_nr64_rnsphyplot_all.dat' \
 u 18:34 w lp lw 4.0 lt  4 pt 2 title "n=0.5 ML",\
'n03n05_C0001/n05_JB_C0001_nr64_rnsphyplot_all.dat' \
 u 18:34 w lp lw 4.0 lt  2 pt 4 title "n=0.5 JB ",\
'n03n05_C0001/n05_EXT_C0001_nr64_rnsphyplot_all.dat' \
 u 18:34 w l lw 0.2 lt -1       notitle \


set format x "%3.1t{/Symbol \264}10^{%L}"
set format y "%5.3f"

set origin 0.15, 0.6
set size   0.55, 0.55
set xrange [1.5e-5:1.8e-5]
set yrange [0.13:0.15]
set xtics  2.0e-6
set ytics  0.005
set mxtics 10
set mytics 5
unset xlabel
unset ylabel

set nokey

replot

set nomultiplot

