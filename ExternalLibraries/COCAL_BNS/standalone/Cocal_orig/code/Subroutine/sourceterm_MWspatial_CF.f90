subroutine sourceterm_MWspatial_CF(souvec)
  use phys_constant, only : long
  use grid_parameter, only : nrg, ntg, npg
  use def_metric, only : psi, alph, tfkij
  use def_emfield, only : vaxu, vayu, vazu
  use def_faraday_tensor, only : fxd, fyd, fzd, fijd, &
  &                              Lie_bFxd, Lie_bFyd, Lie_bFzd
  use make_array_3d
  use interface_interpo_linear_type0
  use interface_grgrad_midpoint
  use interface_dadbscalar_type0
  use interface_dadbscalar_type3
  implicit none
  real(long), pointer :: souvec(:,:,:,:)
  real(long), pointer :: fnc2(:,:,:)
  real(long), pointer :: grad2x(:,:,:), grad2y(:,:,:), grad2z(:,:,:)
  real(long) :: san, san2
  real(long) :: psigc, alphgc
  real(long) :: tfkax, tfkay, tfkaz, traceK
  real(long) :: p4dival, psi4gc, p2dival, dxalps2, dyalps2, dzalps2
  real(long) :: fidgc(3), fijdgc(3,3), Lie_bFdgc(3)
  real(long) :: dadbA(3,3,3), dabAx(3,3), dabAy(3,3), dabAz(3,3)
  real(long) :: Fapdap, p4aLieF, psiAF, p4trKF, d2A
  integer :: ii, irg, itg, ipg
!
! --- Source terms for Maxwell eq spatial components
! --- Conforma flat terms.
!
  san = 1.0d0/3.0d0
  call alloc_array3d(fnc2,0,nrg,0,ntg,0,npg)
  call alloc_array3d(grad2x,1,nrg,1,ntg,1,npg)
  call alloc_array3d(grad2y,1,nrg,1,ntg,1,npg)
  call alloc_array3d(grad2z,1,nrg,1,ntg,1,npg)
  fnc2(0:nrg,0:ntg,0:npg) = alph(0:nrg,0:ntg,0:npg)/psi(0:nrg,0:ntg,0:npg)**2
  call grgrad_midpoint(fnc2,grad2x,grad2y,grad2z)
!
  do ii = 1, 3
    do ipg = 1, npg
      do itg = 1, ntg
        do irg = 1, nrg
          call interpo_linear_type0(alphgc,alph,irg,itg,ipg)
          call interpo_linear_type0(psigc,psi,irg,itg,ipg)
          p4dival = psigc**4/alphgc
          psi4gc  = psigc**4
          p2dival = psigc**2/alphgc
          dxalps2 = grad2x(irg,itg,ipg)
          dyalps2 = grad2y(irg,itg,ipg)
          dzalps2 = grad2z(irg,itg,ipg)
          fijdgc(1,1) = 0.0d0 ; fijdgc(2,2) = 0.0d0 ; fijdgc(3,3) = 0.0d0
          fijdgc(1,2) = fijd(irg,itg,ipg,1) ; fijdgc(2,1) = - fijdgc(1,2)
          fijdgc(1,3) = fijd(irg,itg,ipg,2) ; fijdgc(3,1) = - fijdgc(1,3)
          fijdgc(2,3) = fijd(irg,itg,ipg,3) ; fijdgc(3,2) = - fijdgc(2,3)
          Lie_bFdgc(1) = Lie_bFxd(irg,itg,ipg)
          Lie_bFdgc(2) = Lie_bFyd(irg,itg,ipg)
          Lie_bFdgc(3) = Lie_bFzd(irg,itg,ipg)
          fidgc(1) = fxd(irg,itg,ipg)  ! midpoint
          fidgc(2) = fyd(irg,itg,ipg)  ! midpoint
          fidgc(3) = fzd(irg,itg,ipg)  ! midpoint
          tfkax  = tfkij(irg,itg,ipg,ii,1)
          tfkay  = tfkij(irg,itg,ipg,ii,2)
          tfkaz  = tfkij(irg,itg,ipg,ii,3)
          traceK = 0.0d0
!          call dadbscalar_type0(vaxu,dabAx,irg,itg,ipg)
!          call dadbscalar_type0(vayu,dabAy,irg,itg,ipg)
!          call dadbscalar_type0(vazu,dabAz,irg,itg,ipg)
!
!$omp parallel sections num_threads(3)
!$omp section
          call dadbscalar_type3(vaxu,dabAx,irg,itg,ipg)
!$omp section
          call dadbscalar_type3(vayu,dabAy,irg,itg,ipg)
!$omp section
          call dadbscalar_type3(vazu,dabAz,irg,itg,ipg)
!$omp end parallel sections
!
          dadbA(1:3,1:3,1) = dabAx(1:3,1:3)
          dadbA(1:3,1:3,2) = dabAy(1:3,1:3)
          dadbA(1:3,1:3,3) = dabAz(1:3,1:3)
!! d2A might be 0 for our gauge
          d2A = dadbA(ii,1,1) + dadbA(ii,2,2) + dadbA(ii,3,3) 
          Fapdap = p2dival*(fijdgc(ii,1)*dxalps2 + fijdgc(ii,2)*dyalps2 &
          &               + fijdgc(ii,3)*dzalps2)
          p4aLieF = p4dival*Lie_bFdgc(ii)
          psiAF = 2.0d0*psi4gc*(tfkax*fidgc(1)+tfkay*fidgc(2)+tfkaz*fidgc(3))
          p4trKF= san*psi4gc*traceK*fidgc(ii)
!
          souvec(irg,itg,ipg,ii) = d2A + Fapdap + p4aLieF - psiAF + p4trKF
!
        end do
      end do
    end do
  end do     
!
  deallocate(fnc2)
  deallocate(grad2x)
  deallocate(grad2y)
  deallocate(grad2z)
end subroutine sourceterm_MWspatial_CF
