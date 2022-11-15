subroutine sourceterm_trG_WL_SEM(sou)
  use phys_constant, only : long, pi
  use grid_parameter, only : nrg, ntg, npg
  use def_metric, only : psi, alph
  use def_matter_parameter, only : radi
  use def_SEM_tensor, only : rhoH, trsm
  use interface_interpo_linear_type0
  implicit none
  real(long), pointer :: sou(:,:,:) 
  real(long) :: rp2s, psigc, alpgc
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
        rp2s = rhoH(irg,itg,ipg) + 2.0d0*trsm(irg,itg,ipg)
        sou(irg,itg,ipg) = + radi**2*2.0d0*pi*alpgc*psigc**5*rp2s
      end do
    end do
  end do
end subroutine sourceterm_trG_WL_SEM
