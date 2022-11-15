subroutine helmholtz_solver_vol_int_hret_mi_hadv(sou,pot)
!     In the following subroutine, poisson_solver, when m is nonzero 
!      bsjy = -(2l+1)m*omega j_l(m*omega r_<) j_l(m*omega r_>) 
!     replaces 
!      hfsn = r_<^l/r_>^(l+1)  
!     to change the poisson solver to a helmholtz solver.
!     For m=0, bsjy is still r_<^l/r_>^(l+1) 
!
  use phys_constant,  only : long, pi
  use grid_parameter, only : nrg, npg, ntg, nlg
  use radial_green_fn_helmholtz, only : bsjy
  use legendre_fn_grav, only : plmg, hplmg, facnmg, epsig  
  use trigonometry_grav_theta
  use trigonometry_grav_phi, only : sinmpg, cosmpg, hsinmpg, hcosmpg
  use weight_midpoint_grav,  only : hwrtpg
  use make_array_3d
  implicit none
! 
  integer :: im, il, nlgtmp
  integer :: ir, irr, it, itt, ip, ipp       
! 
  real(long) :: pef, wok, pi4inv
  real(long), pointer :: sou(:,:,:),pot(:,:,:)
  real(long), pointer :: work1c(:,:,:)
  real(long), pointer :: work2c(:,:,:)
  real(long), pointer :: work3c(:,:,:)
  real(long), pointer :: work4c(:,:,:)
  real(long), pointer :: work1s(:,:,:)
  real(long), pointer :: work2s(:,:,:)
  real(long), pointer :: work3s(:,:,:)
  real(long), pointer :: work4s(:,:,:)
!
!helitest
!      nlgbak = nlg
!      nlg = 2
!helitest
!
  call alloc_array3d(work1c, 1, ntg, 1, nrg, 0, nlg)
  call alloc_array3d(work1s, 1, ntg, 1, nrg, 0, nlg)
  call alloc_array3d(work2c, 1, nrg, 0, nlg, 0, nlg)
  call alloc_array3d(work2s, 1, nrg, 0, nlg, 0, nlg)
  call alloc_array3d(work3c, 0, nlg, 0, nlg, 0, nrg)
  call alloc_array3d(work3s, 0, nlg, 0, nlg, 0, nrg)
  call alloc_array3d(work4c, 0, nlg, 0, nrg, 0, ntg)
  call alloc_array3d(work4s, 0, nlg, 0, nrg, 0, ntg)
!
  work1c(:,:,:) = 0.0d0
  work1s(:,:,:) = 0.0d0
  do im = 0, nlg
    do irr = 1, nrg
      do itt = 1, ntg
        do ipp = 1, npg
          work1c(itt,irr,im) = work1c(itt,irr,im) &
       &  + hwrtpg(irr,itt,ipp)*sou(irr,itt,ipp)*hcosmpg(im,ipp)
          work1s(itt,irr,im) = work1s(itt,irr,im) & 
       &  + hwrtpg(irr,itt,ipp)*sou(irr,itt,ipp)*hsinmpg(im,ipp)
        end do
      end do
    end do
  end do
!
  work2c = 0.0d0
  work2s = 0.0d0
  do il = 0, nlg
    do im = 0, nlg
      pef = epsig(im)*facnmg(il,im)
      do irr = 1, nrg
        do itt = 1, ntg
          wok = pef*hplmg(il,im,itt)
          work2c(irr,il,im) = work2c(irr,il,im) + wok*work1c(itt,irr,im)
          work2s(irr,il,im) = work2s(irr,il,im) + wok*work1s(itt,irr,im)
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
        do irr = 1, nrg
          work3c(il,im,ir) = work3c(il,im,ir) &
          &                + work2c(irr,il,im)*bsjy(irr,il,im,ir)
          work3s(il,im,ir) = work3s(il,im,ir) &
          &                + work2s(irr,il,im)*bsjy(irr,il,im,ir)
!  This is the place where bsjy has replaced hgfn in computing the potential
        end do
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
!helitest
!       nlgmax = nlg
!helitest  if (ir.ge.nrin) nlgmax = 8
!
  pot = 0.0d0
  do ip = 0, npg
    do it = 0, ntg
      do ir = 0, nrg
        do im = 0, nlg
          pot(ir,it,ip) = pot(ir,it,ip) &
          &             + work4c(im,ir,it)*sinmpg(im,ip) &
          &             - work4s(im,ir,it)*cosmpg(im,ip)
        end do
      end do
    end do
  end do
! 
  pi4inv = 1.0d0/4.0d0/pi
  pot = - pi4inv*pot
!
!helitest
!      nlg = nlgbak
!helitest
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
end subroutine helmholtz_solver_vol_int_hret_mi_hadv
