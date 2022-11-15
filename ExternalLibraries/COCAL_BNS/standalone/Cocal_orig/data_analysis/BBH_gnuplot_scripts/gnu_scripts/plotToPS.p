# Gnuplot script file for plotting result data 

reset ;

set terminal postscript portrait enhanced color "Helvetica" 14 ;

set output "PoissonErrors_alpha_ND_A=-0.25.ps" ;
load "plot_x.p" ;

set output "PoissonErrors_ave_alpha_ND_A=-0.25.ps" ;
load "plot_ave.p" ;
