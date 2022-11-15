subroutine sourceterm_MoC_CF_drot(souvec)
  use phys_constant, only : long, pi
  use grid_parameter, only : nrg, ntg, npg
  use coordinate_grav_r, only : hrg
  use trigonometry_grav_theta, only : hsinthg,  hcosthg
  use trigonometry_grav_phi,   only : hsinphig, hcosphig
  use def_metric, only : psi, alph, bvxd, bvyd, bvzd
  use def_matter, only : emdg, omeg, jomeg_int
  use def_matter_parameter, only : ome, ber, radi
  use def_vector_phi, only : hvec_phig
  use make_array_3d
  use interface_grgrad_midpoint
  use interface_interpo_linear_type0
  implicit none
  real(long), pointer :: souvec(:,:,:,:)
  real(long) :: vphig(3)
  real(long) :: emdgc, rhogc, pregc, hhgc, ene, utgc, oterm, zfac, rjj
  real(long) :: psigc, alpgc
  real(long) :: bvxdgc, bvydgc, bvzdgc
  real(long) :: omegc, jomeg_intgc
  integer :: ii, irg, itg, ipg
!
! --- Source terms of Momentum constraint 
! --- for computing shift.  
!
  do ii = 1, 3
    do ipg = 1, npg
      do itg = 1, ntg
        do irg = 1, nrg
          call interpo_linear_type0(emdgc,emdg,irg,itg,ipg)
          call interpo_linear_type0(omegc,omeg,irg,itg,ipg)
          call interpo_linear_type0(jomeg_intgc,jomeg_int,irg,itg,ipg)
          call interpo_linear_type0(psigc,psi,irg,itg,ipg)
          call interpo_linear_type0(alpgc,alph,irg,itg,ipg)
          call interpo_linear_type0(bvxdgc,bvxd,irg,itg,ipg)
          call interpo_linear_type0(bvydgc,bvyd,irg,itg,ipg)
          call interpo_linear_type0(bvzdgc,bvzd,irg,itg,ipg)
!
          zfac = 1.0d0
          if (emdgc <= 1.0d-15) then
            emdgc = 1.0d-15
            zfac  = 0.0d0
          end if
          call peos_q2hprho(emdgc, hhgc, pregc, rhogc, ene)
          utgc  = hhgc/ber*exp(jomeg_intgc)
          vphig(1) = hvec_phig(irg,itg,ipg,1)
          vphig(2) = hvec_phig(irg,itg,ipg,2)
          vphig(3) = hvec_phig(irg,itg,ipg,3)
          oterm = 0.0d0
          if (ii == 1) oterm = bvxdgc + omegc*vphig(1)
          if (ii == 2) oterm = bvydgc + omegc*vphig(2)
          if (ii == 3) oterm = bvzdgc + omegc*vphig(3)
          rjj = hhgc*rhogc*alpgc*utgc**2*psigc**4*oterm
!
          souvec(irg,itg,ipg,ii) = radi**2*16.0d0*pi*alpgc*rjj*zfac
        end do
      end do
    end do
  end do     
!
end subroutine sourceterm_MoC_CF_drot
