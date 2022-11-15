subroutine sourceterm_trG_drot_SFC_qeos(sou)
  use phys_constant, only : long, pi
  use grid_parameter, only : nrf, ntf, npf
  use def_metric_on_SFC_CF, only : psif, alphf
  use def_matter, only : rhof, jomef_int
  use def_matter_parameter, only : ber, radi, rhos_qs
  use interface_interpo_linear_type0
  implicit none
  real(long), pointer :: sou(:,:,:) 
  real(long) :: emdfc, rhofc, prefc, hhfc, rp2s, utfc
  real(long) :: psifc, alpfc, ene, jomef_intfc, dummy
  integer    :: irf, itf, ipf
!
! --- Source term of the spatial trace of Einstein eq 
! --- for computing alpha*psi.
!
  do ipf = 0, npf
    do itf = 0, ntf
      do irf = 0, nrf
        psifc =  psif(irf,itf,ipf)
        alpfc = alphf(irf,itf,ipf)
        rhofc =  rhof(irf,itf,ipf)
        jomef_intfc = jomef_int(irf,itf,ipf)
        if (irf.eq.nrf) then
          rhofc = rhos_qs
        end if
        call quark_rho2phenedpdrho(rhofc, prefc, hhfc, ene, dummy)
        utfc  = hhfc/ber*exp(jomef_intfc)
        rp2s = 3.0d0*hhfc*rhofc*(alpfc*utfc)**2   &
      &      - 2.0d0*hhfc*rhofc + 5.0d0*prefc
!
        sou(irf,itf,ipf) = radi**2*2.0d0*pi*alpfc*psifc**5*rp2s
      end do
    end do
  end do
end subroutine sourceterm_trG_drot_SFC_qeos
