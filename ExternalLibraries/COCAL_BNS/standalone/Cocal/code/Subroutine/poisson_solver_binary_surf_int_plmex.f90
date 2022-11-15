subroutine poisson_solver_binary_surf_int_plmex(impt,sou_surf,dsou_surf, pot)
  use phys_constant,  only : long, pi
  use grid_parameter, only : nrg, npg, ntg, nlg
  use radial_green_fn_grav, only : hgfn
  use legendre_fn_grav, only : hplmg, facnmg, epsig
  use legendre_fn_grav_plmex
  use trigonometry_grav_phi, only : hsinmpg, hcosmpg
  use grid_parameter_binary_excision, only : ex_radius
  use grid_points_binary_excision, only : rb, thb, phib, irg_exin, irg_exout
  use weight_midpoint_binary_excision,  only : hwtpg_ex
  use make_array_1d
  use make_array_2d
  implicit none
! 
  integer :: irg, irr, itg, itt, ipg, ipp, impt
  integer :: im, il, mm, nn, kk
!
  real(long) :: pi4inv = 1.0d0/4.0d0/pi
  real(long) :: pef, wok, wokc, woks
  real(long) :: q1, q2, cc1, ss1, fmm, fkk
  real(long) :: w1c, gw1c, w1s, gw1s, gwok
  real(long) :: rra1, rra1l
  real(long) :: work41c, gwork41c, work41s, gwork41s
!
  real(long), pointer :: sou_surf(:,:),dsou_surf(:,:),pot(:,:,:)
!
  real(long), pointer :: work11c(:,:), gwork11c(:,:)
  real(long), pointer :: work11s(:,:), gwork11s(:,:)
  real(long), pointer :: work21c(:,:), gwork21c(:,:)
  real(long), pointer :: work21s(:,:), gwork21s(:,:)
!
  call alloc_array2d( work11c, 1, ntg, 0, nlg)
  call alloc_array2d(gwork11c, 1, ntg, 0, nlg)
  call alloc_array2d( work11s, 1, ntg, 0, nlg)
  call alloc_array2d(gwork11s, 1, ntg, 0, nlg)
  call alloc_array2d( work21c, 0, nlg, 0, nlg)
  call alloc_array2d(gwork21c, 0, nlg, 0, nlg)
  call alloc_array2d( work21s, 0, nlg, 0, nlg)
  call alloc_array2d(gwork21s, 0, nlg, 0, nlg)

!
! -- integrate on midpoint
   work11c(:,:) = 0.0d0
  gwork11c(:,:) = 0.0d0
   work11s(:,:) = 0.0d0
  gwork11s(:,:) = 0.0d0
  do im = 0, nlg
    do itt = 1, ntg
      do ipp = 1, npg
        wokc = hwtpg_ex(itt,ipp)*hcosmpg(im,ipp)
        woks = hwtpg_ex(itt,ipp)*hsinmpg(im,ipp)
        work11c(itt,im)  = work11c(itt,im) + wokc*dsou_surf(itt,ipp)
        gwork11c(itt,im) = gwork11c(itt,im) + wokc*sou_surf(itt,ipp)
        work11s(itt,im)  = work11s(itt,im) + woks*dsou_surf(itt,ipp)
        gwork11s(itt,im) = gwork11s(itt,im) + woks*sou_surf(itt,ipp)
      end do
    end do
  end do
!
   work21c(:,:) = 0.0d0
  gwork21c(:,:) = 0.0d0
   work21s(:,:) = 0.0d0
  gwork21s(:,:) = 0.0d0
  do il = 0, nlg
    do im = 0, nlg
      pef  = epsig(im)*facnmg(il,im)
      do itt = 1, ntg
        wok = pef*hplmg(il,im,itt)
        work21c(il,im)  = work21c(il,im) + wok*work11c(itt,im)
        gwork21c(il,im) = gwork21c(il,im) + wok*gwork11c(itt,im)
        work21s(il,im)  = work21s(il,im) + wok*work11s(itt,im)
        gwork21s(il,im) = gwork21s(il,im) + wok*gwork11s(itt,im)
      end do
    end do
  end do
!
!
  pot = 0.0d0
!
  do ipg = 0, npg
    do itg = 0, ntg
      do irg = 0, nrg
        if (irg.gt.irg_exin(itg,ipg).and. &
         &  irg.lt.irg_exout(itg,ipg)) cycle

        work41c  = 0.0d0
        gwork41c = 0.0d0
        work41s  = 0.0d0
        gwork41s = 0.0d0
        do im = 0, nlg
          w1c  = 0.0d0
          gw1c = 0.0d0
          w1s  = 0.0d0
          gw1s = 0.0d0
          do il = 0, nlg
            wok  = - ex_radius*plm_ex(impt,irg,itg,ipg,il,im)
            gwok =  - dble(il)*plm_ex(impt,irg,itg,ipg,il,im)
            w1c  =  w1c +  wok* work21c(il,im)
            gw1c = gw1c + gwok*gwork21c(il,im)
            w1s  =  w1s +  wok* work21s(il,im)
            gw1s = gw1s + gwok*gwork21s(il,im)
          end do
          work41c  =  work41c +  w1c*dcos(dble(im)*phib(irg,itg,ipg))
          gwork41c = gwork41c + gw1c*dcos(dble(im)*phib(irg,itg,ipg))
          work41s  =  work41s +  w1s*dsin(dble(im)*phib(irg,itg,ipg))
          gwork41s = gwork41s + gw1s*dsin(dble(im)*phib(irg,itg,ipg))
        end do
!
        pot(irg,itg,ipg) = pi4inv*(work41c + work41s) &
        &                - pi4inv*(gwork41c +gwork41s)

!        if(ipg==5 .and. itg==5 .and. irg<=5)   write(6,'(a10,1p,2e20.12)') "pot=", pot(irg,itg,ipg)

      end do
    end do
  end do
!
  deallocate( work11c)
  deallocate(gwork11c)
  deallocate( work11s)
  deallocate(gwork11s)
  deallocate( work21c)
  deallocate(gwork21c)
  deallocate( work21s)
  deallocate(gwork21s)
!
end subroutine poisson_solver_binary_surf_int_plmex
