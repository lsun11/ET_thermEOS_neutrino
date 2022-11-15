set terminal postscript enhanced eps color dashed "Helvetica" 24 fontfile '/usr/share/texmf/fonts/type1/bluesky/cm/cmsy10.pfb'
set output 'fig_CF_M0_of_rhoc_Gamma2_q01_A1_BSS.eps'
#set terminal x11 0
#set xlabel "{/Symbol=32 W}{/Helvetica=32 M}"
#set ylabel "{/Helvetica=32 M_{ADM}}"
set xlabel "{/Symbol=38 r}_{/Helvetica=28 c}  {/Helvetica=28 [g/cm^3]}" offset 0.0,0.0 #offset 0.0,1.0
set ylabel "{/Helvetica=40 M_{/Helvetica=28 0} [{/Helvetica=34 M}_{/CMSY10=28 \014}]}" offset 0.0,0.0 #offset 2.0,0.0
set pointsize 1.5
set tics scale 2

set format x "%3.1t{/Symbol \264}10^{%L}"
#set format x "%3.1t"
set format y "%3.1f"
#set format y "%3.2t{/Symbol \264}10^{%L}"

set origin 0.0, 0.0
#set size   1.0, 1.0
set xrange [1e14:3e15]
set yrange [0.0:3.5]
set xtics 1e15  offset 0.0,0.0
set ytics 1.0
set mxtics 5
set mytics 5

set key bottom right reverse Left at 2.9e15, 0.3
##set key width 0.1
set key box lw 0.5
set key title "{/Symbol G}=2,  q=1,  A^{}/R_0=1"
#set key font ",20"
set key spacing 1.2
#set logscale x

plot \
  'data_rhoc_M_data_Gamma2_q01_A1_BSS.dat' u 1:3 w l lt -1 lw 2 \
  title "R_z^{}/R_x = 0.125-0.875", \
  'data_rhoc_M_Gamma2_spherical.dat'       u 1:3 w l lt  2 lc 1 lw 2 \
  title "TOV solutions"
