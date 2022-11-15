set terminal postscript enhanced eps color dashed "Helvetica" 24 \
fontfile "/usr/share/texmf/fonts/type1/bluesky/cm/cmsy10.pfb"
#set terminal postscript enhanced eps color solid "Helvetica" 16

#set xrange [0.1:1000000]
#set yrange [0.1:1000000]

#set key right top reverse Left
##set key left bottom reverse Left
##set key width -1
#set key box lw 0.2
##set key title "{/Symbol=24 q} int. 4th"

set output 'fig_zvsrhoc_EOS_2n0_30MeV.eps'
set xlabel "{/Helvetica=38 z/x }"
set ylabel "{/Symbol=38 r}_{/Helvetica=32 c} {/Helvetica=32 [g/cm^3]}"

set xtics 0.1
set ytics 1e+14
set mxtics 4 ; set mytics 4
set pointsize 1.6
set tics scale  2, 1

plot 'rnsphyseq_extracted_06.dat' u 9:4 w l lw 2 title "{06}", \
     'rnsphyseq_extracted_07.dat' u 9:4 w l lw 2 notitle , \
     'rnsphyseq_extracted_08.dat' u 9:4 w l lw 2 notitle , \
     'rnsphyseq_extracted_09.dat' u 9:4 w l lw 2 notitle , \
     'rnsphyseq_extracted_10.dat' u 9:4 w l lw 2 title "{10}", \
     'rnsphyseq_extracted_11.dat' u 9:4 w l lw 2 notitle , \
     'rnsphyseq_extracted_12.dat' u 9:4 w l lw 2 notitle , \
     'rnsphyseq_extracted_13.dat' u 9:4 w l lw 2 notitle , \
     'rnsphyseq_extracted_14.dat' u 9:4 w l lw 2 notitle , \
     'rnsphyseq_extracted_15.dat' u 9:4 w l lw 2 notitle , \
     'rnsphyseq_extracted_16.dat' u 9:4 w l lw 2 notitle , \
     'rnsphyseq_extracted_17.dat' u 9:4 w l lw 2 notitle , \
     'rnsphyseq_extracted_18.dat' u 9:4 w l lw 2 notitle , \
     'rnsphyseq_extracted_19.dat' u 9:4 w l lw 2 notitle , \
     'rnsphyseq_extracted_20.dat' u 9:4 w l lw 2 title "{20}"

#plot 'rnsphyseq_extracted_00.dat' u 9:4 w l lw 2 title "{00}", \
#     'rnsphyseq_extracted_01.dat' u 9:4 w l lw 2 notitle , \
#     'rnsphyseq_extracted_02.dat' u 9:4 w l lw 2 notitle , \
#     'rnsphyseq_extracted_03.dat' u 9:4 w l lw 2 notitle , \
#     'rnsphyseq_extracted_04.dat' u 9:4 w l lw 2 notitle , \
#     'rnsphyseq_extracted_05.dat' u 9:4 w l lw 2 notitle , \
#     'rnsphyseq_extracted_06.dat' u 9:4 w l lw 2 notitle , \
