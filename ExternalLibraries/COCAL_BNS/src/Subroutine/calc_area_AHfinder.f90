subroutine calc_area_AHfinder(aharea,ahmass)
  use phys_constant, only : long, pi
  use def_horizon, only : ahz
  use def_metric, only : psi
  use grid_parameter, only : npg, nrg, ntg
  use coordinate_grav_r, only : rg
  use weight_midpoint_grav, only : hwdtg, hwdpg
  use interface_interpo_linear_type0_2Dsurf
  use interface_interpo_linear_surface_type0
  implicit none
  real(long), external :: lagint_4th
  real(long) :: r4(4), f4(4)
  real(long) :: aharea, ahmass, area, detr, psiw, rgv, wds, fn_lagint
  integer :: ii, ipg, ir0, irg, irg0, itg
!
! --- Compute AH area.
write(6,*) "### Should rewrite calc_area_AHfinder.f90 "
!
  area = 0.0d0
  do ipg = 1, npg
    do itg = 1, ntg
      call interpo_linear_type0_2Dsurf(rgv,ahz,itg,ipg)
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
      psiw = lagint_4th(r4,f4,rgv)
      wds = hwdtg(itg)*hwdpg(ipg)
      area = area + psiw**4*rgv**2*wds
!
    end do
  end do
!
  aharea = area*2.0d0
  ahmass = dsqrt(aharea/(16.0d0*pi))
!
end subroutine calc_area_AHfinder
