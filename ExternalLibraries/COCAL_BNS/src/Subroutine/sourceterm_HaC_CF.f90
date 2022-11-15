subroutine sourceterm_HaC_CF(sou)
  use phys_constant, only : long
  use grid_parameter, only : nrg, ntg, npg, ntgeq, npgxzp
  use coordinate_grav_r, only : hrg
  use def_metric, only : psi, tfkijkij
  use interface_interpo_linear_type0
  implicit none
  real(long), pointer :: sou(:,:,:)
  real(long) :: psigc, aijaij
  integer    :: irg, itg, ipg
!
! --- Source of the Hamiltonian constraint to compute 
!     the conformal factor psi.
!
  do ipg = 1, npg
    do itg = 1, ntg
      do irg = 1, nrg
        call interpo_linear_type0(psigc,psi,irg,itg,ipg)
        aijaij = tfkijkij(irg,itg,ipg)
!
        sou(irg,itg,ipg) = - 0.125d0*psigc**5*aijaij
      end do
    end do
  end do
!
end subroutine sourceterm_HaC_CF
