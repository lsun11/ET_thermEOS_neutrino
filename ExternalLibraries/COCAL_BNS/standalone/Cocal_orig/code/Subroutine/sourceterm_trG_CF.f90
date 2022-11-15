subroutine sourceterm_trG_CF(sou)
  use phys_constant, only : long
  use grid_parameter, only : nrg, ntg, npg
  use def_metric, only : psi, alph, tfkijkij
  use interface_interpo_linear_type0
  implicit none
  real(long), pointer :: sou(:,:,:) 
  real(long) :: psigc, alpgc, aijaij
  integer    :: irg, itg, ipg
!
! --- Source term of the spatial trace of Einstein eq 
! --- for computing alpha*psi.
!
  do ipg = 1, npg
    do itg = 1, ntg
      do irg = 1, nrg
        call interpo_linear_type0(psigc,psi,irg,itg,ipg)
        call interpo_linear_type0(alpgc,alph,irg,itg,ipg)
        aijaij = tfkijkij(irg,itg,ipg)
!
        sou(irg,itg,ipg) = + 0.875d0*alpgc*psigc**5*aijaij
      end do
    end do
  end do
end subroutine sourceterm_trG_CF
