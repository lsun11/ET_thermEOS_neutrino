subroutine sourceterm_MWtemp_current(sou)
  use phys_constant, only : long, pi
  use grid_parameter, only : nrg, ntg, npg
  use def_metric, only : psi, alph
  use def_matter, only : emdg
  use def_matter_parameter, only : radi
  use def_emfield, only : jtu
  use interface_interpo_linear_type0
  implicit none
  real(long), pointer :: sou(:,:,:)
  real(long) :: emdgc, rhoSc, zfac
  real(long) :: psigc, alphgc, jtugc
  integer    :: irg, itg, ipg
!
! --- Source for Maxwell eq normal component
! --  current term
!
  do ipg = 1, npg
    do itg = 1, ntg
      do irg = 1, nrg
        call interpo_linear_type0(emdgc,emdg,irg,itg,ipg)
        call interpo_linear_type0(jtugc,jtu,irg,itg,ipg)
        call interpo_linear_type0(psigc,psi,irg,itg,ipg)
        call interpo_linear_type0(alphgc,alph,irg,itg,ipg)
        zfac = 1.0d0
        if (emdgc <= 1.0d-15) then 
          emdgc = 1.0d-15
          zfac  = 0.0d0
        end if
        rhoSc = alphgc*jtugc
        sou(irg,itg,ipg) = - radi**2*4.0d0*pi*alphgc*psigc**4*rhoSc*zfac
      end do
    end do
  end do
end subroutine sourceterm_MWtemp_current

