set logscale x
set logscale y
set xrange [0.3:1]

plot 'output.dat' u 1:2 w lp, \
     'output.dat' u 1:3 w lp, \
     'output.dat' u 1:4 w lp, \
     'output.dat' u 1:5 w lp, \
     'output.dat' u 1:6 w lp, \
      0.1*x**2, x**2, 0.1*x**1, 0.1*x**1.5
pause -1
plot 'output_2nd.dat' u 1:2 w lp, \
     'output_2nd.dat' u 1:3 w lp, \
     'output_2nd.dat' u 1:4 w lp, \
     'output_2nd.dat' u 1:5 w lp, \
     'output_2nd.dat' u 1:6 w lp, \
      0.1*x**2, x**2
pause -1
plot 'output_3rd.dat' u 1:2 w lp, \
     'output_3rd.dat' u 1:3 w lp, \
     'output_3rd.dat' u 1:4 w lp, \
     'output_3rd.dat' u 1:5 w lp, \
     'output_3rd.dat' u 1:6 w lp, \
      0.1*x**2, x**2
pause -1
plot 'output_4th.dat' u 1:2 w lp, \
     'output_4th.dat' u 1:3 w lp, \
     'output_4th.dat' u 1:4 w lp, \
     'output_4th.dat' u 1:5 w lp, \
     'output_4th.dat' u 1:6 w lp, \
      0.1*x**2, x**2
pause -1
