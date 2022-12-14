set terminal postscript enhanced eps color dashed "Helvetica" 24
#set terminal postscript enhanced eps color solid "Helvetica" 16

set xlabel "{/Helvetica=38 x}"
set grid
set origin 0.0, 0.0
set size   1.0, 1.0

set logscale x
set logscale y
set format x "10^{%L}"
set format y "10^{%L}"
set zero 1e-20
set mxtics 10 ; set mytics 10
set pointsize 1.6
set tics scale  2, 1

set key right top reverse Left
#set key width -1
set key box lw 0.2
set key title "df/dr 3rd"

set xrange [0.1:10000]
set yrange [0.00001:0.1]

set ylabel "{/Helvetica=32 |}\
{/Symbol=32 dy}{/Helvetica=32 /}{/Symbol=32 y}\
{/Helvetica=32 |}{/Helvetica=32 [%]}"
set output 'plot_2pot_error_psi_logr.eps'
plot \
"../work_area_poisson_test_D1/plot_x.dat" \
u 1:(100.0*abs(($2-$3)/$3)) w l lt 1 lw 2 notitle, \
"../work_area_poisson_test_D2/plot_x.dat" \
u 1:(100.0*abs(($2-$3)/$3)) w l lt 2 lw 2 notitle, \
"../work_area_poisson_test_D3/plot_x.dat" \
u 1:(100.0*abs(($2-$3)/$3)) w l lt 3 lw 2 notitle, \
"../work_area_poisson_test_D4/plot_x.dat" \
u 1:(100.0*abs(($2-$3)/$3)) w l lt 4 lw 2 notitle


set xrange [0.1:10000]
set yrange [0.00001:10]

set ylabel "{/Helvetica=32 |}\
{/Symbol=32 da}{/Helvetica=32 /}{/Symbol=32 a}\
{/Helvetica=32 |}{/Helvetica=32 [%]}"
set output 'plot_2pot_error_alpha_logr.eps'
plot \
"../work_area_poisson_test_D1/plot_x.dat" \
u 1:(100.0*abs(($4-$5)/$5)) w l lt 1 lw 2 title "{D1}", \
"../work_area_poisson_test_D2/plot_x.dat" \
u 1:(100.0*abs(($4-$5)/$5)) w l lt 2 lw 2 title "{D2}", \
"../work_area_poisson_test_D3/plot_x.dat" \
u 1:(100.0*abs(($4-$5)/$5)) w l lt 3 lw 2 title "{D3}", \
"../work_area_poisson_test_D4/plot_x.dat" \
u 1:(100.0*abs(($4-$5)/$5)) w l lt 4 lw 2 title "{D4}"

#pause -1
