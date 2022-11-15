subroutine sourceterm_MoC_CF(souvec)
  use phys_constant, only : long
  use grid_parameter, only : nrg, ntg, npg
  use def_metric, only : psi, alph, tfkij
  use make_array_3d
  use interface_grgrad_midpoint
  use interface_interpo_linear_type0
  implicit none
  real(long), pointer :: souvec(:,:,:,:)
  real(long), pointer :: fnc2(:,:,:)
  real(long), pointer :: grad2x(:,:,:), grad2y(:,:,:), grad2z(:,:,:)
  real(long) :: san, san2
  real(long) :: alpgc, fnc2gc, afnc2inv, dxafn, dyafn, dzafn
  real(long) :: tfkax, tfkay, tfkaz
  integer :: ii, irg, itg, ipg
!
  call alloc_array3d(fnc2,0,nrg,0,ntg,0,npg)
  call alloc_array3d(grad2x,1,nrg,1,ntg,1,npg)
  call alloc_array3d(grad2y,1,nrg,1,ntg,1,npg)
  call alloc_array3d(grad2z,1,nrg,1,ntg,1,npg)
!
  san = 1.0d0/3.0d0
  san2= 2.0d0/3.0d0
!
! --- Source terms of Momentum constraint 
! --- for computing shift.  
!
  do ipg = 0, npg
    do itg = 0, ntg
      do irg = 0, nrg
        fnc2(irg,itg,ipg) = psi(irg,itg,ipg)**6/alph(irg,itg,ipg)
      end do
    end do
  end do
!
  call grgrad_midpoint(fnc2,grad2x,grad2y,grad2z)
!
  do ii = 1, 3
    do ipg = 1, npg
      do itg = 1, ntg
        do irg = 1, nrg
          call interpo_linear_type0(alpgc,alph,irg,itg,ipg)
          call interpo_linear_type0(fnc2gc,fnc2,irg,itg,ipg)
          afnc2inv = alpgc/fnc2gc
          dxafn = grad2x(irg,itg,ipg)
          dyafn = grad2y(irg,itg,ipg)
          dzafn = grad2z(irg,itg,ipg)
          tfkax  = tfkij(irg,itg,ipg,ii,1)
          tfkay  = tfkij(irg,itg,ipg,ii,2)
          tfkaz  = tfkij(irg,itg,ipg,ii,3)
!
          souvec(irg,itg,ipg,ii) = - 2.0d0*afnc2inv &
                 &   *(tfkax*dxafn + tfkay*dyafn + tfkaz*dzafn)
        end do
      end do
    end do
  end do     
!
  deallocate(fnc2)
  deallocate(grad2x)
  deallocate(grad2y)
  deallocate(grad2z)
end subroutine sourceterm_MoC_CF
