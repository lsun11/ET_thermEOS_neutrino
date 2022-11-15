subroutine sourceterm_MoC_WL_SEM(souvec)
  use phys_constant, only : long, pi
  use grid_parameter, only : nrf, ntf, npf
  use def_metric_on_SFC_CF, only : alphf
  use def_matter_parameter, only : radi
  use def_SEM_tensor, only : jmd
  implicit none
  real(long), pointer :: souvec(:,:,:,:)
  real(long) :: rjj, alpfc
  integer :: ii, irf, itf, ipf
!
! --- Source terms of Momentum constraint for computing shift.  
!
  do ii = 1, 3
    do ipf = 0, npf
      do itf = 0, ntf
        do irf = 0, nrf
          alpfc = alphf(irf,itf,ipf)
          rjj   = jmd(irf,itf,ipf,ii)
          souvec(irf,itf,ipf,ii) = radi**2*16.0d0*pi*alpfc*rjj
        end do
      end do
    end do
  end do     
!
end subroutine sourceterm_MoC_WL_SEM
