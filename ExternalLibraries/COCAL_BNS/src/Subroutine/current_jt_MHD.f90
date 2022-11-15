subroutine current_jt_MHD(cobj)
  use phys_constant, only  : long, pi
  use grid_parameter
  use coordinate_grav_r, only : rg
  use trigonometry_grav_phi, only   : sinphig, cosphig
  use def_metric, only : alph, psi
  use def_metric_hij, only : hxxu, hxyu, hxzu, hyyu, hyzu, hzzu
  use def_matter, only : rs
  use def_matter_parameter, only : radi, ome
  use def_emfield, only : va, vaxd, vayd, vazd, jtu, jtuf
  use def_emfield_derivatives, only : Lie_bAxd_grid, Lie_bAyd_grid, &
  &                                   Lie_bAzd_grid
  use def_vector_phi, only : vec_phig
  use integrability_fnc_MHD
  use make_array_3d
  use interface_interpo_gr2fl
  use interface_grgrad_gridpoint_4th_type0
  use interface_calc_integrability_modify_At
  use interface_calc_integrability_modify_Aphi
  implicit none
  real(long), pointer :: vaphid_mod(:,:,:), va_mod(:,:,:), alva_mod(:,:,:)
  real(long), pointer :: vaxd_mod(:,:,:), vayd_mod(:,:,:)
  real(long), pointer :: fxd_grid_mod(:,:,:), p2fxu(:,:,:)
  real(long), pointer :: fyd_grid_mod(:,:,:), p2fyu(:,:,:)
  real(long), pointer :: fzd_grid_mod(:,:,:), p2fzu(:,:,:)
  real(long) :: vecphi(3)
  real(long) :: dfxudx, dfxudy, dfxudz
  real(long) :: dfyudx, dfyudy, dfyudz
  real(long) :: dfzudx, dfzudy, dfzudz
  real(long) :: alps6inv, pi4invR2, jphiu, Aphi, jtu_eq
  real(long) :: dalvadxgp, dalvadygp, dalvadzgp
  real(long) :: lie_bAx, lie_bAy, lie_bAz, ainvh
  integer    :: irg, itg, ipg
  character(len=2), intent(in) :: cobj
!
  call alloc_array3d(vaphid_mod, 0, nrg, 0, ntg, 0, npg)
  call alloc_array3d(va_mod, 0, nrg, 0, ntg, 0, npg)
  call alloc_array3d(vaxd_mod, 0, nrg, 0, ntg, 0, npg)
  call alloc_array3d(vayd_mod, 0, nrg, 0, ntg, 0, npg)
  call alloc_array3d(alva_mod, 0, nrg, 0, ntg, 0, npg)
  call alloc_array3d(fxd_grid_mod, 0, nrg, 0, ntg, 0, npg)
  call alloc_array3d(fyd_grid_mod, 0, nrg, 0, ntg, 0, npg)
  call alloc_array3d(fzd_grid_mod, 0, nrg, 0, ntg, 0, npg)
  call alloc_array3d(p2fxu, 0, nrg, 0, ntg, 0, npg)
  call alloc_array3d(p2fyu, 0, nrg, 0, ntg, 0, npg)
  call alloc_array3d(p2fzu, 0, nrg, 0, ntg, 0, npg)
!
  va_mod(  0:nrg,0:ntg,0:npg)=va(  0:nrg,0:ntg,0:npg)
  vaxd_mod(0:nrg,0:ntg,0:npg)=vaxd(0:nrg,0:ntg,0:npg)
  vayd_mod(0:nrg,0:ntg,0:npg)=vayd(0:nrg,0:ntg,0:npg)
!
!!  call calc_integrability_modify_Aphi(vaxd_mod,vayd_mod,'ns')
!  call calc_integrability_modify_Aphi(vaxd_mod,vayd_mod,'gr')
!!  call calc_integrability_modify_At(va_mod,'ns')
  call calc_integrability_modify_At(va_mod,'gr')
  vaphid_mod(0:nrg,0:ntg,0:npg)= vayd_mod(0:nrg,0:ntg,0:npg) &
  &                            * vec_phig(0:nrg,0:ntg,0:npg,2)
  alva_mod(0:nrg,0:ntg,0:npg)  = alph(0:nrg,0:ntg,0:npg) &
  &                           *va_mod(0:nrg,0:ntg,0:npg)
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
  p2fxu(0:nrg,0:ntg,0:npg) = psi(0:nrg,0:ntg,0:npg)**2 &
  &  *((1.0d0 + hxxu(0:nrg,0:ntg,0:npg))*fxd_grid_mod(0:nrg,0:ntg,0:npg) &
  &           + hxyu(0:nrg,0:ntg,0:npg) *fyd_grid_mod(0:nrg,0:ntg,0:npg) &
  &           + hxzu(0:nrg,0:ntg,0:npg) *fzd_grid_mod(0:nrg,0:ntg,0:npg))
  p2fyu(0:nrg,0:ntg,0:npg) = psi(0:nrg,0:ntg,0:npg)**2 &
  &           *(hxyu(0:nrg,0:ntg,0:npg) *fxd_grid_mod(0:nrg,0:ntg,0:npg) &
  &  + (1.0d0 + hyyu(0:nrg,0:ntg,0:npg))*fyd_grid_mod(0:nrg,0:ntg,0:npg) &
  &           + hyzu(0:nrg,0:ntg,0:npg) *fzd_grid_mod(0:nrg,0:ntg,0:npg))
  p2fzu(0:nrg,0:ntg,0:npg) = psi(0:nrg,0:ntg,0:npg)**2 &
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
      Aphi = vaphid_mod(irg,itg,ipg)
      call calc_integrability_fnc_MHD(Aphi)
      call grgrad_gridpoint_4th_type0(p2fxu,dfxudx,dfxudy,dfxudz,&
      &                                     irg,itg,ipg,cobj)
      call grgrad_gridpoint_4th_type0(p2fyu,dfyudx,dfyudy,dfyudz,&
      &                                     irg,itg,ipg,cobj)
      call grgrad_gridpoint_4th_type0(p2fzu,dfzudx,dfzudy,dfzudz,&
      &                                     irg,itg,ipg,cobj)
! jt : calculated also out of surface for smoothness
      jtu(irg,itg,ipg) = pi4invR2*alps6inv*(dfxudx + dfyudy +dfzudz)
!
    end do
  end do
!
! Copy to phi /= 0 planes.
!
  do ipg = 1, npg
    do itg = 0, ntg
      do irg = 0, nrg
        jtu(irg,itg,ipg) = jtu(irg,itg,0)
      end do
    end do
  end do
!
  call interpo_gr2fl(jtu,jtuf)
!
! Correction of jt to be 0 at equatorial surface
!
!  jtu_eq = jtuf(nrf,ntfeq,0)
!  jtu( 0:nrg,0:ntg,0:npg) = jtu( 0:nrg,0:ntg,0:npg) - jtu_eq
!  jtuf(0:nrf,0:ntf,0:npf) = jtuf(0:nrf,0:ntf,0:npf) - jtu_eq
!
! ---
!
  itg = ntgeq-2; ipg = 2
  call calc_integrability_modify_At(va_mod,'gr')
!  call calc_integrability_modify_Aphi(vaxd_mod,vayd_mod,'gr')
  open(15,file='test_vec_va_mod',status='unknown')
    do irg = 0, nrg
      write(15,'(1p,9e20.12)')  rg(irg),  va_mod(irg,itg,ipg)   &
          &                             , vaxd_mod(irg,itg,ipg) &
          &                             , vayd_mod(irg,itg,ipg) &
          &                             , jtu(irg,itg,ipg)
    end do
  close(15)
!
  deallocate(vaphid_mod)
  deallocate(va_mod)
  deallocate(alva_mod)
  deallocate(vaxd_mod)
  deallocate(vayd_mod)
  deallocate(fxd_grid_mod)
  deallocate(fyd_grid_mod)
  deallocate(fzd_grid_mod)
  deallocate(p2fxu)
  deallocate(p2fyu)
  deallocate(p2fzu)
!
end subroutine current_jt_MHD
