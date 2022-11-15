subroutine current_MHD_on_SFC
  use phys_constant, only  : long
  use grid_parameter
  use coordinate_grav_r, only : rg
  use trigonometry_grav_phi, only   : sinphig, cosphig
  use def_matter, only : emd, hhf, utf, uxdf, uydf, uzdf
  use def_matter_parameter, only : ome, ber
  use def_metric_on_SFC_CF, only : alphf, psif
  use def_emfield, only : vaxd, vayd, vazd, jtuf, jxuf, jyuf, jzuf
  use def_vector_phi, only : vec_phif
  use integrability_fnc_MHD
  use make_array_3d
  use interface_interpo_gr2fl
  use interface_flgrad_4th_gridpoint
  implicit none
  real(long), pointer :: vaphidf(:,:,:)
  real(long), pointer :: vaxdf(:,:,:), vaydf(:,:,:), vazdf(:,:,:)
  real(long), pointer :: huxdf(:,:,:), huzdf(:,:,:), huphidf(:,:,:)
  real(long) :: vecphif(3)
  real(long) :: Aphi, dxAphi, dyAphi, dzAphi
  real(long) :: Bphi, dxAx, dyAx, dzAx, dxAz, dyAz, dzAz
  real(long) :: vorphi, dxhux, dyhux, dzhux, dxhuz, dyhuz, dzhuz
  real(long) :: huphi, dxhuphi, dyhuphi, dzhuphi
  real(long) :: hh, ut, ux, uy, uz, vx, vy, vz, pre, rho, ene, qq
  real(long) :: alphff, psiff, alps6f, jphiuf, jt
  integer    :: irf, itf, ipf
!
  call alloc_array3d(vaxdf, 0, nrf, 0, ntf, 0, npf)
  call alloc_array3d(vaydf, 0, nrf, 0, ntf, 0, npf)
  call alloc_array3d(vazdf, 0, nrf, 0, ntf, 0, npf)
  call alloc_array3d(vaphidf, 0, nrf, 0, ntf, 0, npf)
  call alloc_array3d(huxdf, 0, nrf, 0, ntf, 0, npf)
  call alloc_array3d(huzdf, 0, nrf, 0, ntf, 0, npf)
  call alloc_array3d(huphidf, 0, nrf, 0, ntf, 0, npf)
!
  call interpo_gr2fl(vaxd, vaxdf)
  call interpo_gr2fl(vayd, vaydf)
  call interpo_gr2fl(vazd, vazdf)
  vaphidf(0:nrf,0:ntf,0:npf)=vaydf(0:nrf,0:ntf,0:npf) &
  &                      *vec_phif(0:nrf,0:ntf,0:npf,2)
  huxdf(0:nrf,0:ntf,0:npf) = hhf(0:nrf,0:ntf,0:npf)*uxdf(0:nrf,0:ntf,0:npf)
  huzdf(0:nrf,0:ntf,0:npf) = hhf(0:nrf,0:ntf,0:npf)*uzdf(0:nrf,0:ntf,0:npf)
  huphidf(0:nrf,0:ntf,0:npf)=hhf(0:nrf,0:ntf,0:npf)*uydf(0:nrf,0:ntf,0:npf) &
  &                    *vec_phif(0:nrf,0:ntf,0:npf,2)
!
! Solve on phi=0 plane
  ipf = 0
  do itf = 0, ntf
    do irf = 0, nrf
!
      psiff  = psif(irf,itf,ipf)
      alphff = alphf(irf,itf,ipf)
      alps6f = alphff*psiff**6
      Aphi = vaphidf(irf,itf,ipf)
      huphi = huphidf(irf,itf,ipf)
      ut =  utf(irf,itf,ipf)
      jt = jtuf(irf,itf,ipf)
      vecphif(1)= vec_phif(irf,itf,ipf,1)
      vecphif(2)= vec_phif(irf,itf,ipf,2)
      vecphif(3)= vec_phif(irf,itf,ipf,3)
      call calc_integrability_fnc_MHD(Aphi)
      call flgrad_4th_gridpoint(vaphidf,dxAphi,dyAphi,dzAphi,irf,itf,ipf)
      call flgrad_4th_gridpoint(huphidf,dxhuphi,dyhuphi,dzhuphi,irf,itf,ipf)
      call flgrad_4th_gridpoint(vaxdf,dxAx,dyAx,dzAx,irf,itf,ipf)
      call flgrad_4th_gridpoint(vazdf,dxAz,dyAz,dzAz,irf,itf,ipf)
      Bphi = -(dxAz - dzAx)
      call flgrad_4th_gridpoint(huxdf,dxhux,dyhux,dzhux,irf,itf,ipf)
      call flgrad_4th_gridpoint(huzdf,dxhuz,dyhuz,dzhuz,irf,itf,ipf)
      vorphi = dxhuz - dzhux
      qq = emd(irf,itf,ipf)
      call peos_q2hprho(qq, hh, pre, rho, ene)
!
! meridional current
!
      jxuf(irf,itf,ipf) = 1.0d0/alps6f &
      &  *((MHDfnc_d2Psi*huphi + MHDfnc_dLambda_phi)*(-dzAphi) &
      &   - MHDfnc_dPSI*(+dzhuphi))
      jzuf(irf,itf,ipf) = 1.0d0/alps6f &
      &  *((MHDfnc_d2Psi*huphi + MHDfnc_dLambda_phi)*(+dxAphi) &
      &   - MHDfnc_dPSI*(-dxhuphi))
!
! toroidal current
!
!WIND      jphiuf = 1.0d0/alps6f &
!WIND      &  *((MHDfnc_d2Psi*huphi + MHDfnc_dLambda_phi)*Bphi &
!WIND      &   - MHDfnc_dPSI*vorphi) &
!WIND      &   -(MHDfnc_d2At*huphi + MHDfnc_dLambda)*rho*ut &
!WIND      &   - MHDfnc_dAt*jt
      jphiuf = (1.0d0/alps6f)*MHDfnc_dLambda_phi*Bphi &
      &      - rho*hh*MHDfnc_dLambda_GS &
      &      - MHDfnc_dAt*jt
      jyuf(irf,itf,ipf) = jphiuf*vecphif(2)
!
    end do
  end do
!
! Clear surface current
!!  jtuf(nrf,0:ntf,0:npf) = 0.0d0
!!  jyuf(nrf,0:ntf,0:npf) = 0.0d0
! Copy to phi /= 0 planes.
  do ipf = 1, npf
    do itf = 0, ntf
      do irf = 0, nrf
        jtuf(irf,itf,ipf) = jtuf(irf,itf,0)
        jxuf(irf,itf,ipf) = cosphig(ipf)*jxuf(irf,itf,0) &
        &                 - sinphig(ipf)*jyuf(irf,itf,0)
        jyuf(irf,itf,ipf) = sinphig(ipf)*jxuf(irf,itf,0) &
        &                 + cosphig(ipf)*jyuf(irf,itf,0)
        jzuf(irf,itf,ipf) = jzuf(irf,itf,0)
      end do
    end do
  end do
!
      itf = ntgeq; ipf = 0
      open(15,file='test_vec_cur',status='unknown')
        do irf = 0, nrf
          write(15,'(1p,9e20.12)')  rg(irf), jtuf(irf,itf,ipf) &
              &                            , jyuf(irf,itf,ipf) &
              &                            , jzuf(irf,itf,ipf)
        end do
      close(15)
!
  deallocate(vaxdf)
  deallocate(vaydf)
  deallocate(vazdf)
  deallocate(vaphidf)
  deallocate(huxdf)
  deallocate(huzdf)
  deallocate(huphidf)
!
end subroutine current_MHD_on_SFC
