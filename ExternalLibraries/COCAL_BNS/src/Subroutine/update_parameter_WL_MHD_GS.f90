subroutine update_parameter_WL_MHD_GS(convf)
  use phys_constant,  only  : long
  use grid_parameter, only : nrg, ntg, npg, nrf_deform, nrf, ntf, npf, ntgxy
  use def_metric,     only : psi, alph, bvxu, bvyu, bvzu
  use def_metric_hij, only : hxxd, hxyd, hxzd, hyyd, hyzd, hzzd
  use def_matter,     only : utf, uxf, uyf, uzf
  use def_emfield,    only : vayd
  use def_matter_parameter
  use coordinate_grav_r, only : rg
  use trigonometry_grav_theta, only : sinthg, costhg
  use trigonometry_grav_phi, only   : sinphig, cosphig
  use def_vector_phi, only : vec_phig, vec_phif
  use integrability_fnc_MHD, only : MHDfnc_Lambda_GS
  use interface_minv
  implicit none
  integer, parameter :: neq = 3, ndim = 3
  real(long), intent(in) :: convf
  real(long) ::    sgg(neq),  gg(neq,neq)
  real(long) ::  log_a(neq),  psi2al(neq)
  real(long) ::     ve(neq,ndim), be(neq,ndim)
  real(long) ::   vphi(neq,ndim), gm(neq,ndim,ndim)
  real(long) :: MHDfnc_dAt_val(neq), MHDfnc_Lambda_val(neq)
  real(long) :: ovufc(neq,ndim), oAufc(neq,ndim)
  real(long) :: dovufcii, dovufcjj, doAufcjj
  real(long) :: gmovoA(neq), gmovov(neq), gmdovov(neq), gmdovoA(neq)
  real(long) :: term1(neq), dterm1do(neq), dterm1dr(neq)
  real(long) :: term2(neq), dterm2do(neq), dterm2dr(neq)
  real(long) :: log_h(neq), loghc, Aphi
  real(long) :: radiold, berold, omeold
  real(long) :: ddradi, ddber, ddome
  real(long) :: facfac, numero, error, hc, pre, rho, ene
  integer    :: nin, irg, irf, itf, ipf, it, ip, ia, ii, jj
!##############################################
  nin = nrf_deform
!
  sgg = 0.0d0
  gg  = 0.0d0
!
  call peos_q2hprho(emdc, hc, pre, rho, ene)
  loghc = dlog(hc)
  omeold = ome
  berold = ber
  radiold = radi
  numero = 1
!
  do ia = 1, 3    
!   ia = 1 pole, ia = 2 equator, ia = 3 center.
    if (ia.eq.1) then; irg = nin; irf = nrf; it = 0    ; ip = 0; end if
    if (ia.eq.2) then; irg = nrf; irf = nrf; it = ntgxy; ip = 0; end if
    if (ia.eq.3) then; irg = 0  ; irf = 0  ; it = 0    ; ip = 0; end if
    log_a(ia)  = dlog(alph(irg,it,ip)**(1.0d0/radi**2))
    psi2al(ia) = (psi(irg,it,ip)**2/alph(irg,it,ip))**(1.0d0/radi**2)
    be(ia,1) = bvxu(irg,it,ip)
    be(ia,2) = bvyu(irg,it,ip)
    be(ia,3) = bvzu(irg,it,ip)
    vphi(ia,1) = vec_phig(irg,it,ip,1)
    vphi(ia,2) = vec_phig(irg,it,ip,2)
    vphi(ia,3) = vec_phig(irg,it,ip,3)
    gm(ia,1,1) = 1.0d0 + hxxd(irg,it,ip)
    gm(ia,1,2) =         hxyd(irg,it,ip)
    gm(ia,1,3) =         hxzd(irg,it,ip)
    gm(ia,2,2) = 1.0d0 + hyyd(irg,it,ip)
    gm(ia,2,3) =         hyzd(irg,it,ip)
    gm(ia,3,3) = 1.0d0 + hzzd(irg,it,ip)
    gm(ia,2,1) = gm(ia,1,2)
    gm(ia,3,1) = gm(ia,1,3)
    gm(ia,3,2) = gm(ia,2,3)
!
    log_h(ia) = 0.0d0
    if (ia.eq.3) log_h(ia) = loghc
  end do
! ---
!write (6,*) "test values"
!write (6,'(1p,3e12.4)') ome, ber, radi
!write (6,'(1p,3e12.4)') (log_a(ia), ia = 1, 3)
!write (6,'(1p,3e12.4)') (psi2al(ia), ia = 1, 3)
!write (6,'(1p,3e12.4)') (ve(ia,1), ia = 1, 3)
!write (6,'(1p,3e12.4)') (ve(ia,2), ia = 1, 3)
!write (6,'(1p,3e12.4)') (ve(ia,3), ia = 1, 3)
!write (6,'(1p,3e12.4)') (be(ia,1), ia = 1, 3)
!write (6,'(1p,3e12.4)') (be(ia,2), ia = 1, 3)
!write (6,'(1p,3e12.4)') (be(ia,3), ia = 1, 3)
!write (6,'(1p,3e12.4)') (vphi(ia,1), ia = 1, 3)
!write (6,'(1p,3e12.4)') (vphi(ia,2), ia = 1, 3)
!write (6,'(1p,3e12.4)') (vphi(ia,3), ia = 1, 3)
! write (6,'(1p,3e12.4)') (log_h(ia), ia = 1, 3)
! write (6,'(1p,3e12.4)') error
!do ia = 1, 3
! write (6,'(1p,3e12.4)') (gm(ia,1,ii), ii = 1, 3)
! write (6,'(1p,3e12.4)') (gm(ia,2,ii), ii = 1, 3)
! write (6,'(1p,3e12.4)') (gm(ia,3,ii), ii = 1, 3)
!end do
!!!!stop
! ---
  do
    do ia = 1, 3 ! ia = pole, equator, center
!
      if (ia.eq.1) then; irg = nin; irf = nrf; it = 0    ; ip = 0; end if
      if (ia.eq.2) then; irg = nrf; irf = nrf; it = ntgxy; ip = 0; end if
      if (ia.eq.3) then; irg = 0  ; irf = 0  ; it = 0    ; ip = 0; end if
      ve(ia,1) = uxf(irf,it,ip)/utf(irf,it,ip)
!!      ve(ia,2) = uyf(irf,it,ip)/utf(irf,it,ip)
      ve(ia,2) = ome*vphi(ia,2) ! uniform rotation SEE THE END OF THIS ROUTINE
      ve(ia,3) = uzf(irf,it,ip)/utf(irf,it,ip)
      Aphi = vayd(irg,it,ip)*vec_phig(irg,it,ip,2)
      call calc_integrability_fnc_MHD(Aphi)
      MHDfnc_Lambda_val(ia) = MHDfnc_Lambda_GS
!
      do ii = 1, 3 ! ii = x,y,z
        ovufc(ia,ii) = be(ia,ii) + ve(ia,ii)
      end do
      gmovov(ia) = 0.0d0
      gmdovov(ia) = 0.0d0
      do jj = 1, 3
        do ii = 1, 3
          gmovov(ia) = gmovov(ia) + gm(ia,ii,jj)*ovufc(ia,ii)*ovufc(ia,jj)
          dovufcii = 0.0d0
          dovufcjj = 0.0d0
          if (ii.eq.2) dovufcii = vphi(ia,ii)          
          if (jj.eq.2) then 
            dovufcjj = vphi(ia,jj)          
          end if
          gmdovov(ia) = gmdovov(ia) &
          &           + gm(ia,ii,jj)*dovufcii*ovufc(ia,jj) &
          &           + gm(ia,ii,jj)*ovufc(ia,ii)*dovufcjj
        end do
      end do
!
      term2(ia) = 1.0d0 - psi2al(ia)**(2.d0*radi**2)*gmovov(ia)
!
      dterm2do(ia) = - psi2al(ia)**(2.d0*radi**2)*2.0d0*gmdovov(ia)
      dterm2dr(ia) = - 4.0d0*radi*dlog(psi2al(ia)) &
      &              * psi2al(ia)**(2.d0*radi**2)*gmovov(ia)
!
      sgg(ia) = -(log_h(ia) + radi**2*log_a(ia) + 0.5d0*dlog(term2(ia)) &
      &           + MHDfnc_Lambda_val(ia) - dlog(ber) ) 
!
      gg(ia,1) =   0.5d0*dterm2do(ia)/term2(ia) 
      gg(ia,2) = - 1.0d0/ber
      gg(ia,3) = 2.0d0*radi*log_a(ia) + 0.5d0*dterm2dr(ia)/term2(ia)
!
    end do
!    test
!if (numero.eq.1) then
!!ia  = 1
!ia  = 2
!!ia  = 3
! write(6,*)log_h(ia), radi, log_a(ia) , term1(ia) , &
!     &           -MHDfnc_Lambda_val(ia),term2(ia)
! write (6,'(1p,3e12.4)') sgg(1), sgg(2), sgg(3)
! write (6,'(1p,3e12.4)') gg(1,1), gg(1,2), gg(1,3)
! write (6,'(1p,3e12.4)') gg(2,1), gg(2,2), gg(2,3)
! write (6,'(1p,3e12.4)') gg(3,1), gg(3,2), gg(3,3)
!end if
!!!!stop
!!pause
!    test
    call minv(gg,sgg,neq,neq)
    ddome = sgg(1)
    ddber = sgg(2)
    ddradi = sgg(3)
    facfac = dmin1(dble(numero)/5.0d0,1.0d0)
    ome = ome + ddome*facfac
    ber = ber + ddber*facfac
    radi = radi + ddradi*facfac
    error = dmax1(dabs(ddome/ome),dabs(ddber/ber),dabs(ddradi/radi))
    numero = numero + 1
    if (numero>1000) then
      write(6,*)' numero = ', numero, '   error =',error
    end if
!      if (iter<10.and.numero>10) exit
    if (numero>1010) exit
    if (dabs(error)<1.0d-08) exit
  end do
!    test
! write (6,*) "test values"
! write (6,*) sgg(1), sgg(2), sgg(3)
! write (6,*) ome
!    test
!      write(6,*)' numero = ', numero, '  error = ',error
!
  if (radi < 0.d0) write(6,*) ' ### radi minus ###'
  if (radi < 0.d0) radi = - radi
  if (ome < 0.d0) write(6,*) ' ### ome minus ###'
  if (ome < 0.d0) ome = - ome
  if (ber < 0.d0) write(6,*) ' ### ber minus ###'
!  if (ber < 0.d0) ber = - ber
  ome = convf*ome + (1.d0-convf)*omeold
  ber = convf*ber + (1.d0-convf)*berold
  radi = convf*radi + (1.d0-convf)*radiold
!
! write (6,*) 'parameters', ome, ber, radi
! --  Improving alpha and psi.  
!
  alph = alph**((radi/radiold)**2)
  psi = psi**((radi/radiold)**2)
!
! modify on phi=0 plane
  ipf = 0
  do itf = 0, ntf
    do irf = 0, nrf
      uyf(irf,itf,ipf) = utf(irf,itf,ipf)*ome*vec_phif(irf,itf,ipf,2)
    end do
  end do
! Copy to phi /= 0 planes.
  do ipf = 1, npf
    do itf = 0, ntf
      do irf = 0, nrf
        uxf(irf,itf,ipf) = cosphig(ipf)*uxf(irf,itf,0) &
        &                - sinphig(ipf)*uyf(irf,itf,0)
        uyf(irf,itf,ipf) = sinphig(ipf)*uxf(irf,itf,0) &
        &                + cosphig(ipf)*uyf(irf,itf,0)
      end do
    end do
  end do
!
end subroutine update_parameter_WL_MHD_GS
