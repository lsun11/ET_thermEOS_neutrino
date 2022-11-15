program NS_surf_decrease
  implicit none
  integer :: nrg, ntg, npg
  integer :: nrf, ntf, npf
  integer :: it, ip, nn = 16, dum
  real(8) :: thg(0:500), phig(0:500), rs(0:500,0:500)
!
  open(24,file='rnsshape_NS_gnuplot.dat',status='old')
  open(30,file='rnsshape_NS_gnuplot_small.dat',status='unknown')
!
  open(1,file='rnspar.dat',status='old')
  read(1,'(4i5)') nrg, ntg, npg
  read(1,'(4i5)') nrf, ntf, npf
  close(1)
!
  do ip = 0, npf
    do it = 0, ntf
      read(24,'(1p,3e20.12)') phig(ip), thg(it), rs(it,ip)
    end do
    read(24,*) 
  end do
!
  do ip = 0, npf
    if (mod(ip,npf/nn).eq.0) then
      do it = 0, ntf
        write(30,'(1p,3e20.12)') phig(ip), thg(it), rs(it,ip)
      end do
    end if
    write(30,'(/)')
  end do
  do it = 1, ntf-1
    if (mod(it,ntf/nn).eq.0) then
      do ip = 0, npf
        write(30,'(1p,3e20.12)') phig(ip), thg(it), rs(it,ip)
      end do
    end if
    write(30,'(/)')
  end do
end program NS_surf_decrease
