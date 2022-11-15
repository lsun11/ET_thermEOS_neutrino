set contour base
set nosurface
set xrange [-10:10]
set yrange [-10:10]
set view 0,0
set term table

set size sq 1.0,1.0
set zero 1e-20
set pointsize 1.6
set xtics  2
set ytics  2

set key 7,10.7 title "Conformal factor in xy-plane"
call "contXY_print.plt" "7" "1" "14" "contour_psi_xy-plane.eps"
set key 4,10.7 title "Lapse in xy-plane"
call "contXY_print.plt" "8" "2" "14" "contour_lapse_xy-plane.eps"

set key 7,10.7 title "Conformal factor in xz-plane"
call "contXZ_print.plt" "7" "3" "14" "contour_psi_xz-plane.eps"
set key 4,10.7 title "Lapse in xz-plane"
call "contXZ_print.plt" "8" "4" "14" "contour_lapse_xz-plane.eps"
