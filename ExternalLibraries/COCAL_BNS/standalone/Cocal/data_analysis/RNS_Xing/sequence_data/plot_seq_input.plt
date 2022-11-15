#set terminal postscript enhanced eps color solid "Helvetica" 24
#set output 'plot_test1.eps'
set terminal x11 0
set xlabel "{/Symbol=32 W}{/Helvetica=32 M}"
set ylabel "{/Helvetica=32 J/M^2}"

plot \
     'rnsphyplot_all.dat' u 18:30 w lp, \
     'rnsphyplot_all_input.dat' u 18:30 w lp

#set output 'plot_test2.eps'
set terminal x11 1
set xlabel "{/Symbol=32 W}{/Helvetica=32 M}"
set ylabel "{/Helvetica=32 T/|W|}"


plot \
     'rnsphyplot_all.dat' u 18:34 w lp, \
     'rnsphyplot_all_input.dat' u 18:34 w lp

#set output 'plot_test3.eps'
set terminal x11 2
set xlabel "{/Symbol=32 W}{/Helvetica=32 M}"
set ylabel "{/Helvetica=32 M_{ADM}}"

plot \
     'rnsphyplot_all.dat' u 18:20 w lp, \
     'rnsphyplot_all_input.dat' u 18:20 w lp

pause -1
