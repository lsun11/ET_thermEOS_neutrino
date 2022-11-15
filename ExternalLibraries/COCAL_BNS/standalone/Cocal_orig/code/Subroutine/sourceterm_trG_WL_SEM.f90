subroutine sourceterm_trG_WL_SEM(sou)
  use phys_constant, only : long, pi
  use grid_parameter, only : nrf, ntf, npf
  use def_metric_on_SFC_CF, only : psif, alphf
  use def_matter_parameter, only : radi
  use def_SEM_tensor, only : rhoH, trsm
  implicit none
  real(long), pointer :: sou(:,:,:) 
  real(long) :: rp2s, psifc, alpfc
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
        rp2s = rhoH(irf,itf,ipf) + 2.0d0*trsm(irf,itf,ipf)
        sou(irf,itf,ipf) = + radi**2*2.0d0*pi*alpfc*psifc**5*rp2s
      end do
    end do
  end do
end subroutine sourceterm_trG_WL_SEM
