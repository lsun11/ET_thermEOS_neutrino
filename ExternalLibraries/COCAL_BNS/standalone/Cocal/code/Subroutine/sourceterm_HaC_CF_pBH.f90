subroutine sourceterm_HaC_CF_pBH(sou)
  use phys_constant, only : long
  use grid_parameter, only : nrg, ntg, npg
  use def_metric_pBH, only : wme, aijaij_trpBH, index_wme
  use interface_interpo_linear_type0
  use interface_grgrad_midpoint_r3rd_type0
  implicit none
  real(long), pointer :: sou(:,:,:)
  real(long) :: wmegc, dwdx, dwdy, dwdz, aijaijgc, fac1, fac2, index
  integer    :: irg, itg, ipg
!
! --- Source of the Hamiltonian constraint to compute 
!     the inverse conformal factor omega.
!
!p  fac1  = 1.0d0 + 1.0d0/dble(index_wme)
!p  fac2  = dble(index_wme)/8.0d0
!p  index = 1.0d0 + 8.0d0/dble(index_wme)
  fac1  = 1.0d0/dble(index_wme)
  fac2  = dble(index_wme)/8.0d0
  index = 8.0d0/dble(index_wme)
  do ipg = 1, npg
    do itg = 1, ntg
      do irg = 1, nrg
        call interpo_linear_type0(wmegc,wme,irg,itg,ipg)
        call grgrad_midpoint_r3rd_type0(wme,dwdx,dwdy,dwdz,irg,itg,ipg,'bh')
        aijaijgc = aijaij_trpBH(irg,itg,ipg)
!
!p        sou(irg,itg,ipg) = fac1*(dwdx**2.0d0+dwdy**2.0d0+dwdz**2.0d0)/wmegc &
!p        &                + fac2*wmegc**index*aijaijgc
        sou(irg,itg,ipg)= fac1*(dwdx**2.0d0+dwdy**2.0d0+dwdz**2.0d0)/wmegc**2 &
        &               + fac2*wmegc**index*aijaijgc
      end do
    end do
  end do
!
end subroutine sourceterm_HaC_CF_pBH
