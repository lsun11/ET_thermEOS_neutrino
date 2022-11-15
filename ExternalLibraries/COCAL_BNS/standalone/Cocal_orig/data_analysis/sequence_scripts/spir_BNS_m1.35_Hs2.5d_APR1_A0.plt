set terminal postscript enhanced eps color dashed "Helvetica" 24 \
fontfile "/usr/share/texmf/fonts/type1/bluesky/cm/cmsy10.pfb"

set output '2_spir_M_m1.35_Hs2.5d_APR1_A0.eps'
set multiplot
set origin 0,0.4
set size 1.0,0.6
set tmargin 1
set bmargin 0

#set size sq 1.0,1.0
#set title "{/Helvetica=38 C=0.18}"
#set ylabel "{/Helvetica=38 (M-M_{/Symbol \245})/M_0}"
set ylabel "{/Helvetica=28 E_b/M_{/Symbol \245} }"
#set xlabel "{/Helvetica=28 {/Symbol=28 W} M_{/Symbol \245} }"
set grid
set key width -3.5 spacing 1.3
set key box
m012=1.298943e-01
ma12=1.222508e-01
m014=1.460991E-01
ma14=1.361943E-01
m016=1.599600E-01
ma16=1.477959E-01
m018=1.709018E-01
ma18=1.566915E-01
set xrange [0.01:0.06]
set xtics 0.01, 0.01,0.06
set xtics format " "
#set format x "%.2f"
set mxtics 4
set yrange [-0.016:-0.002]
set ytics -0.016, 0.002, -0.002
set format y "%.3f"
set mytics 4
set grid
plot '4PN_EandJ_BBH_irrot.dat' u 1:2 w l lt 2 lw 1 lc rgb "#000000" title "4PN irrotational",\
     '4PN_EandJ_BBH_corot.dat' u 1:2 w l lt 0 lw 3 lc rgb "#006400" title "3PN corotating",\
"Hs2.5d_APR1" u (2.0*($1)*($8)/($2)):((($5)-2.0*($8))/(2.0*($8)))  w lp  lt 1 lw 2 lc rgb "#8A2BE2" title "NR: irrotational",\
"spHs2.5d_APR1_w0.01_A0.txt" u (2.0*($1)*($8)/($2)):((($5)-2.0*($8))/(2.0*($8))) w lp  lt 1 lw 2 lc rgb "#FF0000" \
title "NR: {~S{.6\\176}}_0=0.01",\
"spHs2.5d_APR1_w0.05_A0.txt" u (2.0*($1)*($8)/($2)):((($5)-2.0*($8))/(2.0*($8))) w lp  lt 1 lw 2 lc rgb "#0000FF" \
title "NR: {~S{.6\\176}}_0=0.05"


set size 1.0,0.4
set origin 0,0
set tmargin 1
set bmargin 0
set ylabel "{/Helvetica=28 {/Symbol D}E/E_{ir} (x 10^{2})}"
set xlabel "{/Helvetica=28 {/Symbol=28 W} M_{/Symbol \245} }"
set key width +2 top left
set key box
set xrange [0.01:0.06]
set xtics 0.01, 0.01,0.06
set format x "%.2f"
set mxtics 4
set yrange [-0.01:0.03]
set ytics -0.01, 0.01, 0.03
#set format y "%.3f"
##set mytics 4
mf=100
plot \
"spHs2.5d_APR1_ir_w0.01_w0.05_A0_col_1_2_5_8.txt" u (2.0*($1)*($4)/($2)):(mf*(($7)-($3))/($3)) w lp  lt 1 lw 2 lc rgb "#FF0000" \
title "{~S{.6\\176}}_0=0.01",\
"spHs2.5d_APR1_ir_w0.01_w0.05_A0_col_1_2_5_8.txt" u (2.0*($1)*($4)/($2)):(mf*(($11)-($3))/($3)) w lp  lt 1 lw 2 lc rgb "#0000FF" \
title "{~S{.6\\176}}_0=0.05"

unset multiplot

# blue rgb "#0000FF"

reset

set output '2_spir_J_m1.35_Hs2.5d_APR1_A0.eps'
set multiplot
set origin 0,0.4
set size 1.0,0.6
set tmargin 1
set bmargin 0

#set size sq 1.0,1.0
#set title "{/Helvetica=38 C=0.18}"
set ylabel "{/Helvetica=28 J/M_{/Symbol \245}^2 }"
#set xlabel "{/Helvetica=28 {/Symbol=28 W} M_{/Symbol \245} }"
set grid
set key width -3.5 spacing 1.3
set key box
m012=1.298943e-01
ma12=1.222508e-01
m014=1.460991E-01
ma14=1.361943E-01
m016=1.599600E-01
ma16=1.477959E-01
m018=1.709018E-01
ma18=1.566915E-01
set xrange [0.01:0.06]
set xtics 0.01, 0.01,0.06
set xtics format " "
#set format x "%.2f"
set mxtics 4
set yrange [0.80:1.3]
set ytics 0.80,0.05,1.3
set format y "%.2f"
set mytics 5
set grid
plot '4PN_EandJ_BBH_irrot.dat' u 1:4 w l lt 2 lw 1 lc rgb "#000000" title "4PN irrotational",\
     '4PN_EandJ_BBH_corot.dat' u 1:4 w l lt 0 lw 3 lc rgb "#006400" title "3PN corotating",\
"Hs2.5d_APR1" u (2.0*($1)*($8)/($2)):(($7)/((2.0*($8))**2))    w lp  lt 1 lw 2 lc rgb "#8A2BE2" title "NR: irrotational",\
"spHs2.5d_APR1_w0.01_A0.txt" u (2.0*($1)*($8)/($2)):(($7)/((2.0*($8))**2))   w lp  lt 1 lw 2 lc rgb "#FF0000" \
title "NR: {~S{.6\\176}}_0=0.01",\
"spHs2.5d_APR1_w0.05_A0.txt" u (2.0*($1)*($8)/($2)):(($7)/((2.0*($8))**2))   w lp  lt 1 lw 2 lc rgb "#0000FF" \
title "NR: {~S{.6\\176}}_0=0.05"

set size 1.0,0.4
set origin 0,0
set tmargin 1
set bmargin 0
set ylabel "{/Helvetica=28 {/Symbol D}J/J_{ir} }"
set xlabel "{/Helvetica=28 {/Symbol=28 W} M_{/Symbol \245} }"
set key width +2 top left
set key box
set xrange [0.01:0.06]
set xtics 0.01, 0.01,0.06
set format x "%.2f"
set mxtics 4
set yrange [0:0.05]
set ytics 0, 0.01, 0.05
set format y "%.2f"
##set mytics 4
mf=1
plot \
"spHs2.5d_APR1_ir_w0.01_w0.05_A0_col_1_2_7_8.txt" u (2.0*($1)*($4)/($2)):(mf*(($7)-($3))/($3)) w lp  lt 1 lw 2 lc rgb "#FF0000" \
title "{~S{.6\\176}}_0=0.01",\
"spHs2.5d_APR1_ir_w0.01_w0.05_A0_col_1_2_7_8.txt" u (2.0*($1)*($4)/($2)):(mf*(($11)-($3))/($3)) w lp  lt 1 lw 2 lc rgb "#0000FF" \
title "{~S{.6\\176}}_0=0.05"

unset multiplot


reset 
#set size sq 1.0,1.0
#set title "{/Helvetica=38 C=0.18}"
set ylabel "{/Helvetica=28 J/M_{/Symbol \245}^2 }"
set xlabel "{/Helvetica=28 E_b/M_{/Symbol \245} }"
set grid
set key width -3.5 spacing 1.3 left top
set key box
m012=1.298943e-01
ma12=1.222508e-01
m014=1.460991E-01
ma14=1.361943E-01
m016=1.599600E-01
ma16=1.477959E-01
m018=1.709018E-01
ma18=1.566915E-01
set yrange [0.80:1.3]
set ytics 0.80,0.05,1.3
set format y "%.2f"
set mytics 5
set xrange [-0.016:-0.006]
set xtics -0.016, 0.002, -0.006
set format x "%.3f"
set mxtics 4

set output '2_spir_JM_m1.35_Hs2.5d_APR1_A0.eps'
plot \
'4PN_EandJ_BBH_irrot.dat' u 2:4 w l lt 2 lw 1 lc rgb "#000000" title "4PN irrotational",\
'4PN_EandJ_BBH_corot.dat' u 2:4 w l lt 0 lw 3 lc rgb "#006400" title "3PN corotating",\
"Hs2.5d_APR1" u ((($5)-2.0*($8))/(2.0*($8))):(($7)/((2.0*($8))**2)) w lp  lt 1 lw 2 lc rgb "#8A2BE2" title "NR: irrotational",\
"spHs2.5d_APR1_w0.01_A0.txt" u ((($5)-2.0*($8))/(2.0*($8))):(($7)/((2.0*($8))**2))  w lp  lt 1 lw 2 lc rgb "#FF0000" \
title "NR: {~S{.6\\176}}_0=0.01",\
"spHs2.5d_APR1_w0.05_A0.txt" u ((($5)-2.0*($8))/(2.0*($8))):(($7)/((2.0*($8))**2))  w lp  lt 1 lw 2 lc rgb "#0000FF" \
title "NR: {~S{.6\\176}}_0=0.05"





