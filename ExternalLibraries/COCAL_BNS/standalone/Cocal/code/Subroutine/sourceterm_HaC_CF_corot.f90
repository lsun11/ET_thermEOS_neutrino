subroutine sourceterm_HaC_CF_corot(sou)
  use phys_constant, only : long, pi
  use grid_parameter, only : nrg, ntg, npg
  use def_metric, only : psi, alph
  use def_matter, only : emdg
  use def_matter_parameter, only : ber, radi
  use interface_interpo_linear_type0
  implicit none
  real(long), pointer :: sou(:,:,:)
  real(long) :: emdgc, rhogc, pregc, hhgc, utgc, rhoHc, zfac
  real(long) :: psigc, alpgc, ene
  integer    :: irg, itg, ipg
!
! --- Source of the Hamiltonian constraint to compute 
!     the conformal factor psi.
!
  do ipg = 1, npg
    do itg = 1, ntg
      do irg = 1, nrg
        call interpo_linear_type0(emdgc,emdg,irg,itg,ipg)
        call interpo_linear_type0(psigc,psi,irg,itg,ipg)
        call interpo_linear_type0(alpgc,alph,irg,itg,ipg)
        zfac = 1.0d0
        if (emdgc <= 1.0d-15) then 
          emdgc = 1.0d-15
          zfac  = 0.0d0
        end if
        call peos_q2hprho(emdgc, hhgc, pregc, rhogc, ene)
        utgc  = hhgc/ber
        rhoHc = hhgc*rhogc*(alpgc*utgc)**2 - pregc
!
        sou(irg,itg,ipg) = - radi**2*2.0d0*pi*psigc**5*rhoHc*zfac
      end do
    end do
  end do
end subroutine sourceterm_HaC_CF_corot

