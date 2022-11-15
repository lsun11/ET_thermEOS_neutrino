set contour base
set nosurface
set xrange [-7:7]
set yrange [-7:7]
set view 0,0
set term table

set size sq 1.0,1.0
set zero 1e-20
set pointsize 1.6
set xtics  1
set ytics  1

set key 4.5,5 title "Psi in xy-plane"
call "contXY.plt" "7" "1" "10"
set key 4.5,5 title "alpha in xy-plane"
call "contXY.plt" "8" "2" "10"

set key 4.5,5 title "Psi in xz-plane"
call "contXZ.plt" "7" "3" "10"
set key 4.5,5 title "alpha in xz-plane"
call "contXZ.plt" "8" "4" "10"

pause -1

