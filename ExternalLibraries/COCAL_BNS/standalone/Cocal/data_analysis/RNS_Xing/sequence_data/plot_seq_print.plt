#set terminal postscript enhanced eps color solid "Helvetica" 24

#set output 'plot_J_of_Omega.eps'
set terminal x11 0
set xlabel "{/Symbol=32 W}{/Helvetica=32 M}"
set ylabel "{/Helvetica=32 J/M^2}"
set xtics 0.0002; set mxtics 0.0001
set ytics 0.01
plot \
     'rnsphyplot_all.dat' u 18:30 w lp notitle lw 1.5 lt -1

#set output 'plot_ToverW_of_Omega.eps'
set terminal x11 1
set xlabel "{/Symbol=32 W}{/Helvetica=32 M}"
set ylabel "{/Helvetica=32 T/|W|}"
set xtics 0.0002; set mxtics 0.0001
set ytics 0.001
plot \
     'rnsphyplot_all.dat' u 18:34 w lp notitle lw 1.5 lt -1

#set output 'plot_MADM_of_Omega.eps'
set terminal x11 2
set xlabel "{/Symbol=32 W}{/Helvetica=32 M}"
set ylabel "{/Helvetica=32 M_{ADM}}"
set xtics 0.0002; set mxtics 0.0001
set ytics 0.00001
plot \
     'rnsphyplot_all.dat' u 18:20 w lp notitle lw 1.5 lt -1

#pause -1
