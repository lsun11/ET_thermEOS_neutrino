subroutine sourceterm_HaC_WL_EMF(sou)
  use phys_constant, only : long, pi
  use grid_parameter, only : nrg, ntg, npg
  use def_metric, only : psi
  use def_SEM_tensor_EMF, only : rhoH_EMF
  use interface_interpo_linear_type0
  implicit none
  real(long), pointer :: sou(:,:,:)
  real(long) :: psigc, rhoHc
  integer    :: irg, itg, ipg
!
! --- Source of the Hamiltonian constraint to compute 
!     the conformal factor psi.
!
  do ipg = 1, npg
    do itg = 1, ntg
      do irg = 1, nrg
        call interpo_linear_type0(psigc,psi,irg,itg,ipg)
        rhoHc = rhoH_EMF(irg,itg,ipg)
        sou(irg,itg,ipg) = - 2.0d0*pi*psigc**5*rhoHc
      end do
    end do
  end do
!
end subroutine sourceterm_HaC_WL_EMF
