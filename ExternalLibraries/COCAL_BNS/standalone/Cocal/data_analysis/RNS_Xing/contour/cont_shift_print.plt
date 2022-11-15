set contour base
set nosurface
set xrange [-10:10]
set yrange [-10:10]
set view 0,0

set size sq 1.0,1.0
set zero 1e-20
set pointsize 1.6
set xtics  2
set ytics  2

set key 8,10.7 title "Shift (x-component) in xy-plane"
call "contXY_print.plt"  "9" "1" "24" "contour_shiftx_xy-plane.eps"
set key 8,10.7 title "Shift (y-component) in xy-plane"
call "contXY_print.plt" "10" "2" "24" "contour_shifty_xy-plane.eps"
#set key 8,10.7 title "Shift (z-component) in xy-plane"
#call "contXY_print.plt" "11" "3" "24" "contour_shiftz_xy-plane.eps"

#set key 8,10.7 title "Shift (x-component) in xz-plane"
#call "contXZ_print.plt"  "9" "4" "24" "contour_shiftx_xz-plane.eps"
set key 8,10.7 title "Shift (y-component) in xz-plane"
call "contXZ_print.plt" "10" "5" "24" "contour_shifty_xz-plane.eps"
#set key 8,10.7 title "Shift (z-component) in xz-plane"
#call "contXZ_print.plt" "11" "6" "24" "contour_shiftz_xz-plane.eps"
