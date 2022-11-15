subroutine source_charge_MHD(sou)
  use phys_constant, only : long, pi
  use grid_parameter, only : nrf, ntf, npf
  use def_metric_on_SFC_CF, only : psif, alphf
  use def_matter_parameter, only : radi
  use def_emfield, only : jtuf
  implicit none
  real(long), pointer :: sou(:,:,:)
  real(long) :: rhoSc
  real(long) :: psifc, alphfc, jtufc
  integer    :: irf, itf, ipf
!
! --- Source for Maxwell eq normal component
! --  current term
!
  do ipf = 0, npf
    do itf = 0, ntf
      do irf = 0, nrf
        jtufc  =  jtuf(irf,itf,ipf)
        psifc  =  psif(irf,itf,ipf)
        alphfc = alphf(irf,itf,ipf)
        rhoSc = alphfc*jtufc
        sou(irf,itf,ipf) = rhoSc*psifc**6
      end do
    end do
  end do
end subroutine source_charge_MHD
