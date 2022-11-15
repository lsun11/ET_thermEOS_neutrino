subroutine sourceterm_MWspatial_current_WL(souvec)
  use phys_constant, only : long, pi
  use grid_parameter, only : nrg, ntg, npg
  use coordinate_grav_r, only : hrg
  use trigonometry_grav_theta, only : hsinthg,  hcosthg
  use trigonometry_grav_phi,   only : hsinphig, hcosphig
  use def_metric, only : psi, alph, bvxd, bvyd, bvzd
  use def_metric_hij, only : hxxd, hxyd, hxzd, hyyd, hyzd, hzzd
  use def_matter, only : emdg
  use def_matter_parameter, only : radi
  use def_emfield, only : jtu, jxu, jyu, jzu
  use def_matter_parameter, only : ome, ber, radi
  use def_vector_phi, only : hvec_phig
  use make_array_3d
  use interface_grgrad_midpoint
  use interface_interpo_linear_type0
  implicit none
  real(long), pointer :: souvec(:,:,:,:)
  real(long) :: hijd(3,3)
  real(long) :: emdgc, jterm, jxugc, jyugc, jzugc, &
  &             hhxxd, hhxyd, hhxzd, hhyyd, hhyzd, hhzzd, &
  &             hhyxd, hhzxd, hhzyd
  real(long) :: psigc, alpgc, bvadgc
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
          call interpo_linear_type0(psigc,psi,irg,itg,ipg)
!
           = 1.0d0
          if (emdgc <= 1.0d-15) then
            emdgc = 1.0d-15
              = 0.0d0
          end if
!
          hijd(1:3,1:3) = 0.0d0
          if (ii == 1) then 
            call interpo_linear_type0(hhxxd,hxxd,irg,itg,ipg)
            call interpo_linear_type0(hhxyd,hxyd,irg,itg,ipg)
            call interpo_linear_type0(hhxzd,hxzd,irg,itg,ipg)
          end if
          if (ii == 2) then 
            call interpo_linear_type0(hhxyd,hxyd,irg,itg,ipg)
            call interpo_linear_type0(hhyyd,hyyd,irg,itg,ipg)
            call interpo_linear_type0(hhyzd,hyzd,irg,itg,ipg)
          end if
          if (ii == 3) then 
            call interpo_linear_type0(hhxzd,hxzd,irg,itg,ipg)
            call interpo_linear_type0(hhyzd,hyzd,irg,itg,ipg)
            call interpo_linear_type0(hhzzd,hzzd,irg,itg,ipg)
          end if
          hijd(1,1) = hhxxd ; hijd(1,2) = hhxyd ; hijd(1,3) = hhxzd
          hijd(2,1) = hhxyd ; hijd(2,2) = hhyyd ; hijd(2,3) = hhyzd
          hijd(3,1) = hhxzd ; hijd(3,2) = hhyzd ; hijd(3,3) = hhzzd
          call interpo_linear_type0(jxugc,jxu,irg,itg,ipg)
          call interpo_linear_type0(jyugc,jyu,irg,itg,ipg)
          call interpo_linear_type0(jzugc,jzu,irg,itg,ipg)
!
          jterm = hijd(ii,1)*jxugc + hijd(ii,2)*jyugc + hijd(ii,3)*jzugc
!
          souvec(irg,itg,ipg,ii) = - radi**2*4.0d0*pi*psigc**8*jterm
!
        end do
      end do
    end do
  end do     
!
end subroutine sourceterm_MWspatial_current_WL
