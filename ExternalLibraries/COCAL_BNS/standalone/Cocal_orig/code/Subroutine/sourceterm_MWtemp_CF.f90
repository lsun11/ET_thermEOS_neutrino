subroutine sourceterm_MWtemp_CF(sou)
  use phys_constant, only : long
  use grid_parameter, only : nrg, ntg, npg
  use def_metric, only : alph, psi
  use def_faraday_tensor, only : fxd, fyd, fzd
  use def_emfield_derivatives, only : Lie_bAxd_grid, Lie_bAyd_grid, &
  &                                   Lie_bAzd_grid
  use interface_interpo_linear_type0
  use interface_grgrad_midpoint
  use make_array_3d
  implicit none
  real(long), pointer :: sou(:,:,:)
  real(long), pointer :: fnc2(:,:,:)
  real(long), pointer :: grad2x(:,:,:), grad2y(:,:,:), grad2z(:,:,:)
  real(long), pointer :: dxLbAx(:,:,:), dyLbAx(:,:,:), dzLbAx(:,:,:)
  real(long), pointer :: dxLbAy(:,:,:), dyLbAy(:,:,:), dzLbAy(:,:,:)
  real(long), pointer :: dxLbAz(:,:,:), dyLbAz(:,:,:), dzLbAz(:,:,:)
  real(long) :: psigc, alphgc, a2divp2, dxLbAxgc, dyLbAygc, dzLbAzgc
  real(long) :: fxdgc, fydgc, fzdgc
  real(long) :: dxps2al, dyps2al, dzps2al, dps2alfa
  integer    :: irg, itg, ipg
!
! --- Source for Maxwell eq normal component
! --  conformal flat terms. 
!
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
!
  do ipg = 1, npg
    do itg = 1, ntg
      do irg = 1, nrg
        call interpo_linear_type0(psigc,psi,irg,itg,ipg)
        call interpo_linear_type0(alphgc,alph,irg,itg,ipg)
        a2divp2 = alphgc**2/psigc**2
        dxps2al = grad2x(irg,itg,ipg)
        dyps2al = grad2y(irg,itg,ipg)
        dzps2al = grad2z(irg,itg,ipg)
        fxdgc = fxd(irg,itg,ipg)
        fydgc = fyd(irg,itg,ipg)
        fzdgc = fzd(irg,itg,ipg)
        dxLbAxgc = dxLbAx(irg,itg,ipg)
        dyLbAygc = dyLbAy(irg,itg,ipg)
        dzLbAzgc = dzLbAz(irg,itg,ipg)
!
        dps2alfa = a2divp2*(dxps2al*fxdgc+dyps2al*fydgc+dzps2al*fzdgc)
!
        sou(irg,itg,ipg) = dps2alfa + dxLbAxgc + dyLbAygc + dzLbAzgc
!
      end do
    end do
  end do
!
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
end subroutine sourceterm_MWtemp_CF

