subroutine sourceterm_MWspatial_current_WL(souvec)
  use phys_constant, only : long, pi
  use grid_parameter, only : nrf, ntf, npf
  use def_metric_on_SFC_CF, only : psif, alphf
  use def_metric_on_SFC_WL, only : hxxdf, hxydf, hxzdf, hyydf, hyzdf, hzzdf
  use def_matter, only : emd
  use def_emfield, only : jtuf, jxuf, jyuf, jzuf
  use def_matter_parameter, only : radi
  use make_array_3d
  implicit none
  real(long), pointer :: souvec(:,:,:,:)
  real(long) :: hijd(3,3)
  real(long) :: emdfc, jterm, jxufc, jyufc, jzufc
  real(long) :: psifc, alpfc
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
          hijd(1,1) = hxxdf(irf,itf,ipf)
          hijd(1,2) = hxydf(irf,itf,ipf)
          hijd(1,3) = hxzdf(irf,itf,ipf)
          hijd(2,2) = hyydf(irf,itf,ipf)
          hijd(2,3) = hyzdf(irf,itf,ipf)
          hijd(3,3) = hzzdf(irf,itf,ipf)
          hijd(2,1) = hijd(1,2)
          hijd(3,1) = hijd(1,3)
          hijd(3,2) = hijd(2,3)
          jxufc = jxuf(irf,itf,ipf)
          jyufc = jyuf(irf,itf,ipf)
          jzufc = jzuf(irf,itf,ipf)
          jterm = hijd(ii,1)*jxufc + hijd(ii,2)*jyufc + hijd(ii,3)*jzufc
!
          souvec(irf,itf,ipf,ii) = - radi**2*4.0d0*pi*psifc**8*jterm
!
        end do
      end do
    end do
  end do     
!
end subroutine sourceterm_MWspatial_current_WL
