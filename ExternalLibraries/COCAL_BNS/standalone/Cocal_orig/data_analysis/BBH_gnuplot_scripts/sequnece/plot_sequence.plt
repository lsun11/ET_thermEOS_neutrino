set terminal postscript enhanced eps color dashed "Helvetica" 24
#set terminal postscript enhanced eps color solid "Helvetica" 16

#set xrange [0.1:1000000]
#set yrange [0.1:1000000]

set key right top reverse Left
#set key left bottom reverse Left
#set key width -1
set key box lw 0.2
#set key title "{/Symbol=24 q} int. 4th"

set output 'plot_seq_Omega_Madm.eps'
set xlabel "{/Symbol=38 W}{/Helvetica=38 M_{/Helvetica=28 irr}}"
set ylabel "{/Helvetica=38 M_{{/Helvetica=28 ADM}}/M_{{/Helvetica=28 irr}}"

set xtics 0.02 ; set ytics 0.002
set mxtics 4 ; set mytics 4
set pointsize 1.6
set tics scale  2, 1

plot 'bbhphyseq_extracted_H2.dat' u (($1)*2.*($4)):(($2)/(2.*($4))) \
      w lp lw 2 title "{H2 }"


set output 'plot_seq_Omega_J.eps'
set xlabel "{/Symbol=38 W}{/Helvetica=38 M_{/Helvetica=28 irr}}"
set ylabel "{/Helvetica=38 J/M_{/Helvetica=28 irr}}^{{/Helvetica=24 2}}"

set xtics 0.02 ; set ytics 0.02
set mxtics 4 ; set mytics 4
set pointsize 1.6
set tics scale  2, 1

plot 'bbhphyseq_extracted_H2.dat' u (($1)*2.*($4)):(($3)/(2.*($4))**2) \
      w lp lw 2 title "{H2 }"
