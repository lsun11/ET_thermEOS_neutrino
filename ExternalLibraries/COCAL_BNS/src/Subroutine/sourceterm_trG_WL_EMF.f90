subroutine sourceterm_trG_WL_EMF(sou)
  use phys_constant, only : long, pi
  use grid_parameter, only : nrg, ntg, npg
  use def_metric, only : psi, alph
  use def_SEM_tensor_EMF, only : rhoH_EMF, trsm_EMF
  use interface_interpo_linear_type0
  implicit none
  real(long), pointer :: sou(:,:,:)
  real(long) :: rp2s, psigc, alphgc
  integer    :: irg, itg, ipg
!
! --- Source of the Hamiltonian constraint to compute 
!     the conformal factor psi.
!
  do ipg = 1, npg
    do itg = 1, ntg
      do irg = 1, nrg
        call interpo_linear_type0(psigc,psi,irg,itg,ipg)
        call interpo_linear_type0(alphgc,alph,irg,itg,ipg)
        rp2s = rhoH_EMF(irg,itg,ipg) + 2.0d0*trsm_EMF(irg,itg,ipg)
        sou(irg,itg,ipg) = + 2.0d0*pi*alphgc*psigc**5*rp2s
      end do
    end do
  end do
!
end subroutine sourceterm_trG_WL_EMF
