set term x11 1
#set terminal postscript eps color solid 22
#set output 'metric_flus.eps'
set logscale x
set xlabel "x/lambda"
set ylabel "metric potentials"
plot \
     'xgnu.output' u 1:2 t 'psi-1' w l, \
     'xgnu.output' u 1:3 t 'beta^y' w l, \
     'xgnu.output' u 1:4 t 'h_xx' w l, \
     'xgnu.output' u 1:7 t 'h_yy' w l, \
     'xgnu.output' u 1:9 t 'h_zz' w l, \
     'xgnu.output' u 1:10 t '(h_xx-h_yy)/2' w l
set nologscale x
pause -1
#     'xgnu.output' u 1:2 t '\psi-1' w l, \
