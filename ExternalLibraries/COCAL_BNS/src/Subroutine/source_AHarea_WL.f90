subroutine source_AHarea_WL(sousf)
  use phys_constant, only  : long, pi
  use grid_parameter, only : ntg, npg
  use def_metric, only  : psi
  use def_metric_hij, only : hxxd, hxyd, hxzd, hyyd, hyzd, hzzd
  use coordinate_grav_r, only : rg  
  use trigonometry_grav_theta, only : hsinthg, hcosthg
  use trigonometry_grav_phi, only : hsinphig, hcosphig
  use interface_interpo_linear_surface_type0
  use make_array_2d
  implicit none
  real(long), pointer  :: sousf(:,:), jacob(:,:), gamij(:,:)
  real(long) :: psim, psim4, gmxxd, gmxyd, gmxzd, gmyyd, gmyzd, gmzzd
  real(long) :: gam_thth, gam_phph, gam_thph, rrgg
  integer :: irg, itg, ipg, ia,ib
!
  call alloc_array2d(jacob,1,3,1,3)
  call alloc_array2d(gamij,1,3,1,3)
!
  irg = 0
  rrgg = rg(irg)

  do ipg = 1, npg
    do itg = 1, ntg
      call interpo_linear_surface_type0(psim,psi,irg,itg,ipg)
      call interpo_linear_surface_type0(gmxxd,hxxd,irg,itg,ipg)
      call interpo_linear_surface_type0(gmxyd,hxyd,irg,itg,ipg)
      call interpo_linear_surface_type0(gmxzd,hxzd,irg,itg,ipg)
      call interpo_linear_surface_type0(gmyyd,hyyd,irg,itg,ipg)
      call interpo_linear_surface_type0(gmyzd,hyzd,irg,itg,ipg)
      call interpo_linear_surface_type0(gmzzd,hzzd,irg,itg,ipg)

      psim4 = psim*psim*psim*psim

      gamij(1,1) = (1.0d0+gmxxd)*psim4
      gamij(1,2) = (      gmxyd)*psim4
      gamij(1,3) = (      gmxzd)*psim4
      gamij(2,2) = (1.0d0+gmyyd)*psim4
      gamij(2,3) = (      gmyzd)*psim4
      gamij(3,3) = (1.0d0+gmzzd)*psim4

      gamij(2,1) = gamij(1,2)
      gamij(3,1) = gamij(1,3)
      gamij(3,2) = gamij(2,3)

      jacob(1,1) =       hsinthg(itg)*hcosphig(ipg)
      jacob(1,2) =  rrgg*hcosthg(itg)*hcosphig(ipg)
      jacob(1,3) = -rrgg*hsinthg(itg)*hsinphig(ipg)

      jacob(2,1) =       hsinthg(itg)*hsinphig(ipg)
      jacob(2,2) =  rrgg*hcosthg(itg)*hsinphig(ipg)
      jacob(2,3) =  rrgg*hsinthg(itg)*hcosphig(ipg)

      jacob(3,1) =       hcosthg(itg)
      jacob(3,2) = -rrgg*hsinthg(itg)
      jacob(3,3) =  0.0d0
     
      gam_thth = 0.0d0
      gam_phph = 0.0d0
      gam_thph = 0.0d0
      do ia=1,3
        do ib=1,3
          gam_thth = gam_thth + jacob(ia,2)*gamij(ia,ib)*jacob(ib,2)
          gam_phph = gam_phph + jacob(ia,3)*gamij(ia,ib)*jacob(ib,3)
          gam_thph = gam_thph + jacob(ia,2)*gamij(ia,ib)*jacob(ib,3)
        end do
      end do

!     NOTE: The source here contains the typical weight r**2 sin(theta)
      sousf(itg,ipg) = dsqrt(gam_thth*gam_phph - gam_thph*gam_thph)
    end do
  end do
!
  deallocate(jacob)
  deallocate(gamij)
!
end subroutine source_AHarea_WL
