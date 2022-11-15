set contour base
set nosurface
set xrange [-1.1:1.1]
set yrange [-1.1:1.1]
set view 0,0

set size sq 1.0,1.0
set zero 1e-20
set pointsize 1.6
set ticscale 2
set format x "%3.1f"
set format y "%3.1f"
set xtics  1
set ytics  1
set mxtics  5
set mytics  5

set key 2,3.2 title "p/\rho in xy-plane"
call "contXY.plt" "3" "1" "10" "contour_density_xy-plane.eps" "1" "2" "2"
set key 2,3.2 title "p/\rho in xz-plane"
call "contXZ.plt" "3" "2" "10" "contour_density_xz-plane.eps" "1" "2" "2"
set key 2,3.2 title "p/\rho in yz-plane"
call "contYZ.plt" "3" "3" "10" "contour_density_yz-plane.eps" "1" "2" "2"

pause -1
