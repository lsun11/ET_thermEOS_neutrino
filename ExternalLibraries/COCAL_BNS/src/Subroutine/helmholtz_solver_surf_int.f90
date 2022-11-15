subroutine helmholtz_solver_surf_int(sou_surf,dsou_surf,pot)
!
!     This subroutine computes the contribution spot(ir,it,ip)
!     to the potential pot from a surface term at the inner or outer surface 
!     The integrand is proportional to a function 
!      psis = partial_r pot(R,theta,phi)n_l(R) - pot \partial_r n_l(omega R)
!     The routine is adapted from grav4, omitting the r integral and 
!     r weighting, but retaining the theta and phi integrals and the 
!     corresponding sums
!
! P_lm components of the potential at the surface:
! swork1 is the mth component of pot, weighted by wgdtg
! spwork1 is the mth component of partial_r pot weighted by wgdtg
! swork2 is the lm component of pot
! spwork2 is the lm component of partial_r pot
!
  use phys_constant,  only : long, pi
  use grid_parameter, only : nrg, npg, ntg, nlg
  use coordinate_grav_r, only : rg
  use radial_green_fn_helmholtz, only : sbsjy, sbsjyp
  use legendre_fn_grav, only : plmg, hplmg, facnmg, epsig  
  use trigonometry_grav_phi, only : sinmpg, cosmpg, hsinmpg, hcosmpg
  use weight_midpoint_grav,  only : hwtpgsf
  use make_array_2d
  use make_array_3d
  implicit none
! 
  integer :: im, il
  integer :: ir, it, itt, ip, ipp
  real(long) :: pef, wok, wokc, woks, pi4inv, rsqpi4inv
  real(long), pointer :: sou_surf(:,:),dsou_surf(:,:),pot(:,:,:)
  real(long), pointer :: work11c(:,:), gwork11c(:,:)
  real(long), pointer :: work11s(:,:), gwork11s(:,:)
  real(long), pointer :: work21c(:,:), gwork21c(:,:)
  real(long), pointer :: work21s(:,:), gwork21s(:,:)
  real(long), pointer :: work3c(:,:,:)
  real(long), pointer :: work4c(:,:,:)
  real(long), pointer :: work3s(:,:,:)
  real(long), pointer :: work4s(:,:,:)
! 
  call alloc_array2d( work11c, 1, ntg, 0, nlg)
  call alloc_array2d(gwork11c, 1, ntg, 0, nlg)
  call alloc_array2d( work11s, 1, ntg, 0, nlg)
  call alloc_array2d(gwork11s, 1, ntg, 0, nlg)
  call alloc_array2d( work21c, 0, nlg, 0, nlg)
  call alloc_array2d(gwork21c, 0, nlg, 0, nlg)
  call alloc_array2d( work21s, 0, nlg, 0, nlg)
  call alloc_array2d(gwork21s, 0, nlg, 0, nlg)
  call alloc_array3d(work3c, 0, nlg, 0, nlg, 0, nrg)
  call alloc_array3d(work3s, 0, nlg, 0, nlg, 0, nrg)
  call alloc_array3d(work4c, 0, nlg, 0, nrg, 0, ntg)
  call alloc_array3d(work4s, 0, nlg, 0, nrg, 0, ntg)
!
! -- integrate on midpoint
   work11c(:,:) = 0.0d0
  gwork11c(:,:) = 0.0d0
   work11s(:,:) = 0.0d0
  gwork11s(:,:) = 0.0d0
  do im = 0, nlg
    do itt = 1, ntg
      do ipp = 1, npg
        wokc = hwtpgsf(itt,ipp)*hcosmpg(im,ipp)
        woks = hwtpgsf(itt,ipp)*hsinmpg(im,ipp)
        work11c(itt,im)  = work11c(itt,im) + wokc*dsou_surf(itt,ipp)
        gwork11c(itt,im) = gwork11c(itt,im) + wokc*sou_surf(itt,ipp)
        work11s(itt,im)  = work11s(itt,im) + woks*dsou_surf(itt,ipp)
        gwork11s(itt,im) = gwork11s(itt,im) + woks*sou_surf(itt,ipp)
      end do
    end do
  end do
!
   work21c(:,:) = 0.0d0
  gwork21c(:,:) = 0.0d0
   work21s(:,:) = 0.0d0
  gwork21s(:,:) = 0.0d0
  do il = 0, nlg
    do im = 0, nlg
      pef  = epsig(im)*facnmg(il,im)
      do itt = 1, ntg
        wok = pef*hplmg(il,im,itt)
        work21c(il,im)  = work21c(il,im) + wok*work11c(itt,im)
        gwork21c(il,im) = gwork21c(il,im) + wok*gwork11c(itt,im)
        work21s(il,im)  = work21s(il,im) + wok*work11s(itt,im)
        gwork21s(il,im) = gwork21s(il,im) + wok*gwork11s(itt,im)
      end do
    end do
  end do
!
!   Construct the surface integral for each l,m,r 
!   psi =  partial_r pot_lm *y_l(m omega r) - pot_lm* partial_r y_l(m omega r)
!   swork3 = psi * (-m omega)(2l+1)
!  
!   sbsjy :=  j_l(m omega r) y_l(m omega R) (m omega)(2l+1)
!   sbsjyp =  j_l(m omega r) y_l'(m omega R)(m omega)^2(2l+1)
!
  work3c = 0.0d0
  work3s = 0.0d0
  do ir = 0, nrg
    do il = 0, nlg
      do im = 0, nlg
        work3c(il,im,ir) =  work21c(il,im)*sbsjy(il,im,ir) &
        &                - gwork21c(il,im)*sbsjyp(il,im,ir)
        work3s(il,im,ir) =  work21s(il,im)*sbsjy(il,im,ir) &
        &                - gwork21s(il,im)*sbsjyp(il,im,ir)
      end do
    end do
  end do
!
  work4c = 0.0d0
  work4s = 0.0d0
  do it = 0, ntg 
    do ir = 0, nrg 
      do im = 0, nlg
        do il = 0, nlg
          work4c(im,ir,it) = work4c(im,ir,it) &
          &                + work3c(il,im,ir)*plmg(il,im,it)
          work4s(im,ir,it) = work4s(im,ir,it) &
          &                + work3s(il,im,ir)*plmg(il,im,it)
        end do
      end do
    end do
  end do
! 
  pot = 0.0d0
  do ip = 0, npg
    do it = 0, ntg
      do ir = 0, nrg
        do im = 0, nlg
          pot(ir,it,ip) = pot(ir,it,ip) &
          &             + work4c(im,ir,it)*cosmpg(im,ip) &
          &             + work4s(im,ir,it)*sinmpg(im,ip)
         end do
      end do
    end do
  end do
! 
  pi4inv = 1.0d0/4.0d0/pi
  pot(:,:,:) = pi4inv*pot(:,:,:)
!
  deallocate( work11c)
  deallocate(gwork11c)
  deallocate( work11s)
  deallocate(gwork11s)
  deallocate( work21c)
  deallocate(gwork21c)
  deallocate( work21s)
  deallocate(gwork21s)
  deallocate(work3c)
  deallocate(work3s)
  deallocate(work4c)
  deallocate(work4s)
!
end subroutine helmholtz_solver_surf_int
