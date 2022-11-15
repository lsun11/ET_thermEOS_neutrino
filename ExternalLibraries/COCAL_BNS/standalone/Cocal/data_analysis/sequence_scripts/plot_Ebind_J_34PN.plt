set terminal postscript enhanced eps color dashed "Helvetica" 24 \
fontfile "/usr/share/texmf/fonts/type1/bluesky/cm/cmsy10.pfb"
#set terminal postscript enhanced eps color solid "Helvetica" 16

set output 'Ebind_ome_34PN.eps'
set xlabel "{/Helvetica=28 {/Symbol=28 W} M }"
set ylabel "{/Helvetica=28 E_b/M}"
#set ylabel "{/Helvetica=24 M [M_{/CMSY10 \014}]}"
set title "{/Helvetica=28 S_1=S_2=(0,0,0.3)}"

set grid
#set arrow from x1, graph 0 to x1,f1 nohead lt 2 lw 2 lc rgb "#000000" 
set xrange [0.01:0.07]
#set yrange [-0.015:0.015]
#set mxtics 4 
#set mytics 5
set pointsize 1.6
set tics scale  2, 1
#set title sprintf("{/Helvetica=24 R=%1.3f     M_{max adm}=%1.3f}", x1,f1)
set label 1 "{/Helvetica=24 S_l=0.6}" at 0.02, -0.006

plot \
'4PN_EandJ_corot.dat'     u 1:2 w l lt 1 lw 2 lc rgb "#0000FF" title "4PN co",\
'4PN_EandJ_irrot.dat'     u 1:2 w l lt 1 lw 2 lc rgb "#000000" title "4PN ir",\
'4PN_EandJ_spin.dat'      u 1:2 w l lt 1 lw 2 lc rgb "#FF0000" title "SO only",\
'4PN_EandJ_spin.dat'      u 1:(($2)+0.5*($1)**2) w l lt 2 lw 2 lc rgb "#006400" title "SO+({/Symbol=28 W} M)^2/2"

#'3PN_EandJ_BBH_corot.dat' u 1:2 w l lt 2 lw 1 lc rgb "#FF0000" title "3PN co",\
#'3PN_EandJ_BBH_irrot.dat' u 1:2 w l lt 2 lw 1 lc rgb "#0000FF" title "3PN ir",\
#'4PN_EandJ_BBH_corot.dat' u 1:2 w l lt 1 lw 1 lc rgb "#FF0000" title "4PN co",\
#'4PN_EandJ_BBH_irrot.dat' u 1:2 w l lt 1 lw 1 lc rgb "#0000FF" title "4PN ir",\


reset 
set output 'J_ome_34PN.eps'
set xlabel "{/Helvetica=28 {/Symbol=28 W} M }"
set ylabel "{/Helvetica=28 L/M^2}"
#set ylabel "{/Helvetica=24 M [M_{/CMSY10 \014}]}"
set title "{/Helvetica=28 S_1=S_2=(0,0,0.3)}"
#
set grid
#set arrow from x1, graph 0 to x1,f1 nohead lt 2 lw 2 lc rgb "#000000"
set xrange [0.01:0.07]
#set yrange [-0.015:0.015]
#set mxtics 4
#set mytics 5
set pointsize 1.6
set tics scale  2, 1
#set title sprintf("{/Helvetica=24 R=%1.3f     M_{max adm}=%1.3f}", x1,f1)
set label 1 "{/Helvetica=24 S_l=0.6}" at 0.025,1.2

plot \
'4PN_EandJ_corot.dat'     u 1:4 w l lt 1 lw 2 lc rgb "#0000FF" title "4PN co",\
'4PN_EandJ_irrot.dat'     u 1:4 w l lt 1 lw 2 lc rgb "#000000" title "4PN ir",\
'4PN_EandJ_spin.dat'      u 1:4 w l lt 1 lw 2 lc rgb "#FF0000" title "SO only",\
'4PN_EandJ_spin.dat'      u 1:(($4)+($1)) w l lt 2 lw 2 lc rgb "#006400" title "SO+({/Symbol=28 W} M)"

#'4PN_EandJ_spin.dat'      u 1:(($4)-($1)**1.5) w l lt 2 lw 2 lc rgb "#FF0000" title "SO only",\
#'4PN_EandJ_spin.dat'      u 1:4 w l lt 1 lw 2 lc rgb "#FF0000" title "SO+({/Symbol=28 W} M)^{1.5}"
#'3PN_EandJ_BBH_corot.dat' u 1:4 w l lt 2 lw 1 lc rgb "#FF0000" title "3PN co",\
#'3PN_EandJ_BBH_irrot.dat' u 1:4 w l lt 2 lw 1 lc rgb "#0000FF" title "3PN ir",\
#'4PN_EandJ_BBH_corot.dat' u 1:4 w l lt 1 lw 1 lc rgb "#FF0000" title "4PN co",\
#'4PN_EandJ_BBH_irrot.dat' u 1:4 w l lt 1 lw 1 lc rgb "#0000FF" title "4PN ir",\

reset 
set output 'Eb_J_34PN.eps'
set xlabel "{/Helvetica=28 L/M^2 }"
set ylabel "{/Helvetica=28 E_b/M}"
#set ylabel "{/Helvetica=24 M [M_{/CMSY10 \014}]}"
set title "{/Helvetica=28 S_1=S_2=(0,0,0.3)}"
#
set grid
set key right bottom
#set arrow from x1, graph 0 to x1,f1 nohead lt 2 lw 2 lc rgb "#000000"
set xrange [0.8:1.2]
#set yrange [-0.015:0.015]
#set mxtics 4
#set mytics 5
set pointsize 1.6
set tics scale  2, 1
#set title sprintf("{/Helvetica=24 R=%1.3f     M_{max adm}=%1.3f}", x1,f1)
set label 1 "{/Helvetica=24 S_l=0.6}" at 0.85,-0.008

plot \
'4PN_EandJ_corot.dat'     u 4:2 w l lt 1 lw 2 lc rgb "#0000FF" title "4PN co",\
'4PN_EandJ_irrot.dat'     u 4:2 w l lt 1 lw 2 lc rgb "#000000" title "4PN ir",\
'4PN_EandJ_spin.dat'      u 4:2 w l lt 1 lw 2 lc rgb "#FF0000" title "SO only"

