set terminal postscript enhanced eps color dashed "Helvetica" 24
##set terminal postscript enhanced eps color solid "Helvetica" 16

set xlabel "{/Helvetica=38 x}"
set grid

#set format x "%4.1f"
#set format y "%4.1f"
set zero 1e-20
set mxtics 5 ; set mytics 5
set pointsize 1.6
set tics scale  2, 1

#set key right top reverse Left
##set key width -1
#set key box lw 0.2
##set key title "df/dr 3rd"

set xrange [-15:15]
set yrange [-0.03:0.03]

#set label "{/Symbol=32 y}" at 5, 1.2
#set label "{/Symbol=32 a}" at 5, 0.75

set ylabel "{/Symbol=32 b}_x"
set output 'plot_bvxd.eps'
plot "./Cocal_debug/work_area_BBH_D3/plot_x.dat" u 1:4 w l lw 2 lt 1 notitle


#pause -1
