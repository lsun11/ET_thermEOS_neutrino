subroutine sourceterm_MoC_WL_corot(souvec)
!
  use phys_constant, only : pi
  use grid_parameter, only : nrg, ntg, npg
  use coordinate_grav_r, only : hrg
  use trigonometry_grav_phi, only : hsinphig, hcosphig
  use trigonometry_grav_theta, only : hsinthg,  hcosthg
  use def_metric, only : psi, alph, bvxd, bvyd, bvzd, tfkij
  use def_metric_hij, only : hxxd, hxyd, hxzd, hyyd, hyzd, hzzd
  use def_matter, only : emdg
  use def_matter_parameter, only : ome, ber, radi
  use def_vector_phi, only: hvec_phig
  use interface_interpo_linear_type0
  implicit none
!
  real(8), pointer :: souvec(:,:,:,:)
  real(8) :: vphig(3)
  real(8) :: emdgc, rhogc, pregc, hhgc, ene, utgc, oterm, zfac, rjj
  real(8) :: psigc, alpgc
  real(8) :: hhxxd, hhxyd, hhxzd, hhyxd, hhyyd, hhyzd, &
  &          hhzxd, hhzyd, hhzzd
  integer :: ipg, irg, itg, ii
!
  do ii = 1, 3
!
    do ipg = 1, npg
      do itg = 1, ntg
        do irg = 1, nrg
!
          call interpo_linear_type0(hhxxd,hxxd,irg,itg,ipg)
          call interpo_linear_type0(hhxyd,hxyd,irg,itg,ipg)
          call interpo_linear_type0(hhxzd,hxzd,irg,itg,ipg)
          call interpo_linear_type0(hhyyd,hyyd,irg,itg,ipg)
          call interpo_linear_type0(hhyzd,hyzd,irg,itg,ipg)
          call interpo_linear_type0(hhzzd,hzzd,irg,itg,ipg)
          hhyxd = hhxyd
          hhzxd = hhxzd
          hhzyd = hhyzd
!
          call interpo_linear_type0(psigc,psi,irg,itg,ipg)
          call interpo_linear_type0(alpgc,alph,irg,itg,ipg)
          call interpo_linear_type0(emdgc,emdg,irg,itg,ipg)
!
          zfac = 1.0d0
          if (emdgc <= 1.0d-14) then
            emdgc = 1.0d-14
            zfac  = 0.0d0
          end if
          call peos_q2hprho(emdgc, hhgc, pregc, rhogc, ene)
          utgc  = hhgc/ber
          vphig(1) = hvec_phig(irg,itg,ipg,1)
          vphig(2) = hvec_phig(irg,itg,ipg,2)
          vphig(3) = hvec_phig(irg,itg,ipg,3)
          oterm = 0.0d0
! --- only for the waveless contributions
          if (ii == 1) oterm = hhxxd*ome*vphig(1) &
                           & + hhxyd*ome*vphig(2) &
                           & + hhxzd*ome*vphig(3)
          if (ii == 2) oterm = hhyxd*ome*vphig(1) &
                           & + hhyyd*ome*vphig(2) &
                           & + hhyzd*ome*vphig(3)
          if (ii == 3) oterm = hhzxd*ome*vphig(1) &
                           & + hhzyd*ome*vphig(2) &
                           & + hhzzd*ome*vphig(3)
          rjj = hhgc*rhogc*alpgc*utgc**2*psigc**4*oterm
!
          souvec(irg,itg,ipg,ii) = radi**2*16.0d0*pi*alpgc*rjj*zfac
!
        end do
      end do
    end do
  end do
!
end subroutine sourceterm_MoC_WL_corot
!          if (ii == 1) oterm = swflu *gradvg(irg,itg,ipg,1) &
!             &             +(1.0d0-swflu)*  ovxd(irg,itg,ipg)
!          if (ii == 2) oterm = swflu *gradvg(irg,itg,ipg,2) &
!             &             +(1.0d0-swflu)*  ovyd(irg,itg,ipg)
!          if (ii == 3) oterm = swflu *gradvg(irg,itg,ipg,3) &
!             &             +(1.0d0-swflu)*  ovzd(irg,itg,ipg)
!
!          zfac = 1.0d0
!          if (emdgc <= 0.0d0) zfac = 0.0d0
!          rjj =       swflu *rhogc*alpgc*utgc*oterm  &
!             &    +(1.0d0-swflu)*hhgc*rhogc*alpgc*utgc**2*psigc**4*oterm
