subroutine current_modify_MHD(cobj)
  use phys_constant, only  : long, pi
  use grid_parameter
  use coordinate_grav_r, only : rg
  use trigonometry_grav_phi, only   : sinphig, cosphig
  use def_metric, only : alph, psi
  use def_metric_hij, only : hxxu, hxyu, hxzu, hyyu, hyzu, hzzu
  use def_matter, only : rs
  use def_matter_parameter, only : radi
  use def_emfield, only : va, vaxd, vayd, vazd, jtu, jxu, jyu, jzu
  use def_emfield_derivatives, only : Lie_bAxd_grid, Lie_bAyd_grid, &
  &                                   Lie_bAzd_grid
  use def_vector_phi, only : vec_phig
  use integrability_fnc_MHD
  use make_array_3d
  use interface_interpo_gr2fl
  use interface_grgrad_gridpoint_4th_type0
  use interface_calc_integrability_modify_At
  implicit none
  real(long), pointer :: vaphid(:,:,:), va_mod(:,:,:), alva_mod(:,:,:)
  real(long), pointer :: fxd_grid_mod(:,:,:), p6fxu(:,:,:)
  real(long), pointer :: fyd_grid_mod(:,:,:), p6fyu(:,:,:)
  real(long), pointer :: fzd_grid_mod(:,:,:), p6fzu(:,:,:)
  real(long) :: vecphi(3)
  real(long) :: dfxudx, dfxudy, dfxudz
  real(long) :: dfyudx, dfyudy, dfyudz
  real(long) :: dfzudx, dfzudy, dfzudz
  real(long) :: alps6inv, pi4invR2, jphiu, Aphi
  real(long) :: dalvadxgp, dalvadygp, dalvadzgp
  real(long) :: lie_bAx, lie_bAy, lie_bAz, ainvh
  integer    :: irg, itg, ipg
  character(len=2), intent(in) :: cobj
!
  call alloc_array3d(vaphid, 0, nrg, 0, ntg, 0, npg)
  call alloc_array3d(va_mod, 0, nrg, 0, ntg, 0, npg)
  call alloc_array3d(alva_mod, 0, nrg, 0, ntg, 0, npg)
  call alloc_array3d(fxd_grid_mod, 0, nrg, 0, ntg, 0, npg)
  call alloc_array3d(fyd_grid_mod, 0, nrg, 0, ntg, 0, npg)
  call alloc_array3d(fzd_grid_mod, 0, nrg, 0, ntg, 0, npg)
  call alloc_array3d(p6fxu, 0, nrg, 0, ntg, 0, npg)
  call alloc_array3d(p6fyu, 0, nrg, 0, ntg, 0, npg)
  call alloc_array3d(p6fzu, 0, nrg, 0, ntg, 0, npg)
!
  vaphid(0:nrg,0:ntg,0:npg)=vayd(0:nrg,0:ntg,0:npg) &
  &                    *vec_phig(0:nrg,0:ntg,0:npg,2)
!!   va_mod(0:nrg,0:ntg,0:npg) = va(0:nrg,0:ntg,0:npg)
  call calc_integrability_modify_At(va_mod,'gr')
  alva_mod(0:nrg,0:ntg,0:npg) = alph(0:nrg,0:ntg,0:npg) &
  &                          *va_mod(0:nrg,0:ntg,0:npg)
!
  do ipg = 0, npg
    do itg = 0, ntg
      do irg = 0, nrg
!
        call grgrad_gridpoint_4th_type0(alva_mod, &
        &          dalvadxgp,dalvadygp,dalvadzgp,irg,itg,ipg,cobj)
        ainvh = 1.0d0/alph(irg,itg,ipg)
        lie_bAx = Lie_bAxd_grid(irg,itg,ipg)
        lie_bAy = Lie_bAyd_grid(irg,itg,ipg)
        lie_bAz = Lie_bAzd_grid(irg,itg,ipg)
        fxd_grid_mod(irg,itg,ipg) = ainvh*(lie_bAx - dalvadxgp)
        fyd_grid_mod(irg,itg,ipg) = ainvh*(lie_bAy - dalvadygp)
        fzd_grid_mod(irg,itg,ipg) = ainvh*(lie_bAz - dalvadzgp)
!
      end do
    end do
  end do
!
  p6fxu(0:nrg,0:ntg,0:npg) = psi(0:nrg,0:ntg,0:npg)**2 &
  &  *((1.0d0 + hxxu(0:nrg,0:ntg,0:npg))*fxd_grid_mod(0:nrg,0:ntg,0:npg) &
  &           + hxyu(0:nrg,0:ntg,0:npg) *fyd_grid_mod(0:nrg,0:ntg,0:npg) &
  &           + hxzu(0:nrg,0:ntg,0:npg) *fzd_grid_mod(0:nrg,0:ntg,0:npg))
  p6fyu(0:nrg,0:ntg,0:npg) = psi(0:nrg,0:ntg,0:npg)**2 &
  &           *(hxyu(0:nrg,0:ntg,0:npg) *fxd_grid_mod(0:nrg,0:ntg,0:npg) &
  &  + (1.0d0 + hyyu(0:nrg,0:ntg,0:npg))*fyd_grid_mod(0:nrg,0:ntg,0:npg) &
  &           + hyzu(0:nrg,0:ntg,0:npg) *fzd_grid_mod(0:nrg,0:ntg,0:npg))
  p6fzu(0:nrg,0:ntg,0:npg) = psi(0:nrg,0:ntg,0:npg)**2 &
  &           *(hxzu(0:nrg,0:ntg,0:npg) *fxd_grid_mod(0:nrg,0:ntg,0:npg) &
  &           + hyzu(0:nrg,0:ntg,0:npg) *fyd_grid_mod(0:nrg,0:ntg,0:npg) &
  &  + (1.0d0 + hzzu(0:nrg,0:ntg,0:npg))*fzd_grid_mod(0:nrg,0:ntg,0:npg))
!
! Solve on phi=0 plane
  pi4invR2 = 1.0d0/(4.0d0*pi*radi**2)
  ipg = 0
  do itg = 0, ntg
    do irg = 0, nrg
!
      vecphi(1)= vec_phig(irg,itg,ipg,1)
      vecphi(2)= vec_phig(irg,itg,ipg,2)
      vecphi(3)= vec_phig(irg,itg,ipg,3)
      alps6inv = 1.0d0/(alph(irg,itg,ipg)*psi(irg,itg,ipg)**6)
      Aphi = vaphid(irg,itg,ipg)
      call calc_integrability_fnc_MHD(Aphi)
      call grgrad_gridpoint_4th_type0(p6fxu,dfxudx,dfxudy,dfxudz,&
      &                                     irg,itg,ipg,cobj)
      call grgrad_gridpoint_4th_type0(p6fyu,dfyudx,dfyudy,dfyudz,&
      &                                     irg,itg,ipg,cobj)
      call grgrad_gridpoint_4th_type0(p6fzu,dfzudx,dfzudy,dfzudz,&
      &                                     irg,itg,ipg,cobj)
! jt 
      jtu(irg,itg,ipg) = pi4invR2*alps6inv*(dfxudx + dfyudy +dfzudz)
! modify jphi 
      if (irg.eq.0.or.itg.eq.0) then 
        jphiu = 0.0d0 
      else 
        jphiu = jyu(irg,itg,ipg)/vecphi(2) - MHDfnc_dAt*jtu(irg,itg,ipg)
      end if
! jy 
      jyu(irg,itg,ipg) = jphiu*vecphi(2)
! no wind
      if (rg(irg).gt.rs(itg,ipg)) then 
        jtu(irg,itg,ipg) = 0.0d0
        jyu(irg,itg,ipg) = 0.0d0
      end if
!
    end do
  end do
!
! Copy to phi /= 0 planes.
!
  do ipg = 0, npg
    do itg = 0, ntg
      do irg = 0, nrg
        jtu(irg,itg,ipg) = jtu(irg,itg,0)
        jxu(irg,itg,ipg) = cosphig(ipg)*jxu(irg,itg,0) &
        &                - sinphig(ipg)*jyu(irg,itg,0)
        jyu(irg,itg,ipg) = sinphig(ipg)*jxu(irg,itg,0) &
        &                + cosphig(ipg)*jyu(irg,itg,0)
        jzu(irg,itg,ipg) = jzu(irg,itg,0)
! no wind
      if (rg(irg).gt.rs(itg,ipg)) then 
        jtu(irg,itg,ipg) = 0.0d0
        jxu(irg,itg,ipg) = 0.0d0
        jyu(irg,itg,ipg) = 0.0d0
        jzu(irg,itg,ipg) = 0.0d0
      end if
!
      end do
    end do
  end do
!
  deallocate(vaphid)
  deallocate(va_mod)
  deallocate(alva_mod)
  deallocate(fxd_grid_mod)
  deallocate(fyd_grid_mod)
  deallocate(fzd_grid_mod)
  deallocate(p6fxu)
  deallocate(p6fyu)
  deallocate(p6fzu)
!
end subroutine current_modify_MHD
