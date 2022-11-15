subroutine sourceterm_MoC_CF_with_divshift_r3rd(souvec)
  use phys_constant, only : long
  use grid_parameter, only : nrg, ntg, npg
  use def_metric
  use def_bh_parameter, only : ome_bh
  use make_array_3d
  use make_array_4d
  use interface_interpo_linear_type0
  use interface_grgrad_4th_gridpoint_bhex
  use interface_grgrad_midpoint_r3rd_nsbh
  use interface_grgrad_midpoint_r3rd_type0_bh
  use interface_dadbscalar_3rd2nd_type0
  use def_vector_phi, only : vec_phig
  implicit none
  real(long), pointer :: souvec(:,:,:,:), ddivBeta(:,:,:,:)
  real(long), pointer :: fnc2(:,:,:), divBeta(:,:,:)
  real(long), pointer :: grad2x(:,:,:), grad2y(:,:,:), grad2z(:,:,:)
  real(long) :: san, san2
  real(long) :: alpgc, psigc, fnc2gc, afnc2inv, dxafn, dyafn, dzafn
  real(long) :: ovxu, ovyu, ovzu
  real(long) :: tfkax, tfkay, tfkaz
  real(long) :: dbxdx,dbxdy,dbxdz, dbydx,dbydy,dbydz, dbzdx,dbzdy,dbzdz 
  real(long) :: d2bvx(3,3), d2bvy(3,3), d2bvz(3,3)
  integer :: ii, irg, itg, ipg, impt
!
  call alloc_array3d(fnc2,0,nrg,0,ntg,0,npg)
  call alloc_array3d(grad2x,1,nrg,1,ntg,1,npg)
  call alloc_array3d(grad2y,1,nrg,1,ntg,1,npg)
  call alloc_array3d(grad2z,1,nrg,1,ntg,1,npg)
  call alloc_array3d(divBeta,0,nrg,0,ntg,0,npg)
  call alloc_array4d(ddivBeta,1,nrg,1,ntg,1,npg,1,3)
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
! value inside of the companion BH causes a problem.
! value inside of the companion BH is set to zero in interpo_gr2gr_4th(_mpt)
        psigc = psi(irg,itg,ipg)
        alpgc = alph(irg,itg,ipg)
        if (alpgc.le.0.0d0) alpgc = 1.0d-20
        fnc2(irg,itg,ipg) = psi(irg,itg,ipg)**6/alpgc
        call grgrad_4th_gridpoint_bhex(bvxd,dbxdx,dbxdy,dbxdz,irg,itg,ipg)
        call grgrad_4th_gridpoint_bhex(bvyd,dbydx,dbydy,dbydz,irg,itg,ipg)
        call grgrad_4th_gridpoint_bhex(bvzd,dbzdx,dbzdy,dbzdz,irg,itg,ipg)
        divBeta(irg,itg,ipg) = dbxdx + dbydy + dbzdz
      end do
    end do
  end do
!
  call grgrad_midpoint_r3rd_nsbh(fnc2,grad2x,grad2y,grad2z,'bh')
!
  do ipg = 1, npg
    do itg = 1, ntg
      do irg = 1, nrg
        call grgrad_midpoint_r3rd_type0_bh(divBeta,dxafn,dyafn,dzafn,irg,itg,ipg)
        ddivBeta(irg,itg,ipg,1) = dxafn        
        ddivBeta(irg,itg,ipg,2) = dyafn
        ddivBeta(irg,itg,ipg,3) = dzafn
      end do
    end do
  end do
!
  do ii = 1, 3
    do ipg = 1, npg
      do itg = 1, ntg
        do irg = 1, nrg
          call interpo_linear_type0(alpgc,alph,irg,itg,ipg)
          call interpo_linear_type0(fnc2gc,fnc2,irg,itg,ipg)
          afnc2inv = alpgc/fnc2gc
!          call interpo_linear_type0(psigc,psi,irg,itg,ipg)
!          if (psigc.le.0.0d0) psigc = 3.0
!          afnc2inv = alpgc**2/psigc**6
          dxafn = grad2x(irg,itg,ipg)
          dyafn = grad2y(irg,itg,ipg)
          dzafn = grad2z(irg,itg,ipg)
          tfkax  = tfkij(irg,itg,ipg,ii,1)
          tfkay  = tfkij(irg,itg,ipg,ii,2)
          tfkaz  = tfkij(irg,itg,ipg,ii,3)
!
          souvec(irg,itg,ipg,ii) = - 2.0d0*afnc2inv &
                 &   *(tfkax*dxafn + tfkay*dyafn + tfkaz*dzafn) &
                 &   - san*ddivBeta(irg,itg,ipg,ii)
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
  deallocate(divBeta)
  deallocate(ddivBeta)

end subroutine sourceterm_MoC_CF_with_divshift_r3rd
