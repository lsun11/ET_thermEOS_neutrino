subroutine poisson_solver_bhex_surf_int_all(sou_iosurf,pot)
  use phys_constant,  only : long, pi
  use grid_parameter, only : nrg, npg, ntg, nlg
  use radial_green_fn_grav, only : gfnsf
  use legendre_fn_grav, only : plmg, hplmg, facnmg, epsig  
  use trigonometry_grav_theta
  use trigonometry_grav_phi, only : sinmpg, cosmpg, hsinmpg, hcosmpg
  use grid_points_binary_excision,  only : ihpg_exin, ihpg_exout
  use weight_midpoint_grav,  only : hwtpgsf
  use make_array_3d
  implicit none
! 
  integer :: ia, im, il, nlgtmp
  integer :: ir, irr, it, itt, ip, ipp
! 
  real(long) :: pef, wok, pi4inv
  real(long), pointer :: pot(:,:,:)
  real(long), pointer :: sou_iosurf(:,:,:)
  real(long), pointer :: work1c(:,:,:)
  real(long), pointer :: work2c(:,:,:)
  real(long), pointer :: work3c(:,:,:)
  real(long), pointer :: work4c(:,:,:)
  real(long), pointer :: work1s(:,:,:)
  real(long), pointer :: work2s(:,:,:)
  real(long), pointer :: work3s(:,:,:)
  real(long), pointer :: work4s(:,:,:)
! 
! 
  call alloc_array3d(work1c, 1, ntg, 0, nlg, 1, 4)
  call alloc_array3d(work1s, 1, ntg, 0, nlg, 1, 4)
  call alloc_array3d(work2c, 0, nlg, 0, nlg, 1, 4)
  call alloc_array3d(work2s, 0, nlg, 0, nlg, 1, 4)
  call alloc_array3d(work3c, 0, nlg, 0, nlg, 0, nrg)
  call alloc_array3d(work3s, 0, nlg, 0, nlg, 0, nrg)
  call alloc_array3d(work4c, 0, nlg, 0, nrg, 0, ntg)
  call alloc_array3d(work4s, 0, nlg, 0, nrg, 0, ntg)
!
  work1c = 0.0
  work1s = 0.0
  irr = 0
  do ia = 1, 4
    do im = 0, nlg
      do itt = 1, ntg
        do ipp = 1, npg
          wok = hwtpgsf(itt,ipp)*sou_iosurf(itt,ipp,ia)
          work1c(itt,im,ia) = work1c(itt,im,ia) + wok*hcosmpg(im,ipp)
          work1s(itt,im,ia) = work1s(itt,im,ia) + wok*hsinmpg(im,ipp)
        end do
      end do
    end do
  end do
! 
  work2c = 0.0d0
  work2s = 0.0d0
  do ia = 1, 4
    do il = 0, nlg
      do im = 0, nlg
        pef = epsig(im)*facnmg(il,im)
        do itt = 1, ntg
          wok = pef*hplmg(il,im,itt)
          work2c(il,im,ia) = work2c(il,im,ia) + wok*work1c(itt,im,ia)
          work2s(il,im,ia) = work2s(il,im,ia) + wok*work1s(itt,im,ia)
        end do
      end do
    end do
  end do
! 
  work3c = 0.0d0
  work3s = 0.0d0
  do ir = 0, nrg
    do il = 0, nlg
      do im = 0, nlg
        work3c(il,im,ir) = &
        &                + work2c(il,im,1)*gfnsf(il,ir,1) &
        &                - work2c(il,im,2)*gfnsf(il,ir,2) &
        &                + work2c(il,im,3)*gfnsf(il,ir,3) &
        &                - work2c(il,im,4)*gfnsf(il,ir,4)
        work3s(il,im,ir) = &
        &                + work2s(il,im,1)*gfnsf(il,ir,1) &
        &                - work2s(il,im,2)*gfnsf(il,ir,2) &
        &                + work2s(il,im,3)*gfnsf(il,ir,3) &
        &                - work2s(il,im,4)*gfnsf(il,ir,4)
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
  pot = pi4inv*pot
!
  deallocate(work1c)
  deallocate(work1s)
  deallocate(work2c)
  deallocate(work2s)
  deallocate(work3c)
  deallocate(work3s)
  deallocate(work4c)
  deallocate(work4s)
! 
end subroutine poisson_solver_bhex_surf_int_all
