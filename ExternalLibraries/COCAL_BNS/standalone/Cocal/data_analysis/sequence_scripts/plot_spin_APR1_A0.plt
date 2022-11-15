set terminal postscript enhanced eps color solid "Helvetica" 24 \
fontfile "/usr/share/texmf/fonts/type1/bluesky/cm/cmsy10.pfb"

#set size sq 1.0,1.0
#set title "{/Helvetica=38 C=0.18}"
#set ylabel "{/Helvetica=38 (M-M_{/Symbol \245})/M_0}"
set ylabel "{/Helvetica=28 (J_{sp}-J_{ir})/J_{ir} }"
set xlabel "{/Helvetica=28 {/Symbol=28 W} M_{/Symbol \245} }"
set grid
set key width +1 height +1 spacing 1.3 left top
set key box
set xrange [0.01:0.06]
set xtics 0.01, 0.01,0.06
set format x "%.2f"
set mxtics 4
#set yrange [-0.016:-0.004]
#set ytics -0.016, 0.002, -0.004
set format y "%.3f"
#set mytics 4
set grid

set output 'spHs2.5d_APR1_A0.eps'
# Run read_BNS_seq.f90 as 
# ./a.out Hs2.5d_APR1 spHs2.5d_APR1_w0.01_A0.txt spHs2.5d_APR1_w0.05_A0.txt > spirHs2.5d_APR1_A0.txt
plot \
'spirHs2.5d_APR1_A0.txt' u (2*($5)*($1)):((($11)-($10))/($10)) w l lt 2 lw 1 lc rgb "#FF0000" title "{~S{.6\\176}}_0=0.01",\
'spirHs2.5d_APR1_A0.txt' u (2*($5)*($1)):((($12)-($10))/($10)) w l lt 2 lw 1 lc rgb "#0000FF" title "{~S{.6\\176}}_0=0.05"

#title "{@^{\\176}S}_0=0.01"

reset
set ylabel "{/Helvetica=28 (J_{sp}-J_{ir})/2 }"
set xlabel "{/Helvetica=28 {/Symbol=28 W} M_{/Symbol \245} }"
set grid
set key width +1 height +1 spacing 1.3 left top
set key box
set xrange [0.01:0.06]
set xtics 0.01, 0.01,0.06
set format x "%.2f"
set mxtics 4
#set yrange [-0.016:-0.004]
#set ytics -0.016, 0.002, -0.004
set format y "%.3f"
#set mytics 4
set grid

set output 'spHs2.5d_APR1_A0_S.eps'
# Run read_BNS_seq.f90 as 
# ./a.out Hs2.5d_APR1 spHs2.5d_APR1_w0.01_A0.txt spHs2.5d_APR1_w0.05_A0.txt > spirHs2.5d_APR1_A0.txt
plot \
'spirHs2.5d_APR1_A0.txt' u (2*($5)*($1)):((($11)-($10))/2) w l lt 2 lw 1 lc rgb "#FF0000" title "{~S{.6\\176}}_0=0.01",\
'spirHs2.5d_APR1_A0.txt' u (2*($5)*($1)):((($12)-($10))/2) w l lt 2 lw 1 lc rgb "#0000FF" title "{~S{.6\\176}}_0=0.05"


reset
set ylabel "{/Helvetica=28 (J_{sp}-J_{ir})/(2M^2_{ir ADM}) }"
set xlabel "{/Helvetica=28 {/Symbol=28 W} M_{/Symbol \245} }"
set grid
set key width +1 height +1 spacing 1.3 left top
set key box
set xrange [0.01:0.06]
set xtics 0.01, 0.01,0.06
set format x "%.2f"
set mxtics 4
#set yrange [-0.016:-0.004]
#set ytics -0.016, 0.002, -0.004
set format y "%.3f"
#set mytics 4
set grid

set output 'spHs2.5d_APR1_A0_chi.eps'
# Run read_BNS_seq.f90 as
# ./a.out Hs2.5d_APR1 spHs2.5d_APR1_w0.01_A0.txt spHs2.5d_APR1_w0.05_A0.txt > spirHs2.5d_APR1_A0.txt
plot \
'spirHs2.5d_APR1_A0.txt' u (2*($5)*($1)):(2*(($11)-($10))/(($7)*($7))) w l lt 2 lw 1 lc rgb "#FF0000" \
title "{~S{.6\\176}}_0=0.01",\
'spirHs2.5d_APR1_A0.txt' u (2*($5)*($1)):(2*(($12)-($10))/(($7)*($7))) w l lt 2 lw 1 lc rgb "#0000FF" \
title "{~S{.6\\176}}_0=0.05"


