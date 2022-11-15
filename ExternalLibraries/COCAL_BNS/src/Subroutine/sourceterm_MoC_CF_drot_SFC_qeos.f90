subroutine sourceterm_MoC_CF_drot_SFC_qeos(souvec)
  use phys_constant, only : long, pi
  use grid_parameter, only : nrf, ntf, npf
  use def_metric_on_SFC_CF, only : psif, alphf, bvxdf, bvydf, bvzdf
  use def_matter, only : rhof, omef, jomef_int
  use def_matter_parameter, only : ber, radi, rhos_qs
  use def_vector_phi, only : vec_phif
  implicit none
  real(long), pointer :: souvec(:,:,:,:)
  real(long) :: vphif(3)
  real(long) :: emdfc, rhofc, prefc, hhfc, ene, utfc, oterm, rjj
  real(long) :: psifc, alpfc
  real(long) :: bvxdfc, bvydfc, bvzdfc
  real(long) :: omefc, jomef_intfc, dummy
  integer :: ii, irf, itf, ipf
!
! --- Source terms of Momentum constraint 
! --- for computing shift.  
!
  do ii = 1, 3
    do ipf = 0, npf
      do itf = 0, ntf
        do irf = 0, nrf
!
          psifc  =  psif(irf,itf,ipf)
          alpfc  = alphf(irf,itf,ipf)
          bvxdfc = bvxdf(irf,itf,ipf)
          bvydfc = bvydf(irf,itf,ipf)
          bvzdfc = bvzdf(irf,itf,ipf)
          rhofc  =  rhof(irf,itf,ipf)
          omefc  =  omef(irf,itf,ipf)
          jomef_intfc = jomef_int(irf,itf,ipf)
          if (irf.eq.nrf) then
            rhofc = rhos_qs
          end if
          call quark_rho2phenedpdrho(rhofc, prefc, hhfc, ene, dummy)
          utfc  = hhfc/ber*exp(jomef_intfc)
          vphif(1) = vec_phif(irf,itf,ipf,1)
          vphif(2) = vec_phif(irf,itf,ipf,2)
          vphif(3) = vec_phif(irf,itf,ipf,3)
          oterm = 0.0d0
          if (ii == 1) oterm = bvxdfc + omefc*vphif(1)
          if (ii == 2) oterm = bvydfc + omefc*vphif(2)
          if (ii == 3) oterm = bvzdfc + omefc*vphif(3)
          rjj = hhfc*rhofc*alpfc*utfc**2*psifc**4*oterm
!
          souvec(irf,itf,ipf,ii) = radi**2*16.0d0*pi*alpfc*rjj
        end do
      end do
    end do
  end do     
!
end subroutine sourceterm_MoC_CF_drot_SFC_qeos
