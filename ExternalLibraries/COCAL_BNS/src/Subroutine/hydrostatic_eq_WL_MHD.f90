subroutine hydrostatic_eq_WL_MHD(emd,utf,uxf,uyf,uzf)
  use phys_constant, only  : long
  use grid_parameter
  use coordinate_grav_r, only : rg
  use trigonometry_grav_phi, only   : sinphig, cosphig
!  use def_matter, only : utdf, uxdf, uydf, uzdf
  use def_matter_parameter, only : ome, ber
  use def_metric_on_SFC_CF
  use def_metric_on_SFC_WL
  use def_emfield, only : vaxd, vayd, vazd
  use def_vector_phi, only : vec_phif 
  use integrability_fnc_MHD
  use make_array_3d
  use interface_interpo_gr2fl
  use interface_flgrad_4th_gridpoint
  implicit none
  real(long), pointer :: emd(:,:,:)
  real(long), pointer :: utf(:,:,:), uxf(:,:,:), uyf(:,:,:), uzf(:,:,:)
  real(long), pointer :: vaxdf(:,:,:), vaydf(:,:,:), vazdf(:,:,:)
  real(long), pointer :: vaphidf(:,:,:)
  real(long) :: vecphif(3)
  real(long) :: ovufc(3), ovdfc(3), bvdfc(3)
  real(long) :: Aphi, dxAphi, dyAphi, dzAphi
  real(long) :: Bphi, dxAx, dyAx, dzAx, dxAz, dyAz, dzAz
  real(long) :: hh, ut, ux, uy, uz, vx, vy, vz, pre, rho, ene, qq
  real(long) :: uphid, vphi, utd, zfac
  real(long) :: gmxxdf, gmxydf, gmxzdf, gmyxdf, gmyydf, gmyzdf, &
  &             gmzxdf, gmzydf, gmzzdf, ovovf,  alphff, psiff
  integer    :: irf, itf, ipf
!
  call alloc_array3d(vaxdf, 0, nrf, 0, ntf, 0, npf)
  call alloc_array3d(vaydf, 0, nrf, 0, ntf, 0, npf)
  call alloc_array3d(vazdf, 0, nrf, 0, ntf, 0, npf)
  call alloc_array3d(vaphidf, 0, nrf, 0, ntf, 0, npf)
!
  call interpo_gr2fl(vaxd, vaxdf)
  call interpo_gr2fl(vayd, vaydf)
  call interpo_gr2fl(vazd, vazdf)
  vaphidf(0:nrf,0:ntf,0:npf) = vaydf(0:nrf,0:ntf,0:npf) &
  &                        *vec_phif(0:nrf,0:ntf,0:npf,2)
!
! Solve on phi=0 plane
  ipf = 0
  do itf = 0, ntf
    do irf = 0, nrf
!
      psiff  = psif(irf,itf,ipf)
      alphff = alphf(irf,itf,ipf)
      gmxxdf = 1.0d0 + hxxdf(irf,itf,ipf)
      gmxydf =         hxydf(irf,itf,ipf)
      gmxzdf =         hxzdf(irf,itf,ipf)
      gmyydf = 1.0d0 + hyydf(irf,itf,ipf)
      gmyzdf =         hyzdf(irf,itf,ipf)
      gmzzdf = 1.0d0 + hzzdf(irf,itf,ipf)
      gmyxdf = gmxydf
      gmzxdf = gmxzdf
      gmzydf = gmyzdf
      Aphi = vaphidf(irf,itf,ipf)
      vecphif(1)= vec_phif(irf,itf,ipf,1)
      vecphif(2)= vec_phif(irf,itf,ipf,2)
      vecphif(3)= vec_phif(irf,itf,ipf,3)
      call calc_integrability_fnc_MHD(Aphi)
      call flgrad_4th_gridpoint(vaphidf,dxAphi,dyAphi,dzAphi,irf,itf,ipf)
      call flgrad_4th_gridpoint(vaxdf,dxAx,dyAx,dzAx,irf,itf,ipf)
      call flgrad_4th_gridpoint(vazdf,dxAz,dyAz,dzAz,irf,itf,ipf)
      qq = emd(irf,itf,ipf)
      zfac = 1.0d0
      if (qq <= 1.0d-14) zfac = 0.0
      call peos_q2hprho(qq, hh, pre, rho, ene)
      Bphi = -(dxAz - dzAx)
!
! meridional flow
      uxf(irf,itf,ipf) = 1.0d0/(rho*alphff*psiff**6)*MHDfnc_dPSI*(-dzAphi)
      uzf(irf,itf,ipf) = 1.0d0/(rho*alphff*psiff**6)*MHDfnc_dPSI*(+dxAphi)
      uxf(irf,itf,ipf) = uxf(irf,itf,ipf)*zfac
      uzf(irf,itf,ipf) = uzf(irf,itf,ipf)*zfac
!
      ut = utf(irf,itf,ipf)
      ux = uxf(irf,itf,ipf)
      uy = uyf(irf,itf,ipf)
      uz = uzf(irf,itf,ipf)
      vx = ux/ut
      vy = uy/ut
      vz = uz/ut
      ovufc(1) = bvxuf(irf,itf,ipf) + vx
      ovufc(2) = bvyuf(irf,itf,ipf) + vy
      ovufc(3) = bvzuf(irf,itf,ipf) + vz
      ovdfc(1) = bvxdf(irf,itf,ipf) + gmxxdf*vx + gmxydf*vy + gmxzdf*vz
      ovdfc(2) = bvydf(irf,itf,ipf) + gmyxdf*vx + gmyydf*vy + gmyzdf*vz
      ovdfc(3) = bvzdf(irf,itf,ipf) + gmzxdf*vx + gmzydf*vy + gmzzdf*vz
      ovovf = ovdfc(1)*ovufc(1) + ovdfc(2)*ovufc(2) + ovdfc(3)*ovufc(3)
!
!write(6,*) ut
!write(6,*) ux, uy, uz
!write(6,*) rho, MHDfnc_dPSI
!write(6,*) dxAphi, dzAphi
!!write(6,*) alphff, psiff, ovovf
!!write(6,*) ut, psiff, ovdfc(2),vecphif(2)
!!write(6,*) Aphi, MHDfnc_Lambda, MHDfnc_dAt*uphid, hh
!stop
!
! ut 
      utf(irf,itf,ipf) = 1.0d0/sqrt(alphff**2 - psiff**4*ovovf)
!
!if (irf.eq.nrf.and.itf.eq.ntf/2) then
!write(6,'(a3,2x,1p,3e15.7)') 'cmp', alphff,psiff, ovovf
!write(6,'(a3,2x,1p,3e15.7)') 'cmp', ovufc(1), ovufc(2), ovufc(3)
!write(6,'(a3,2x,1p,3e15.7)') 'cmp', ovdfc(1), ovdfc(2), ovdfc(3)
!write(6,'(a3,2x,1p,3e15.7)') 'cmp', vx, vy, vz
!write(6,'(a3,2x,1p,3e15.7)') 'cmp', bvxuf(irf,itf,ipf), &
!                bvyuf(irf,itf,ipf), bvzuf(irf,itf,ipf)
!end if
!!!
      ut = utf(irf,itf,ipf)
      ux = uxf(irf,itf,ipf)
      uy = uyf(irf,itf,ipf)
      uz = uzf(irf,itf,ipf)
      vx = ux/ut
      vy = uy/ut
      vz = uz/ut
      bvdfc(1) = bvxdf(irf,itf,ipf)
      bvdfc(2) = bvydf(irf,itf,ipf)
      bvdfc(3) = bvzdf(irf,itf,ipf)
!
! toroidal flow
      vphi = MHDfnc_dPSI*Bphi/(rho*ut*alphff*psiff**6) - MHDfnc_dAt
      uyf(irf,itf,ipf) = ut*vphi*vecphif(2)
!
! WIND! enthalpy to emden fnc
! WIND      utd = ut*(-alphff**2 + psiff**4*(bvdfc(1)*ovufc(1) &
! WIND      &          + bvdfc(2)*ovufc(2) + bvdfc(3)*ovufc(3)))
! WIND      uphid = ut*psiff**4*ovdfc(2)*vecphif(2)
! WIND      hh = MHDfnc_Lambda/(utd - MHDfnc_dAt*uphid)
!
! For GS no meridional circulation
      hh = ber*ut*dexp(-MHDfnc_Lambda_GS)
!
      call peos_h2qprho(hh, qq, pre, rho, ene)
      emd(irf,itf,ipf) = qq
!
!if (itf.eq.ntfeq-1.or.itf.eq.ntfeq) then 
!if (irf.ge.nrf-1) then 
!write(6,*)ut,alphff, + psiff,bvdfc(1)*ovufc(1), &
!      &          + bvdfc(2)*ovufc(2), + bvdfc(3)*ovufc(3),&
!      & ovdfc(2),vecphif(2), qq
!end if
!end if
!
    end do
  end do
!
!write(6,'(a3,2x,1p,3e15.7)') 'uxf', uxf(nrf*3/4,ntf/2,0)
!write(6,'(a3,2x,1p,3e15.7)') 'uzf', uzf(nrf*3/4,ntf/2,0)
!write(6,'(a3,2x,1p,3e15.7)') 'uxf', uxf(nrf,0,0), uxf(nrf,ntf/2,0), uxf(0,0,0)
!write(6,'(a3,2x,1p,3e15.7)') 'uyf', uyf(nrf,0,0), uyf(nrf,ntf/2,0), uyf(0,0,0)
!write(6,'(a3,2x,1p,3e15.7)') 'uzf', uzf(nrf,0,0), uzf(nrf,ntf/2,0), uzf(0,0,0)
!
! Copy to phi /= 0 planes.
  do ipf = 1, npf
    do itf = 0, ntf
      do irf = 0, nrf
        emd(irf,itf,ipf) = emd(irf,itf,0)
        utf(irf,itf,ipf) = utf(irf,itf,0)
        uxf(irf,itf,ipf) = cosphig(ipf)*uxf(irf,itf,0) &
        &                - sinphig(ipf)*uyf(irf,itf,0)
        uyf(irf,itf,ipf) = sinphig(ipf)*uxf(irf,itf,0) &
        &                + cosphig(ipf)*uyf(irf,itf,0)
        uzf(irf,itf,ipf) = uzf(irf,itf,0)
      end do
    end do
  end do
!
  deallocate(vaxdf)
  deallocate(vaydf)
  deallocate(vazdf)
  deallocate(vaphidf)
!
end subroutine hydrostatic_eq_WL_MHD
