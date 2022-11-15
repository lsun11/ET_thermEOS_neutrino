subroutine source_AHarea_AHfinder(sou)
  use phys_constant, only  : long, pi
  use grid_parameter, only : nrg, ntg, npg
  use coordinate_grav_r, only : rg
  use trigonometry_grav_theta, only : hsinthg
  use def_metric, only  : tfkijkij, psi
  use def_horizon, only : ahz
  use interface_interpo_linear_type0_2Dsurf
  use interface_interpo_linear_surface_type0
  use interface_grdtp_2Dsurf_midpoint_type0
  implicit none
  real(long), pointer  :: sou(:,:)
  real(long), external :: lagint_4th
  real(long) :: r4(4), f4(4)
  real(long) :: detr, psiw, rgv, dahzdt, dahzdp
  integer :: ii, ir0, irg0, irg, itg, ipg
!
  do ipg = 1, npg
    do itg = 1, ntg
      call interpo_linear_type0_2Dsurf(rgv,ahz,itg,ipg)
      irg0 = 0 
      do irg = 0, nrg-1
        detr = (rg(irg+1)-rgv)*(rg(irg)-rgv)
        if(detr <= 0.0d0) then
          irg0 = irg
          exit
        end if
      end do
!
      ir0 = min0(max0(irg0-1,0),nrg-3)
!
      do ii = 1, 4
        irg = ir0-1 + ii
        r4(ii) = rg(irg)
        call interpo_linear_surface_type0(psiw,psi,irg,itg,ipg)
        f4(ii) = psiw
      end do
!
      call grdtp_2Dsurf_midpoint_type0(ahz,dahzdt,dahzdp,itg,ipg)
!
      psiw = lagint_4th(r4,f4,rgv)
      sou(itg,ipg) = psiw**4*rgv**2*dsqrt(1.0d0 + (dahzdt/rgv)**2 &
      &                          + (dahzdp/(rgv*hsinthg(itg)))**2)
!
    end do
  end do
!
end subroutine source_AHarea_AHfinder
