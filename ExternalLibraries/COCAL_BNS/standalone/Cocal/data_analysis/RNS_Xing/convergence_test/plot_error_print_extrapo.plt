set terminal postscript enhanced eps color dashed "Helvetica" 24

set xlabel "{/Symbol=32 D}"
set ylabel "{/Helvetica=32 error [%]}"
set pointsize 1.5
set ticscale 2

set logscale x
set logscale y

#set format x "%3.1t{/Symbol \264}10^{%L}"
set format x "%2.1f"
set format y "10^{%L}"
set xrange [0.47:1.02]
set xtics (0.4,0.5,0.6,0.7,0.8,0.9,1.0)
set yrange [0.01:2]

set key bottom Left right reverse
set key width -10
set key spacing 1.2
set key box lw 0.2
set key title "M/R = 0.296\nR_z/R_x = 0.875"

set output 'plot_convtest.eps'
plot \
     'output.dat' u 1:3 w lp lw 4.0 lt 1 pt 5 title "{/Symbol=32 W}", \
     'output.dat' u 1:6 w lp lw 4.0 lt 2 pt 4 title "T/|W|", \
     'output.dat' u 1:2 w lp lw 4.0 lt 3 pt 1 title "e", \
      0.1*x**2          w l  lw 0.2 lt -1   notitle, \
          x**2          w l  lw 0.2 lt -1   notitle
#     'output.dat' u 1:4 w lp lw 4.0 lt 4 pt 2 title "M_{ADM}", \
#     'output.dat' u 1:7 w lp lw 4.0 lt 7 pt 7 title "{/Symbol=32 e}_c", \
#     'output.dat' u 1:5 w lp lw 4.0 lt 2 pt 4 title "J", \


set output 'plot_convtest_extlapo_2nd.eps'
plot \
     'output_2nd.dat' u 1:3 w lp lw 4.0 lt 1 pt 5 title "{/Symbol=32 W}", \
     'output_2nd.dat' u 1:7 w lp lw 4.0 lt 7 pt 7 title "{/Symbol=32 e}_c", \
     'output_2nd.dat' u 1:6 w lp lw 4.0 lt 2 pt 4 title "T/|W|", \
     'output_2nd.dat' u 1:4 w lp lw 4.0 lt 4 pt 2 title "M_{ADM}", \
     'output_2nd.dat' u 1:2 w lp lw 4.0 lt 3 pt 1 title "e", \
      0.1*x**2          w l  lw 0.2 lt -1   notitle, \
          x**2          w l  lw 0.2 lt -1   notitle
#     'output_2nd.dat' u 1:5 w lp lw 4.0 lt 2 pt 4 title "J", \

set output 'plot_convtest_extlapo_3rd.eps'
plot \
     'output_3rd.dat' u 1:3 w lp lw 4.0 lt 1 pt 5 title "{/Symbol=32 W}", \
     'output_3rd.dat' u 1:7 w lp lw 4.0 lt 7 pt 7 title "{/Symbol=32 e}_c", \
     'output_3rd.dat' u 1:6 w lp lw 4.0 lt 2 pt 4 title "T/|W|", \
     'output_3rd.dat' u 1:4 w lp lw 4.0 lt 4 pt 2 title "M_{ADM}", \
     'output_3rd.dat' u 1:2 w lp lw 4.0 lt 3 pt 1 title "e", \
      0.1*x**2          w l  lw 0.2 lt -1   notitle, \
          x**2          w l  lw 0.2 lt -1   notitle
#     'output_3rd.dat' u 1:5 w lp lw 4.0 lt 2 pt 4 title "J", \

set output 'plot_convtest_extlapo_4th.eps'
plot \
     'output_4th.dat' u 1:3 w lp lw 4.0 lt 1 pt 5 title "{/Symbol=32 W}", \
     'output_4th.dat' u 1:7 w lp lw 4.0 lt 7 pt 7 title "{/Symbol=32 e}_c", \
     'output_4th.dat' u 1:6 w lp lw 4.0 lt 2 pt 4 title "T/|W|", \
     'output_4th.dat' u 1:4 w lp lw 4.0 lt 4 pt 2 title "M_{ADM}", \
     'output_4th.dat' u 1:2 w lp lw 4.0 lt 3 pt 1 title "e", \
      0.1*x**2          w l  lw 0.2 lt -1   notitle, \
          x**2          w l  lw 0.2 lt -1   notitle
#     'output_4th.dat' u 1:5 w lp lw 4.0 lt 2 pt 4 title "J", \
