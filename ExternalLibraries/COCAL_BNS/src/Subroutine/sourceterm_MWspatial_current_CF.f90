subroutine sourceterm_MWspatial_current_CF(souvec)
  use phys_constant, only : long, pi
  use grid_parameter, only : nrf, ntf, npf
  use def_metric_on_SFC_CF, only : psif, alphf, bvxdf, bvydf, bvzdf
  use def_matter, only : emd
  use def_emfield, only : jtuf, jxuf, jyuf, jzuf
  use def_matter_parameter, only : radi
  use make_array_3d
  implicit none
  real(long), pointer :: souvec(:,:,:,:)
  real(long) :: vphig(3)
  real(long) :: emdfc, jterm, jtufc, jaufc
  real(long) :: psifc, alpfc, bvadfc
  integer :: ii, irf, itf, ipf
!
! --- Source terms of Momentum constraint 
! --- for computing shift.  
!
  do ii = 1, 3
    do ipf = 0, npf
      do itf = 0, ntf
        do irf = 0, nrf
          psifc = psif(irf,itf,ipf)
!
          jtufc = jtuf(irf,itf,ipf)
          if (ii == 1) then 
            bvadfc = bvxdf(irf,itf,ipf)
             jaufc =  jxuf(irf,itf,ipf)
          end if
          if (ii == 2) then 
            bvadfc = bvydf(irf,itf,ipf)
             jaufc =  jyuf(irf,itf,ipf)
          end if
          if (ii == 3) then 
            bvadfc = bvzdf(irf,itf,ipf)
             jaufc =  jzuf(irf,itf,ipf)
          end if
          jterm = jaufc + jtufc*bvadfc
!
          souvec(irf,itf,ipf,ii) = - radi**2*4.0d0*pi*psifc**8*jterm
        end do
      end do
    end do
  end do     
!
end subroutine sourceterm_MWspatial_current_CF
