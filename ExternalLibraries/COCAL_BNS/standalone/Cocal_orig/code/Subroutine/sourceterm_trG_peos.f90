subroutine sourceterm_trG_peos(sou)
  use phys_constant, only : long, pi
  use grid_parameter, only : nrg, ntg, npg
  use def_metric, only : psi, alph, alps, tfkijkij
  use def_matter, only : emdg, jomeg_int
  use def_matter_parameter, only : ber, radi
  use interface_interpo_linear_type0
  implicit none
  real(long), pointer :: sou(:,:,:) 
  real(long) :: emdgc, rhogc, pregc, hhgc, rp2s, utgc, zfac
  real(long) :: psigc, alpgc, aijaij, ene, jomeg_intgc
  integer    :: irg, itg, ipg
!
! --- Source term of the spatial trace of Einstein eq 
! --- for computing alpha*psi.
!
  do ipg = 1, npg
    do itg = 1, ntg
      do irg = 1, nrg
        call interpo_linear_type0(emdgc,emdg,irg,itg,ipg)
        call interpo_linear_type0(jomeg_intgc,jomeg_int,irg,itg,ipg)
        call interpo_linear_type0(psigc,psi,irg,itg,ipg)
        call interpo_linear_type0(alpgc,alph,irg,itg,ipg)
        aijaij = tfkijkij(irg,itg,ipg)
        zfac = 1.0d0
        if (emdgc <= 1.0d-15) then 
          emdgc = 1.0d-15
          zfac  = 0.0d0
        end if
        call peos_q2hprho(emdgc, hhgc, pregc, rhogc, ene)
        utgc  = hhgc/ber*exp(jomeg_intgc)
        rp2s = 3.0d0*hhgc*rhogc*(alpgc*utgc)**2   &
      &      - 2.0d0*hhgc*rhogc + 5.0d0*pregc
!
        sou(irg,itg,ipg) = + 0.875d0*alpgc*psigc**5*aijaij  &
      &                    + radi**2*2.0d0*pi*alpgc*psigc**5*rp2s*zfac
      end do
    end do
  end do
end subroutine sourceterm_trG_peos
