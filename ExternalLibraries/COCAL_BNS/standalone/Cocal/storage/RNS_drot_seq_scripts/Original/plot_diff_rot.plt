set terminal postscript enhanced eps color dashed "Helvetica" 24
set zero 1e-20
set pointsize 1.6
set tics scale  2, 1

#set key right top reverse Left
#set key right center reverse Left
#set key at 16,0.002 reverse Left
set key left bottom reverse Left
set key width -6
set key height 0.5
set key box lw 0.2
set key title "Rotation law   {/Symbol=24 W}_c=10" enhanced

set logscale x
set format x "10^{%L}"
set xtics 10 ; set mxtics 10
xmin = 0.001 
xmax = 1
set xrange [xmin:xmax]

set logscale y
set format y "10^{%L}"
set ytics 10 ; set mytics 10
ymin = 0.01 
ymax = 20
set yrange [ymin:ymax]

#set xlabel "{/Helvetica=40 x/}{/Helvetica=36 R}_{/Helvetica=28 0}"
#set xlabel "{/Helvetica=40 x}"
set xlabel "{/Symbol=38 \166}"
set ylabel "{/Symbol=38 W}"


A2=0.001
ome=10
AA2=1.0

#set terminal x11
set output 'fig_diff_rot.eps'

plot \
(AA2*ome)/(AA2 + x**2) \
 w l lt 7 lw 2 title "q=1     j-const  A=1", \
(sqrt(A2)*ome)/sqrt(A2 + x**2) \
w l lt 1 lw 2 title "q=2    v-const  A=10^{-3/2}", \
(A2**0.75*ome)/(A2**3 + 3*A2**2*x**2 + 3*A2*x**4 + x**6)**0.25 \
w l lt 2 lw 2 title "q=4/3 Kepler   A=10^{-3/2}", \
(A2*ome)/(A2 + x**2) \
w l lt 3 lw 2 title "q=1     j-const  A=10^{-3/2}"

#, \
# x**(-2), 0.1*x**(-1.5), x**(-1)

#(A2**0.125*ome)/(A2 + x**2)**0.125 \

set output 'fig_diff_rot_hyper.eps'
set key width -2
ymin = 0.1 
ymax = 20
set yrange [ymin:ymax]

plot \
(AA2*ome)/(AA2 + x**2) \
w l lt 7 lw 3 title "q=1    A=1", \
(A2**0.0625*ome)/(A2 + x**2)**0.0625 \
w l lt 1 lw 3 title "q=16  A=10^{-3/2}", \
(A2**0.125*ome)/(A2 + x**2)**0.125 \
w l lt 2 lw 3 title "q=8    A=10^{-3/2}", \
(A2**0.25*ome)/(A2 + x**2)**0.25 \
w l lt 3 lw 3 title "q=4    A=10^{-3/2}", \
(sqrt(A2)*ome)/sqrt(A2 + x**2) \
w l lt 4 lw 3 title "q=2    A=10^{-3/2}"
