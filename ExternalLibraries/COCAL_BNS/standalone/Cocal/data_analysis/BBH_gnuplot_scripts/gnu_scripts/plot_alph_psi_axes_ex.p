set term x11 0
reset
set terminal postscript enhanced eps color dashed "Helvetica" 24
##set terminal postscript enhanced eps color solid "Helvetica" 16

ra=0.2
re=1.125
ds=2.5
x1=-7.0
x2=+7.0
y1=0.0
y2=3.2
yarrow=2.5

set xlabel "{/Helvetica=38 x}"
set grid

#set format x "%4.1f"
set format y "%3.1f"
set zero 1e-20
set mxtics 4 ; set mytics 5
set pointsize 1.6
set tics scale  2, 1

#set key right top reverse Left
##set key width -1
#set key box lw 0.2
##set key title "df/dr 3rd"

set xrange [x1:x2]
set yrange [y1:y2]

set label "{/Symbol=32 y}" at -2, 1.5
set label "{/Symbol=32 a}" at -2, 0.6

# Plot vertical arrows
set arrow 1 from -ra,y1 to -ra,y2 nohead lw 1 lt -1 ;
set arrow 2 from  ra,y1 to  ra,y2 nohead lw 1 lt -1 ;
set arrow 3 from ds-re,y1 to ds-re,y2 nohead lw 2 lt 3  ;
set arrow 4 from ds+re,y1 to ds+re,y2 nohead lw 2 lt 3  ;

# Plot horizontal arrows
set arrow 5 from     x1,yarrow to   -ra,yarrow lt -1
set arrow 6 from    -ra,yarrow to    x1,yarrow lt -1
set arrow 7 from     ra,yarrow to ds-re,yarrow lt -1
set arrow 8 from  ds-re,yarrow to    ra,yarrow lt -1
set arrow 9  from ds+re,yarrow to    x2,yarrow lt -1
set arrow 10 from    x2,yarrow to ds+re,yarrow lt -1

set label "{/Helvetica=28 COCP-BH}" at  -5,2.6 ;

set ylabel "{/Symbol=32 y, a}"
set output 'plot_alph_psi_x_ex.eps'
plot "./Cocal_debug/work_area_BBH_D3/plot_x.dat" u 1:2 w l lw 2 lt 1 notitle,\
     "./Cocal_debug/work_area_BBH_D3/plot_x.dat" u (abs($1)>1.06*re?1/0:ds-$1):2 w l lw 2 lt 2 notitle,\
     "./Cocal_debug/work_area_BBH_D3/plot_x.dat" u 1:3 w l lw 2 lt 1 notitle,\
     "./Cocal_debug/work_area_BBH_D3/plot_x.dat" u (abs($1)>1.06*re?1/0:ds-$1):3 w l lw 2 lt 2 notitle


set term x11 1
reset
set terminal postscript enhanced eps color dashed "Helvetica" 24
##set terminal postscript enhanced eps color solid "Helvetica" 16

ra=0.2
re=1.125
ds=2.5
x1=-7.0
x2=+7.0
y1=0.0
y2=3.2
yarrow=2.5

set xlabel "{/Helvetica=38 y}"
set grid

#set format x "%4.1f"
set format y "%3.1f"
set zero 1e-20
set mxtics 4 ; set mytics 5
set pointsize 1.6
set tics scale  2, 1

#set key right top reverse Left
##set key width -1
#set key box lw 0.2
##set key title "df/dr 3rd"

set xrange [x1:x2]
set yrange [y1:y2]

set label "{/Symbol=32 y}" at -2, 1.5
set label "{/Symbol=32 a}" at -2, 0.5

# Plot vertical arrows
set arrow 1 from -ra,y1 to -ra,y2 nohead lw 1 lt -1 ;
set arrow 2 from  ra,y1 to  ra,y2 nohead lw 1 lt -1 ;
#set arrow 3 from ds-re,y1 to ds-re,y2 nohead lw 2 lt 3  ;
#set arrow 4 from ds+re,y1 to ds+re,y2 nohead lw 2 lt 3  ;

# Plot horizontal arrows
set arrow 5 from     x1,yarrow to   -ra,yarrow lt -1
set arrow 6 from    -ra,yarrow to    x1,yarrow lt -1
set arrow 7 from     ra,yarrow to    x2,yarrow lt -1
set arrow 8 from     x2,yarrow to    ra,yarrow lt -1
#set arrow 7 from     ra,yarrow to ds-re,yarrow lt -1
#set arrow 8 from  ds-re,yarrow to    ra,yarrow lt -1
#set arrow 9  from ds+re,yarrow to    x2,yarrow lt -1
#set arrow 10 from    x2,yarrow to ds+re,yarrow lt -1

set label "{/Helvetica=28 COCP-BH}" at  -5,2.7 ;

set ylabel "{/Symbol=32 y, a}"
set output 'plot_alph_psi_y_ex.eps'
plot "./Cocal_debug/work_area_BBH_D3/plot_y.dat" u 1:2 w l lw 2 lt 1 notitle,\
     "./Cocal_debug/work_area_BBH_D3/plot_y.dat" u 1:3 w l lw 2 lt 1 notitle




set term x11 2
reset
set terminal postscript enhanced eps color dashed "Helvetica" 24
##set terminal postscript enhanced eps color solid "Helvetica" 16

ra=0.2
re=1.125
ds=2.5
x1=-7.0
x2=+7.0
y1=0.0
y2=3.2
yarrow=2.5

set xlabel "{/Helvetica=38 z}"
set grid

#set format x "%4.1f"
set format y "%3.1f"
set zero 1e-20
set mxtics 4 ; set mytics 5
set pointsize 1.6
set tics scale  2, 1

#set key right top reverse Left
##set key width -1
#set key box lw 0.2
##set key title "df/dr 3rd"

set xrange [x1:x2]
set yrange [y1:y2]

set label "{/Symbol=32 y}" at -2, 1.5
set label "{/Symbol=32 a}" at -2, 0.5

# Plot vertical arrows
set arrow 1 from -ra,y1 to -ra,y2 nohead lw 1 lt -1 ;
set arrow 2 from  ra,y1 to  ra,y2 nohead lw 1 lt -1 ;
#set arrow 3 from ds-re,y1 to ds-re,y2 nohead lw 2 lt 3  ;
#set arrow 4 from ds+re,y1 to ds+re,y2 nohead lw 2 lt 3  ;

# Plot horizontal arrows
set arrow 5 from     x1,yarrow to   -ra,yarrow lt -1
set arrow 6 from    -ra,yarrow to    x1,yarrow lt -1
set arrow 7 from     ra,yarrow to    x2,yarrow lt -1
set arrow 8 from     x2,yarrow to    ra,yarrow lt -1
#set arrow 7 from     ra,yarrow to ds-re,yarrow lt -1
#set arrow 8 from  ds-re,yarrow to    ra,yarrow lt -1
#set arrow 9  from ds+re,yarrow to    x2,yarrow lt -1
#set arrow 10 from    x2,yarrow to ds+re,yarrow lt -1

set label "{/Helvetica=28 COCP-BH}" at  -5,2.7 ;

set ylabel "{/Symbol=32 y, a}"
set output 'plot_alph_psi_z_ex.eps'
plot "./Cocal_debug/work_area_BBH_D3/plot_z.dat" u 1:2 w l lw 2 lt 1 notitle,\
     "./Cocal_debug/work_area_BBH_D3/plot_z.dat" u 1:3 w l lw 2 lt 1 notitle



