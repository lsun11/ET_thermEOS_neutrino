subroutine sourceterm_MWtemp_WL(sou)
  use def_metric, only : psi
  use grid_parameter, only : nrg, ntg, npg
  use def_gamma_crist, only : gmcrix, gmcriy, gmcriz
  use def_metric, only : psi, alph
  use def_metric_hij, only : hxxu, hxyu, hxzu, hyyu, hyzu, hzzu
  use def_metric_hij_dirac, only : dagmabu
  use def_emfield, only : alva
  use def_emfield_derivatives, only : Lie_bAxd, Lie_bAyd, Lie_bAzd, &
  &                              Lie_bAxd_grid, Lie_bAyd_grid, Lie_bAzd_grid
  use def_faraday_tensor, only : fxd, fyd, fzd
  use make_array_4d
  use make_array_3d
  use interface_interpo_linear_type0
  use interface_grgrad_midpoint
  use interface_dadbscalar_type0
  use interface_dadbscalar_type3
  implicit none
!
  real(long), pointer :: sou(:,:,:)
  real(long), pointer :: fnc2(:,:,:)
  real(long), pointer :: grad2x(:,:,:), grad2y(:,:,:), grad2z(:,:,:)
  real(long), pointer :: dxLbAx(:,:,:), dyLbAx(:,:,:), dzLbAx(:,:,:)
  real(long), pointer :: dxLbAy(:,:,:), dyLbAy(:,:,:), dzLbAy(:,:,:)
  real(long), pointer :: dxLbAz(:,:,:), dyLbAz(:,:,:), dzLbAz(:,:,:)
  real(long), pointer ::   dfdx(:,:,:),   dfdy(:,:,:),   dfdz(:,:,:)
  real(long) :: hiju(3,3), dabfnc(3,3), dpafa(3,3), dLbAgc(3,3)
  real(long) :: psigc, alphgc, a2divp2, dxalva, dyalva, dzalva, &
  &             Lie_bAxdgc, Lie_bAydgc, Lie_bAzdgc, &
  &             diracx, diracy, diracz, zfac, &
  &             hd2va, diracdva, dps2alfa, diracLieA, trdLieA, &
  &          gmxxu, gmxyu, gmxzu, gmyyu, gmyzu, gmzzu, gmyxu, gmzxu, gmzyu, &
  &          hhxxu, hhxyu, hhxzu, hhyyu, hhyzu, hhzzu, hhyxu, hhzxu, hhzyu
  integer :: ipg, irg, itg
!
! --- Source for Maxwell eq normal component
! --  Waveless terms. Skip for IWM.
!
  call alloc_array3d(dfdx,1,nrg,1,ntg,1,npg)
  call alloc_array3d(dfdy,1,nrg,1,ntg,1,npg)
  call alloc_array3d(dfdz,1,nrg,1,ntg,1,npg)
  call alloc_array3d(fnc2,0,nrg,0,ntg,0,npg)
  call alloc_array3d(grad2x,1,nrg,1,ntg,1,npg)
  call alloc_array3d(grad2y,1,nrg,1,ntg,1,npg)
  call alloc_array3d(grad2z,1,nrg,1,ntg,1,npg)
  call alloc_array3d(dxLbAx,1,nrg,1,ntg,1,npg)
  call alloc_array3d(dyLbAx,1,nrg,1,ntg,1,npg)
  call alloc_array3d(dzLbAx,1,nrg,1,ntg,1,npg)
  call alloc_array3d(dxLbAy,1,nrg,1,ntg,1,npg)
  call alloc_array3d(dyLbAy,1,nrg,1,ntg,1,npg)
  call alloc_array3d(dzLbAy,1,nrg,1,ntg,1,npg)
  call alloc_array3d(dxLbAz,1,nrg,1,ntg,1,npg)
  call alloc_array3d(dyLbAz,1,nrg,1,ntg,1,npg)
  call alloc_array3d(dzLbAz,1,nrg,1,ntg,1,npg)
  fnc2(0:nrg,0:ntg,0:npg) = psi(0:nrg,0:ntg,0:npg)**2/alph(0:nrg,0:ntg,0:npg)
  call grgrad_midpoint(fnc2,grad2x,grad2y,grad2z)
  call grgrad_midpoint(Lie_bAxd_grid,dxLbAx,dyLbAx,dzLbAx)
  call grgrad_midpoint(Lie_bAyd_grid,dxLbAy,dyLbAy,dzLbAy)
  call grgrad_midpoint(Lie_bAzd_grid,dxLbAz,dyLbAz,dzLbAz)
  call grgrad_midpoint(alva,dfdx,dfdy,dfdz)
!
  do ipg = 1, npg
    do itg = 1, ntg
      do irg = 1, nrg
!
        call interpo_linear_type0(psigc, psi,irg,itg,ipg)
        call interpo_linear_type0(alphgc,alph,irg,itg,ipg)
        call interpo_linear_type0(hhxxu,hxxu,irg,itg,ipg)
        call interpo_linear_type0(hhxyu,hxyu,irg,itg,ipg)
        call interpo_linear_type0(hhxzu,hxzu,irg,itg,ipg)
        call interpo_linear_type0(hhyyu,hyyu,irg,itg,ipg)
        call interpo_linear_type0(hhyzu,hyzu,irg,itg,ipg)
        call interpo_linear_type0(hhzzu,hzzu,irg,itg,ipg)
        hiju(1,1) = hhxxu ; hiju(1,2) = hhxyu ; hiju(1,3) = hhxzu
        hiju(2,1) = hhxyu ; hiju(2,2) = hhyyu ; hiju(2,3) = hhyzu
        hiju(3,1) = hhxzu ; hiju(3,2) = hhyzu ; hiju(3,3) = hhzzu
        gmxxu = hhxxu + 1.0d0
        gmyyu = hhyyu + 1.0d0
        gmzzu = hhzzu + 1.0d0
        gmyxu = hhxyu
        gmzxu = hhxzu
        gmzyu = hhyzu
        a2divp2 = alphgc**2/psigc**2
        dxalva = dfdx(irg,itg,ipg)
        dyalva = dfdy(irg,itg,ipg)
        dzalva = dfdz(irg,itg,ipg)
        Lie_bAxdgc = Lie_bAxd(irg,itg,ipg)
        Lie_bAydgc = Lie_bAyd(irg,itg,ipg)
        Lie_bAzdgc = Lie_bAzd(irg,itg,ipg)
        diracx = dagmabu(irg,itg,ipg,1)
        diracy = dagmabu(irg,itg,ipg,2)
        diracz = dagmabu(irg,itg,ipg,3)
!
        dpafa(1,1) = grad2x(irg,itg,ipg)*fxd(irg,itg,ipg)
        dpafa(1,2) = grad2x(irg,itg,ipg)*fyd(irg,itg,ipg)
        dpafa(1,3) = grad2x(irg,itg,ipg)*fzd(irg,itg,ipg)
        dpafa(2,1) = grad2y(irg,itg,ipg)*fxd(irg,itg,ipg)
        dpafa(2,2) = grad2y(irg,itg,ipg)*fyd(irg,itg,ipg)
        dpafa(2,3) = grad2y(irg,itg,ipg)*fzd(irg,itg,ipg)
        dpafa(3,1) = grad2z(irg,itg,ipg)*fxd(irg,itg,ipg)
        dpafa(3,2) = grad2z(irg,itg,ipg)*fyd(irg,itg,ipg)
        dpafa(3,3) = grad2z(irg,itg,ipg)*fzd(irg,itg,ipg)
!
        dLbAgc(1,1) = dxLbAx(irg,itg,ipg)
        dLbAgc(1,2) = dyLbAx(irg,itg,ipg)
        dLbAgc(1,3) = dzLbAx(irg,itg,ipg)
        dLbAgc(2,1) = dxLbAy(irg,itg,ipg)
        dLbAgc(2,2) = dyLbAy(irg,itg,ipg)
        dLbAgc(2,3) = dzLbAy(irg,itg,ipg)
        dLbAgc(3,1) = dxLbAz(irg,itg,ipg)
        dLbAgc(3,2) = dyLbAz(irg,itg,ipg)
        dLbAgc(3,3) = dzLbAz(irg,itg,ipg)
!
        diracdva = diracx*dxalva + diracy*dyalva + diracz*dzalva
!!!        diracLieA= diracx*Lie_bAxdgc + diracy*Lie_bAydgc + diracz*Lie_bAzdgc
!        call dadbscalar_type0(alva,dabfnc,irg,itg,ipg)
        call dadbscalar_type3(alva,dabfnc,irg,itg,ipg)
        call compute_trace(hiju,dabfnc,hd2va)
        call compute_trace(hiju,dpafa,dps2alfa)
        dps2alfa = a2divp2*dps2alfa
        call compute_trace(hiju,dLbAgc,trdLieA)
!
        sou(irg,itg,ipg) = - hd2va - diracdva &
        &                + dps2alfa + trdLieA
!!!        &                + dps2alfa + diracLieA + trdLieA
!
      end do
    end do
  end do
!
  deallocate(dfdx)
  deallocate(dfdy)
  deallocate(dfdz)
  deallocate(fnc2)
  deallocate(grad2x)
  deallocate(grad2y)
  deallocate(grad2z)
  deallocate(dxLbAx)
  deallocate(dyLbAx)
  deallocate(dzLbAx)
  deallocate(dxLbAy)
  deallocate(dyLbAy)
  deallocate(dzLbAy)
  deallocate(dxLbAz)
  deallocate(dyLbAz)
  deallocate(dzLbAz)
!
end subroutine sourceterm_MWtemp_WL
