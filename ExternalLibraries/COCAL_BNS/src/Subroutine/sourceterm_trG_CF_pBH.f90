subroutine sourceterm_trG_CF_pBH(sou)
  use phys_constant, only : long
  use grid_parameter, only : nrg, ntg, npg
  use def_metric, only     : alph
  use def_metric_pBH, only : wme, aijaij_trpBH, index_wme
  use interface_interpo_linear_type0
  use interface_grgrad_midpoint_r3rd_type0
  implicit none
  real(long), pointer :: sou(:,:,:)
  real(long) :: alphgc, wmegc, dwdx, dwdy, dwdz, daldx, daldy, daldz
  real(long) :: aijaijgc, fac1, fac2, index
  integer    :: irg, itg, ipg
!
! --- Source of the Hamiltonian constraint to compute 
!     the inverse conformal factor omega.
!
  fac1  = 2.0d0/dble(index_wme)
  fac2  = 1.0d0/dsqrt(2.0d0)
  index = 8.0d0/dble(index_wme)
  do ipg = 1, npg
    do itg = 1, ntg
      do irg = 1, nrg
        call interpo_linear_type0(wmegc,wme,irg,itg,ipg)
        call interpo_linear_type0(alphgc,alph,irg,itg,ipg)
        call grgrad_midpoint_r3rd_type0(wme,dwdx,dwdy,dwdz,irg,itg,ipg,'bh')
        call grgrad_midpoint_r3rd_type0(alph,daldx,daldy,daldz,irg,itg,ipg, &
        &                                                              'bh')
        aijaijgc = aijaij_trpBH(irg,itg,ipg)
!
        sou(irg,itg,ipg) = fac2*( &
        &   - (daldx**2.0d0 + daldy**2.0d0 + daldz**2.0d0)/alphgc**2     &
        &   + fac1*(daldx*dwdx + daldy*dwdy + daldz*dwdz)/(alphgc*wmegc) &
        &   + wmegc**index*aijaijgc )
      end do
    end do
  end do
!
end subroutine sourceterm_trG_CF_pBH
