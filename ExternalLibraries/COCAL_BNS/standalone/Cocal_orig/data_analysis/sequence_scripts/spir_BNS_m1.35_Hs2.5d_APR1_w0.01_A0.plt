set terminal postscript enhanced eps color dashed "Helvetica" 24 \
fontfile "/usr/share/texmf/fonts/type1/bluesky/cm/cmsy10.pfb"

#set size sq 1.0,1.0
#set title "{/Helvetica=38 C=0.18}"
#set ylabel "{/Helvetica=38 (M-M_{/Symbol \245})/M_0}"
set ylabel "{/Helvetica=28 E_b/M_{/Symbol \245} }"
set xlabel "{/Helvetica=28 {/Symbol=28 W} M_{/Symbol \245} }"
set grid
set key width -1
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
set format x "%.2f"
set mxtics 4
set yrange [-0.016:-0.004]
set ytics -0.016, 0.002, -0.004
set format y "%.3f"
set mytics 4
set grid
set output '2_spir_M_m1.35_Hs2.5d_APR1_w0.01_A0.eps'
plot '4PN_EandJ_BBH_irrot.dat' u 1:2 w l lt 2 lw 1 lc rgb "#000000" title "4PN",\
     "Hs2.5d_APR1" u (2.0*($1)*($8)/($2)):((($5)-2.0*($8))/(2.0*($8)))  w lp  lt 1 lw 2 lc rgb "#8A2BE2" title "irrotational",\
     "spHs2.5d_APR1_w0.01_A0.txt" u (2.0*($1)*($8)/($2)):((($5)-2.0*($8))/(2.0*($8))) w lp  lt 1 lw 2 lc rgb "#FF0000" title "spinning"


# blue rgb "#0000FF"

reset
#set size sq 1.0,1.0
#set title "{/Helvetica=38 C=0.18}"
set ylabel "{/Helvetica=28 J/M_{/Symbol \245}^2 }"
set xlabel "{/Helvetica=28 {/Symbol=28 W} M_{/Symbol \245} }"
set grid
set key width -1
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
set format x "%.2f"
set mxtics 4
set yrange [0.80:1.2]
set ytics 0.80,0.05,1.2
set format y "%.2f"
set mytics 5
set grid
set output '2_spir_J_m1.35_Hs2.5d_APR1_w0.01_A0.eps'
plot '4PN_EandJ_BBH_irrot.dat' u 1:4 w l lt 2 lw 1 lc rgb "#000000" title "4PN",\
     "Hs2.5d_APR1" u (2.0*($1)*($8)/($2)):(($7)/((2.0*($8))**2))    w lp  lt 1 lw 2 lc rgb "#8A2BE2" title "irrotational",\
     "spHs2.5d_APR1_w0.01_A0.txt" u (2.0*($1)*($8)/($2)):(($7)/((2.0*($8))**2))   w lp  lt 1 lw 2 lc rgb "#FF0000" title "spinning"


reset 
#set size sq 1.0,1.0
#set title "{/Helvetica=38 C=0.18}"
set ylabel "{/Helvetica=28 J/M_{/Symbol \245}^2 }"
set xlabel "{/Helvetica=28 E_b/M_{/Symbol \245} }"
set grid
set key width -1
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

set output '2_spir_JM_m1.35_Hs2.5d_APR1_w0.01_A0.eps'
plot '4PN_EandJ_BBH_irrot.dat' u 2:4 w l lt 2 lw 1 lc rgb "#000000" title "4PN",\
     "Hs2.5d_APR1" u ((($5)-2.0*($8))/(2.0*($8))):(($7)/((2.0*($8))**2)) w lp  lt 1 lw 2 lc rgb "#8A2BE2" title "irrotational",\
     "spHs2.5d_APR1_w0.01_A0.txt" u ((($5)-2.0*($8))/(2.0*($8))):(($7)/((2.0*($8))**2))  w lp  lt 1 lw 2 lc rgb "#FF0000" title "spinning"





