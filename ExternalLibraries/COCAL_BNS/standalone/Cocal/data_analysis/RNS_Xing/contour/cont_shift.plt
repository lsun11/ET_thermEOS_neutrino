set contour base
set nosurface
set xrange [-3.0:3.0]
set yrange [-3.0:3.0]
set view 0,0

set size sq 1.0, 1.0
set zero 1e-20
set pointsize 1.6
set xtics  2
set ytics  2

set key 4.5,5 title "Shift (x-component) in xy-plane"
call "contXY.plt" "9" "1" "24"
set key 4.5,5 title "Shift (y-component) in xy-plane"
call "contXY.plt" "10" "2" "24"
set key 4.5,5 title "Shift (z-component) in xy-plane"
call "contXY.plt" "11" "3" "24"

set key 4.5,5 title "Shift (x-component) in xz-plane"
call "contXZ.plt" "9" "4" "24"
set key 4.5,5 title "Shift (y-component) in xz-plane"
call "contXZ.plt" "10" "5" "24"
set key 4.5,5 title "Shift (z-component) in xz-plane"
call "contXZ.plt" "11" "6" "24"

pause -1

