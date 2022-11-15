# Gnuplot script file for plotting result data 

reset ;
x1=0     ; x2=60.0 ; 
y1=0.0001 ; y2=60  ; 

a=0.25 ;
ex_rgin=1.375 ;
ex_rgout=3.625 ;
sepa=2.5 ;

#set xtics ("-5" -5,"-2" -2,"-0.25" -0.25, "1.375" 1.375, "3.625" 3.625, "5" 5, "7" 7, "10" 10) ;
#set ytics ("10" 10 ,"1.0" 1.0, "0.1" 0.1, "0.05" 0.05, "0.01" 0.01, "0.003" 0.003, "0.001" 0.001, "0.0005" 0.0005, "0.0001" 0.0001) ;
set mytics 5 ;
#set format y "10^{%L}" ; 
set grid ; set xrange [x1:x2] ; 
set yrange [y1:y2] ;
set size 0.9,0.5 ;
#f(x)=1+ra/abs(x-bhp) ;

set xlabel "r"  0,0 font "Helvetica, 18" ;
set ylabel "{/Symbol |d(a)/(a)|} [%]"  1,0 font "Helvetica, 18" ;

set pointsize 0.7 ;

set style line 1 lt 1 lw 2 ;
set style line 2 lt 3 lw 2 ;

# Plot vertical arrows   
#set arrow 1 from -a,y1 to -a,y2 nohead lt 8 ;
#set arrow 2 from  a,y1 to  a,y2 nohead lt 8 ;
#set arrow 3 from ex_rgin,y1 to ex_rgin,y2 nohead lt 8 ;
#set arrow 4 from ex_rgout,y1 to ex_rgout,y2 nohead lt 8 ;
   
# Plot horizontal arrows
#set arrow 5 from ex_rgin,0.0005 to ex_rgout,0.0005 lt -1 ;
#set arrow 6 from ex_rgout,0.0005 to ex_rgin,0.0005 lt -1 ;

set logscale y 10 ;

plot "./average_error_G1.dat"    u 1:3 w l lw 2 lt 1 t 'G1',\
     "./average_error_G2.dat"    u 1:3 w l lw 2 lt 2 t 'G2',\
     "./average_error_G3.dat"    u 1:3 w l lw 2 lt 3 t 'G3'


# LINE COLORS, STYLES 
# Differs from x11 to postscript
# lt chooses a particular line type: -1=black 1=red 2=grn 3=blue 4=purple 5=aqua 6=brn 7=orange 8=light-brn
# lt must be specified before pt for colored points
# for postscipt -1=normal, 1=grey, 2=dashed, 3=hashed, 4=dot, 5=dot-dash
# lw chooses a line width 1=normal, can use 0.8, 0.3, 1.5, 3, etc.
# ls chooses a line style
