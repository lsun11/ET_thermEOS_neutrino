subroutine sourceterm_MoC_WL_drot_all(souvec)
  use phys_constant, only : long, pi
  use grid_parameter, only : nrg, ntg, npg
  use def_metric, only : psi, alph,  bvxd, bvyd, bvzd
  use def_metric_hij, only : hxxd, hxyd, hxzd, &
     &                       hyyd, hyzd, hzzd
  use def_matter, only : omeg, emdg, jomeg_int
  use def_matter_parameter, only : ber, radi
  use def_vector_phi, only: hvec_phig
  use interface_interpo_linear_type0
  implicit none
  real(long), pointer :: souvec(:,:,:,:)
  real(long) :: vphig(3)
  real(long) :: emdgc, rhogc, pregc, hhgc, ene, utgc, oterm, rjj, zfac
  real(long) :: psigc, alpgc, bvxdgc, bvydgc, bvzdgc
  real(long) :: hxxdgc, hxydgc, hxzdgc, hyxdgc, hyydgc, hyzdgc, &
  &             hzxdgc, hzydgc, hzzdgc
  real(long) :: omegc, jomeg_intgc
  integer :: irg, itg, ipg, ii
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

          call interpo_linear_type0(hxxdgc,hxxd,irg,itg,ipg)
          call interpo_linear_type0(hxydgc,hxyd,irg,itg,ipg)
          call interpo_linear_type0(hxzdgc,hxzd,irg,itg,ipg)
          call interpo_linear_type0(hyydgc,hyyd,irg,itg,ipg)
          call interpo_linear_type0(hyzdgc,hyzd,irg,itg,ipg)
          call interpo_linear_type0(hzzdgc,hzzd,irg,itg,ipg)
          hyxdgc = hxydgc
          hzxdgc = hxzdgc
          hzydgc = hyzdgc
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
! --- CF and waveless contributions
          if (ii == 1) oterm = bvxdgc + (1.0+hxxdgc)*omegc*vphig(1) &
                           & +                hxydgc*omegc*vphig(2) &
                           & +                hxzdgc*omegc*vphig(3)
          if (ii == 2) oterm = bvydgc +       hyxdgc*omegc*vphig(1) &
                           & +          (1.0+hyydgc)*omegc*vphig(2) &
                           & +                hyzdgc*omegc*vphig(3)
          if (ii == 3) oterm = bvzdgc +       hzxdgc*omegc*vphig(1) &
                           & +                hzydgc*omegc*vphig(2) &
                           & +          (1.0+hzzdgc)*omegc*vphig(3)

          rjj = hhgc*rhogc*alpgc*utgc**2*psigc**4*oterm
!
          souvec(irg,itg,ipg,ii) = radi**2*16.0d0*pi*alpgc*rjj*zfac
!
        end do
      end do
    end do
  end do
!
end subroutine sourceterm_MoC_WL_drot_all
