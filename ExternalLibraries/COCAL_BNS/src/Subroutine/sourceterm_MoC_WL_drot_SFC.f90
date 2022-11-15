subroutine sourceterm_MoC_WL_drot_SFC(souvec)
  use phys_constant, only : long, pi
  use grid_parameter, only : nrf, ntf, npf
  use def_metric_on_SFC_CF, only : psif, alphf
  use def_metric_on_SFC_WL, only : hxxdf, hxydf, hxzdf, hyydf, hyzdf, hzzdf
  use def_matter, only : emd, omef, jomef_int
  use def_matter_parameter, only : ber, radi
  use def_vector_phi, only: vec_phif
  implicit none
!
  real(long), pointer :: souvec(:,:,:,:)
  real(long) :: vphif(3)
  real(long) :: emdfc, rhofc, prefc, hhfc, ene, utfc, oterm, rjj
  real(long) :: psifc, alpfc
  real(long) :: hxxdfc, hxydfc, hxzdfc, hyxdfc, hyydfc, hyzdfc, &
  &             hzxdfc, hzydfc, hzzdfc
  real(long) :: omefc, jomef_intfc
  integer :: irf, itf, ipf, ii
!
  do ii = 1, 3
    do ipf = 0, npf
      do itf = 0, ntf
        do irf = 0, nrf
!
          hxxdfc = hxxdf(irf,itf,ipf)
          hxydfc = hxydf(irf,itf,ipf)
          hxzdfc = hxzdf(irf,itf,ipf)
          hyydfc = hyydf(irf,itf,ipf)
          hyzdfc = hyzdf(irf,itf,ipf)
          hzzdfc = hzzdf(irf,itf,ipf)
          hyxdfc = hxydfc
          hzxdfc = hxzdfc
          hzydfc = hyzdfc
          psifc  =  psif(irf,itf,ipf)
          alpfc  = alphf(irf,itf,ipf)
          emdfc  =   emd(irf,itf,ipf)
          omefc  =  omef(irf,itf,ipf)
          jomef_intfc = jomef_int(irf,itf,ipf)
!
          if (irf.eq.nrf) then
            emdfc = 0.0d0
          end if
          call peos_q2hprho(emdfc, hhfc, prefc, rhofc, ene)
          utfc  = hhfc/ber*exp(jomef_intfc)
          vphif(1) = vec_phif(irf,itf,ipf,1)
          vphif(2) = vec_phif(irf,itf,ipf,2)
          vphif(3) = vec_phif(irf,itf,ipf,3)
          oterm = 0.0d0
! --- only for the waveless contributions
          if (ii == 1) oterm = hxxdfc*omefc*vphif(1) &
                           & + hxydfc*omefc*vphif(2) &
                           & + hxzdfc*omefc*vphif(3)
          if (ii == 2) oterm = hyxdfc*omefc*vphif(1) &
                           & + hyydfc*omefc*vphif(2) &
                           & + hyzdfc*omefc*vphif(3)
          if (ii == 3) oterm = hzxdfc*omefc*vphif(1) &
                           & + hzydfc*omefc*vphif(2) &
                           & + hzzdfc*omefc*vphif(3)
          rjj = hhfc*rhofc*alpfc*utfc**2*psifc**4*oterm
!
          souvec(irf,itf,ipf,ii) = radi**2*16.0d0*pi*alpfc*rjj
!
        end do
      end do
    end do
  end do
!
end subroutine sourceterm_MoC_WL_drot_SFC
