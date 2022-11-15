set terminal postscript enhanced eps color dashed "Helvetica" 24 \
fontfile "/usr/share/texmf/fonts/type1/bluesky/cm/cmsy10.pfb"
#set terminal postscript enhanced eps color solid "Helvetica" 16


#set key right top reverse Left
set key left top reverse Left
##set key left bottom reverse Left
##set key width -1
set key box lw 0.2
##set key title "{/Symbol=24 q} int. 4th"

set output 'fig_MvsR_EOS_2n0_30MeV.eps'
set xlabel "{/Helvetica=38 R [km]}"
set ylabel "{/Helvetica=38 M [M_{/CMSY10 \014}]}"

set yrange [0.5:2.7]
set xtics 1.0 ; set ytics 0.5
set mxtics 4 ; set mytics 5
set pointsize 1.6
set tics scale  2, 1

plot 'ovphy_plot_TOV_seq_EOS_00.dat' u 8:11 w l lw 2 title "{00}", \
     'ovphy_plot_TOV_seq_EOS_01.dat' u 8:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_02.dat' u 8:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_03.dat' u 8:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_04.dat' u 8:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_05.dat' u 8:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_06.dat' u 8:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_07.dat' u 8:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_08.dat' u 8:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_09.dat' u 8:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_10.dat' u 8:11 w l lw 2 title "{10}", \
     'ovphy_plot_TOV_seq_EOS_11.dat' u 8:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_12.dat' u 8:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_13.dat' u 8:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_14.dat' u 8:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_15.dat' u 8:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_16.dat' u 8:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_17.dat' u 8:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_18.dat' u 8:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_19.dat' u 8:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_20.dat' u 8:11 w l lw 2 title "{20}", \
     'ovphy_plot_TOV_seq_EOS_21.dat' u 8:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_22.dat' u 8:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_23.dat' u 8:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_24.dat' u 8:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_25.dat' u 8:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_26.dat' u 8:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_27.dat' u 8:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_28.dat' u 8:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_29.dat' u 8:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_30.dat' u 8:11 w l lw 2 title "{30}", \
     'ovphy_plot_TOV_seq_EOS_31.dat' u 8:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_32.dat' u 8:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_33.dat' u 8:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_34.dat' u 8:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_35.dat' u 8:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_36.dat' u 8:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_37.dat' u 8:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_38.dat' u 8:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_39.dat' u 8:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_40.dat' u 8:11 w l lw 2 title "{40}"

set output 'fig_rhocvsM_EOS_2n0_30MeV.eps'
set xlabel "{/Symbol=38 r}_{/Helvetica=32 c} {/Helvetica=32 [g/cm^3]}"
set ylabel "{/Helvetica=38 M} {/Helvetica=32 [M_{/CMSY10 \014}]}"

set xtics 10e+14
set ytics 0.5
set mxtics 4 ; set mytics 5
set pointsize 1.6
set tics scale  2, 1

plot 'ovphy_plot_TOV_seq_EOS_00.dat' u 4:11 w l lw 2 title "{00}", \
     'ovphy_plot_TOV_seq_EOS_01.dat' u 4:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_02.dat' u 4:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_03.dat' u 4:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_04.dat' u 4:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_05.dat' u 4:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_06.dat' u 4:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_07.dat' u 4:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_08.dat' u 4:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_09.dat' u 4:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_10.dat' u 4:11 w l lw 2 title "{10}", \
     'ovphy_plot_TOV_seq_EOS_11.dat' u 4:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_12.dat' u 4:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_13.dat' u 4:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_14.dat' u 4:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_15.dat' u 4:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_16.dat' u 4:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_17.dat' u 4:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_18.dat' u 4:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_19.dat' u 4:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_20.dat' u 4:11 w l lw 2 title "{20}", \
     'ovphy_plot_TOV_seq_EOS_21.dat' u 4:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_22.dat' u 4:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_23.dat' u 4:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_24.dat' u 4:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_25.dat' u 4:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_26.dat' u 4:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_27.dat' u 4:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_28.dat' u 4:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_29.dat' u 4:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_30.dat' u 4:11 w l lw 2 title "{30}", \
     'ovphy_plot_TOV_seq_EOS_31.dat' u 4:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_32.dat' u 4:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_33.dat' u 4:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_34.dat' u 4:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_35.dat' u 4:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_36.dat' u 4:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_37.dat' u 4:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_38.dat' u 4:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_39.dat' u 4:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_40.dat' u 4:11 w l lw 2 title "{40}"

set output 'fig_MovRvsM_EOS_2n0_30MeV.eps'
set xlabel "{/Helvetica=38 M/R}"
set ylabel "{/Helvetica=38 M} {/Helvetica=32 [M_{/CMSY10 \014}]}"

set xrange [0.1:0.35]
set xtics 0.05
set ytics 0.5
set mxtics 4 ; set mytics 5
set pointsize 1.6
set tics scale  2, 1

plot 'ovphy_plot_TOV_seq_EOS_00.dat' u 1:11 w l lw 2 title "{00}", \
     'ovphy_plot_TOV_seq_EOS_01.dat' u 1:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_02.dat' u 1:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_03.dat' u 1:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_04.dat' u 1:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_05.dat' u 1:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_06.dat' u 1:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_07.dat' u 1:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_08.dat' u 1:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_09.dat' u 1:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_10.dat' u 1:11 w l lw 2 title "{10}", \
     'ovphy_plot_TOV_seq_EOS_11.dat' u 1:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_12.dat' u 1:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_13.dat' u 1:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_14.dat' u 1:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_15.dat' u 1:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_16.dat' u 1:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_17.dat' u 1:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_18.dat' u 1:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_19.dat' u 1:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_20.dat' u 1:11 w l lw 2 title "{20}", \
     'ovphy_plot_TOV_seq_EOS_21.dat' u 1:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_22.dat' u 1:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_23.dat' u 1:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_24.dat' u 1:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_25.dat' u 1:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_26.dat' u 1:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_27.dat' u 1:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_28.dat' u 1:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_29.dat' u 1:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_30.dat' u 1:11 w l lw 2 title "{30}", \
     'ovphy_plot_TOV_seq_EOS_31.dat' u 1:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_32.dat' u 1:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_33.dat' u 1:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_34.dat' u 1:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_35.dat' u 1:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_36.dat' u 1:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_37.dat' u 1:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_38.dat' u 1:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_39.dat' u 1:11 w l lw 2 notitle , \
     'ovphy_plot_TOV_seq_EOS_40.dat' u 1:11 w l lw 2 title "{40}"
