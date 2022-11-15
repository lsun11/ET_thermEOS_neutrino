subroutine poisson_solver(sou, pot)
  use phys_constant, only	: long, pi
  use grid_parameter, only : nrg, npg, ntg, nlg
  use radial_green_fn_grav, only : hgfn
  use legendre_fn_grav, only  :  plmg, hplmg, facnmg, epsig  
  use trigonometry_grav_theta
  use trigonometry_grav_phi, only : sinmpg, cosmpg
  use weight_midpoint_grav, only : hwrtpg
  use make_array_3d
  implicit none
  integer :: im, il
  integer :: ir, irr, it, itt, ip, ipp       
  real(long), pointer :: sou(:,:,:),pot(:,:,:)
  real(long)          :: pef, wok, pi4inv
  real(long), pointer :: work1c(:,:,:)
  real(long), pointer :: work2c(:,:,:)
  real(long), pointer :: work3c(:,:,:)
  real(long), pointer :: work4c(:,:,:)
  real(long), pointer :: work1s(:,:,:)
  real(long), pointer :: work2s(:,:,:)
  real(long), pointer :: work3s(:,:,:)
  real(long), pointer :: work4s(:,:,:)
! 
  call alloc_array3d(work1c, 1, nrg, 1, ntg, 0, nlg)
  call alloc_array3d(work1s, 1, nrg, 1, ntg, 0, nlg)
  call alloc_array3d(work2c, 1, nrg, 0, nlg, 0, nlg)
  call alloc_array3d(work2s, 1, nrg, 0, nlg, 0, nlg)
  call alloc_array3d(work3c, 0, nrg, 0, nlg, 0, nlg)
  call alloc_array3d(work3s, 0, nrg, 0, nlg, 0, nlg)
  call alloc_array3d(work4c, 0, nrg, 0, ntg, 0, nlg)
  call alloc_array3d(work4s, 0, nrg, 0, ntg, 0, nlg)
!
  work1c = 0.0
  work1s = 0.0
  do im = 0, nlg
    do ipp = 1, npg
      work1c(1:nrg,1:ntg,im) = work1c(1:nrg,1:ntg,im) & 
    &                   + 0.5*hwrtpg(1:nrg,1:ntg,ipp)*sou(1:nrg,1:ntg,ipp) &
    &                   *(cosmpg(im,ipp)+cosmpg(im,ipp-1))
      work1s(1:nrg,1:ntg,im) = work1s(1:nrg,1:ntg,im) & 
    &                   + 0.5*hwrtpg(1:nrg,1:ntg,ipp)*sou(1:nrg,1:ntg,ipp) &
    &                   *(sinmpg(im,ipp)+sinmpg(im,ipp-1))
    end do
  end do
! 
  work2c = 0.0d0
  work2s = 0.0d0
  do il = 0, nlg
    do im = 0, nlg
      pef = epsig(im)*facnmg(il,im)
      do itt = 1, ntg
        wok = pef*hplmg(il,im,itt)
        work2c(1:nrg,il,im) = work2c(1:nrg,il,im) + wok*work1c(1:nrg,itt,im)
        work2s(1:nrg,il,im) = work2s(1:nrg,il,im) + wok*work1s(1:nrg,itt,im)
      end do
    end do
  end do
! 
  work3c = 0.0d0
  work3s = 0.0d0
  do ir = 0, nrg
    do il = 0, nlg
      do irr = 1, nrg
        work3c(ir,il,0:nlg) = work3c(ir,il,0:nlg) &
      &                     + work2c(irr,il,0:nlg)*hgfn(irr,il,ir)
        work3s(ir,il,0:nlg) = work3s(ir,il,0:nlg) &
      &                     + work2s(irr,il,0:nlg)*hgfn(irr,il,ir)
      end do
    end do
  end do
! 
  work4c = 0.0d0
  work4s = 0.0d0
  do it = 0, ntg 
    do im = 0, nlg
      do il = 0, nlg
        work4c(0:nrg,it,im) = work4c(0:nrg,it,im) &
      &                     + work3c(0:nrg,il,im)*plmg(il,im,it)
        work4s(0:nrg,it,im) = work4s(0:nrg,it,im) &
      &                     + work3s(0:nrg,il,im)*plmg(il,im,it)
      end do
    end do
  end do
! 
  pot = 0.0d0
  do ip = 0, npg
    do im = 0, nlg
      pot(0:nrg,0:ntg,ip) = pot(0:nrg,0:ntg,ip) &
    &                     + work4c(0:nrg,0:ntg,im)*cosmpg(im,ip) &
    &                     + work4s(0:nrg,0:ntg,im)*sinmpg(im,ip)
    end do
  end do
! 
  pi4inv = 1.0d0/4.0d0/pi
  pot = - pi4inv*pot
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
end subroutine poisson_solver

