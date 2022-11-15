set contour base
set nosurface
set xrange [-1.1:1.1]
set yrange [-1.1:1.1]
set view 0,0

set size sq 1.0,1.0
set zero 1e-20
set pointsize 1.5
set ticscale 2

set xtics  1
set ytics  1
set mxtics  5
set mytics  5

## set key 2,3.2 title "p/\rho in xy-plane"
call "contXY_print.plt" "3" "1" "10" "contour_density_xy-plane.eps" "1" "2" "2"
## set key 2,3.2 title "p/\rho in xz-plane"
call "contXZ_print.plt" "3" "1" "10" "contour_density_xz-plane.eps" "1" "2" "2"
## set key 2,3.2 title "p/\rho in yz-plane"
call "contYZ_print.plt" "3" "1" "10" "contour_density_yz-plane.eps" "1" "2" "2"
