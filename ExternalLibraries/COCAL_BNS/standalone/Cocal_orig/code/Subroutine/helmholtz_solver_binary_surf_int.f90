subroutine helmholtz_solver_binary_surf_int(sou_surf,dsou_surf, pot)
  use phys_constant,  only : long, pi
  use grid_parameter, only : nrg, npg, ntg, nlg
  use legendre_fn_grav, only : plmg, hplmg, facnmg, epsig
  use trigonometry_grav_phi, only : hsinmpg, hcosmpg
  use grid_parameter_binary_excision, only : ex_radius
  use grid_points_binary_excision, only : rb, thb, phib, irg_exin, irg_exout
  use weight_midpoint_binary_excision,  only : hwtpg_ex
  use def_matter_parameter, only : ome
  use make_array_1d
  use make_array_2d
  implicit none
! 
  integer :: irg, irr, itg, itt, ipg, ipp
  integer :: im, il, mm, nn, kk
!
  real(long) :: pi4inv = 1.0d0/4.0d0/pi
  real(long) :: pef, wok, wokc, woks
  real(long) :: q1, q2, cc1, ss1, fmm, fkk
  real(long) :: w1c, gw1c, w1s, gw1s, gwok
  real(long) :: rra1, rra1l
  real(long) :: work41c, gwork41c, work41s, gwork41s
  real(long) :: omega, omegam, omegam_rg, omegam_hrg, sj, sy, sbj, sby
  real(long) :: dxsj, dxsbj, dxsy
!
  real(long), pointer :: sou_surf(:,:),dsou_surf(:,:),pot(:,:,:)
  real(long), pointer :: sj_ex_radius(:,:), dxsj_ex_radius(:,:)
  real(long), pointer :: work11c(:,:), gwork11c(:,:)
  real(long), pointer :: work11s(:,:), gwork11s(:,:)
  real(long), pointer :: work21c(:,:), gwork21c(:,:)
  real(long), pointer :: work21s(:,:), gwork21s(:,:)
  real(long), pointer :: work31(:,:), gwork31(:,:)
  real(long), pointer :: plm_ex(:,:), fac(:)
  real(long), pointer :: sinmp1(:), cosmp1(:)
!
  call alloc_array2d(sj_ex_radius,   0, nlg, 0, nlg)
  call alloc_array2d(dxsj_ex_radius, 0, nlg, 0, nlg)
  call alloc_array2d( work11c, 1, ntg, 0, nlg)
  call alloc_array2d(gwork11c, 1, ntg, 0, nlg)
  call alloc_array2d( work11s, 1, ntg, 0, nlg)
  call alloc_array2d(gwork11s, 1, ntg, 0, nlg)
  call alloc_array2d( work21c, 0, nlg, 0, nlg)
  call alloc_array2d(gwork21c, 0, nlg, 0, nlg)
  call alloc_array2d( work21s, 0, nlg, 0, nlg)
  call alloc_array2d(gwork21s, 0, nlg, 0, nlg)
  call alloc_array2d( work31,  0, nlg, 0, nlg)
  call alloc_array2d(gwork31,  0, nlg, 0, nlg)
  call alloc_array2d(plm_ex, 0, nlg, 0, nlg)
  call alloc_array1d(fac, 0, nlg)
  call alloc_array1d(sinmp1, 0, nlg)
  call alloc_array1d(cosmp1, 0, nlg)
!
  fac(0) = 1.0d0
  do mm = 1, nlg
    fmm = dble(mm)
    fac(mm) = (2.0d0*fmm-1.0d0) * fac(mm-1)
  end do
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
  work31 = 0.0d0
  gwork31 = 0.0d0
  pot = 0.0d0
!
  sj_ex_radius(:,:) = 0.0d0
  dxsj_ex_radius(:,:) = 0.0d0
  omega = ome
  do il = 0, nlg
    do im = 0, il
      if (im.ne.0) then
        omegam = dble(im)*omega
        omegam_hrg = omegam*ex_radius
        call sphbess_and_dx(omegam_hrg,il,sj,sy,dxsj,dxsy)
        sj_ex_radius(im,il) = sj
        dxsj_ex_radius(im,il) = dxsj
      end if
    end do
  end do
!
  do ipg = 0, npg
    do itg = 0, ntg
      do irg = 0, nrg
      if (irg.gt.irg_exin(itg,ipg).and. &
     &    irg.lt.irg_exout(itg,ipg)) cycle
!
      plm_ex(:,:)  = 0.0d0
      cc1 = dcos(thb(irg,itg,ipg))
      ss1 = dsin(thb(irg,itg,ipg))
!
      plm_ex(0,0) = 1.0d0
      do mm = 1, nlg
        plm_ex(mm,mm) = fac(mm) * (-ss1)**mm 
      end do
!
      do mm = 0, nlg-1
        fmm = dble(mm)
        plm_ex(mm+1,mm) = (2.d0*fmm + 1.d0)*cc1*plm_ex(mm,mm)
      end do
!
      do mm = 0, nlg-2
        fmm = dble(mm)
        do kk = 2, nlg-mm
          fkk = dble(kk)
          q1 = ( 2.0d0 * fmm + 2.0d0 * fkk - 1.0d0 ) / fkk
          q2 = ( 2.0d0 * fmm + fkk - 1.0d0 ) / fkk
          plm_ex(mm+kk,mm) = q1 * cc1 * plm_ex(mm+kk-1,mm) &
         &                 - q2       * plm_ex(mm+kk-2,mm)
        end do
      end do
!
      do im = 0, nlg
        cosmp1(im) = dcos(dble(im)*phib(irg,itg,ipg))
        sinmp1(im) = dsin(dble(im)*phib(irg,itg,ipg))
      end do
!
!      rra1 = ex_radius/rb(irg,itg,ipg)
!      rra1l = 1.0d0
!      do il = 0, nlg
!        rra1l = rra1l*rra1
!        work31(il) = - ex_radius*rra1l
!        gwork31(il) = - dble(il)*rra1l
!      end do
!
! Radial green's functions are multiplied by -1 
! because the normal of the excision surface is pointing inward.
!
      omega = ome
      do il  = 0, nlg
        do im  = 0, il
          if(im.eq.0)then
            work31(il,im) = - ex_radius*(ex_radius/rb(irg,itg,ipg))**(il+1)
            gwork31(il,im) = - dble(il)*(ex_radius/rb(irg,itg,ipg))**(il+1)
          else
            omegam = dble(im)*omega
!            omegam_hrg = omegam*ex_radius
!            call sphbess_and_dx(omegam_hrg,il,sj,sy,dxsj,dxsy)
!            sbj = sj
!            dxsbj = dxsj
            sbj = sj_ex_radius(im,il)
            dxsbj = dxsj_ex_radius(im,il)
            omegam_rg = omegam*rb(irg,itg,ipg)
            call sphbess(omegam_rg,il,sj,sy)
            sby=sy
            wok = ex_radius**2*omegam*(2.d0*dble(il)+1.d0)
            work31(il,im) = wok*sbj*sby
            gwork31(il,im)= omegam*wok*dxsbj*sby
          endif
        end do
      end do
!
       work41c = 0.0d0
      gwork41c = 0.0d0
       work41s = 0.0d0
      gwork41s = 0.0d0
      do im = 0, nlg
         w1c = 0.0d0
        gw1c = 0.0d0
         w1s = 0.0d0
        gw1s = 0.0d0
        do il = 0, nlg
           wok =  work31(il,im)*plm_ex(il,im)
          gwok = gwork31(il,im)*plm_ex(il,im)
           w1c =  w1c +  wok* work21c(il,im)
          gw1c = gw1c + gwok*gwork21c(il,im)
           w1s =  w1s +  wok* work21s(il,im)
          gw1s = gw1s + gwok*gwork21s(il,im)
        end do
         work41c =  work41c +  w1c*cosmp1(im)
        gwork41c = gwork41c + gw1c*cosmp1(im)
         work41s =  work41s +  w1s*sinmp1(im)
        gwork41s = gwork41s + gw1s*sinmp1(im)
      end do
!
      pot(irg,itg,ipg) = pi4inv*(work41c + work41s) &
      &                - pi4inv*(gwork41c +gwork41s)
!
      end do
    end do
  end do
!
  deallocate(sj_ex_radius)
  deallocate(dxsj_ex_radius)
  deallocate( work11c)
  deallocate(gwork11c)
  deallocate( work11s)
  deallocate(gwork11s)
  deallocate( work21c)
  deallocate(gwork21c)
  deallocate( work21s)
  deallocate(gwork21s)
  deallocate( work31)
  deallocate(gwork31)
  deallocate(plm_ex)
  deallocate(fac)
  deallocate(sinmp1)
  deallocate(cosmp1)
!
end subroutine helmholtz_solver_binary_surf_int
