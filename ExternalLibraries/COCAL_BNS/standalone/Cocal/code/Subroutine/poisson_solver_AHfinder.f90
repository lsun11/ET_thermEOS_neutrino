subroutine poisson_solver_AHfinder(sou,pot)
  use phys_constant, only : long, pi
  use grid_parameter, only : nlg, npg, ntg
  use legendre_fn_grav, only : plmg, hplmg, facnmg, epsig
  use trigonometry_grav_theta
  use trigonometry_grav_phi, only : sinmpg, cosmpg, hsinmpg, hcosmpg
  use weight_midpoint_grav,  only :  hwdtg, hwdpg
  use make_array_2d
  implicit none
  integer :: im, il, nlgtmp
  integer :: it, itt, ip, ipp       
  real(long) :: pef, wok, pi4inv, ell, facl
  real(long), pointer :: sou(:,:), pot(:,:)
  real(long), pointer :: work1c(:,:), work2c(:,:), work4c(:,:), &
  &                      work1s(:,:), work2s(:,:), work4s(:,:)
!
  call alloc_array2d(work1c, 1, ntg, 0, nlg)
  call alloc_array2d(work1s, 1, ntg, 0, nlg)
  call alloc_array2d(work2c, 0, nlg, 0, nlg)
  call alloc_array2d(work2s, 0, nlg, 0, nlg)
  call alloc_array2d(work4c, 0, nlg, 0, ntg)
  call alloc_array2d(work4s, 0, nlg, 0, ntg)
!
  work1c = 0.0d0
  work1s = 0.0d0
  do im = 0, nlg
    do itt = 1, ntg
      do ipp = 1, npg
        wok = hwdtg(itt)*hwdpg(ipp)*sou(itt,ipp)
        work1c(itt,im) = work1c(itt,im) + wok*hcosmpg(im,ipp)
        work1s(itt,im) = work1s(itt,im) + wok*hsinmpg(im,ipp)
      end do
    end do
  end do
!
  work2c = 0.0d0
  work2s = 0.0d0
  do il = 0, nlg
    do im = 0, nlg
      pef  = epsig(im)*facnmg(il,im)
      do itt = 1, ntg
        wok = pef*hplmg(il,im,itt)
        work2c(il,im) = work2c(il,im) + wok*work1c(itt,im)
        work2s(il,im) = work2s(il,im) + wok*work1s(itt,im)
      end do
    end do
  end do
!
  work4c = 0.0d0
  work4s = 0.0d0
  do it = 0, ntg
    do im = 0, nlg
      do il = 0, nlg
        ell = dble(il)
        facl = (2.0d0*ell+1.0d0)/(ell*(ell+1.0d0)+2.0d0)
        wok = plmg(il,im,it)*facl
        work4c(im,it) = work4c(im,it) + wok*work2c(il,im)
        work4s(im,it) = work4s(im,it) + wok*work2s(il,im)
      end do
    end do
  end do
!
  pot = 0.0d0
  do ip = 0, npg
    do it = 0, ntg
      do im = 0, nlg
        pot(it,ip) = pot(it,ip)&
        &          + work4c(im,it)*cosmpg(im,ip) &
        &          + work4s(im,it)*sinmpg(im,ip)
      end do
    end do
  end do
!
  pi4inv = 1.0d0/4.0d0/pi
  pot(0:ntg,0:npg) = - pi4inv*pot(0:ntg,0:npg)
!
end subroutine poisson_solver_AHfinder
