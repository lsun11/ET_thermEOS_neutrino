subroutine sourceterm_HaC_WL_SEM(sou)
  use phys_constant, only : long, pi
  use grid_parameter, only : nrf, ntf, npf
  use def_metric_on_SFC_CF, only : psif
  use def_SEM_tensor, only : rhoH
  use def_matter_parameter, only : radi
  implicit none
  real(long), pointer :: sou(:,:,:)
  real(long) :: psifc, rhoHc
  integer    :: irf, itf, ipf
!
! --- Source of the Hamiltonian constraint 
  do ipf = 0, npf
    do itf = 0, ntf
      do irf = 0, nrf
        psifc = psif(irf,itf,ipf)
        rhoHc = rhoH(irf,itf,ipf)
        sou(irf,itf,ipf) = - radi**2*2.0d0*pi*psifc**5*rhoHc
      end do
    end do
  end do
end subroutine sourceterm_HaC_WL_SEM
