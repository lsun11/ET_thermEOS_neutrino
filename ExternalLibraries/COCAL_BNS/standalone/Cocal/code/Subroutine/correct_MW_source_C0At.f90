subroutine correct_MW_source_C0At(sou,intp)
  use phys_constant, only : long, pi
  use grid_parameter, only : nrg, ntg, npg
  use coordinate_grav_r, only : hrg
  use def_matter, only : rs
  use interface_interpo_linear_type0_2Dsurf
  implicit none
  real(long), pointer :: sou(:,:,:)
  real(long) :: hsurf
  integer    :: irg, itg, ipg, irg_surf, intp, ipo
  real(long), external :: lagint_2nd
  real(long) :: x(2),y(2), v
!
! -- Extraporate MW source near the surface on midpoints 
! -- because of discontinuous derivatives of At. (At in C0)
!
  do ipg = 1, npg
    do itg = 1, ntg
      call interpo_linear_type0_2Dsurf(hsurf,rs,itg,ipg)
      do irg = 1, nrg
        if (hsurf < hrg(irg)) then 
          irg_surf = irg
          exit
        end if
      end do
!
      do ipo = 1, intp
        irg = irg_surf
!
        x(1) = hrg(irg-intp-1)
        x(2) = hrg(irg-intp-2)
        y(1) = sou(irg-intp-1,itg,ipg)
        y(2) = sou(irg-intp-2,itg,ipg)
        v    = hrg(irg-ipo)
        sou(irg-ipo,itg,ipg) = lagint_2nd(x,y,v)
!
        x(1) = hrg(irg+intp+0)
        x(2) = hrg(irg+intp+1)
        y(1) = sou(irg+intp+0,itg,ipg)
        y(2) = sou(irg+intp+1,itg,ipg)
        v    = hrg(irg+ipo -1)
        sou(irg+ipo-1,itg,ipg) = lagint_2nd(x,y,v)
!
      end do
!
    end do
  end do
!
end subroutine correct_MW_source_C0At
