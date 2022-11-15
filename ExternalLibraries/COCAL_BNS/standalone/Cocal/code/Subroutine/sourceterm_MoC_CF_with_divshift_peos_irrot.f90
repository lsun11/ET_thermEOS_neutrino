subroutine sourceterm_MoC_CF_with_divshift_peos_irrot(souvec)
  use phys_constant, only : long, pi
  use grid_parameter, only : nrg, ntg, npg
  use def_metric
  use def_bh_parameter, only : ome_bh
  use def_matter, only : emdg, omeg, vepxg, vepyg, vepzg, jomeg_int
  use def_matter_parameter, only : ome, ber, radi
  use def_vector_x
  use def_vector_phi
  use make_array_3d
  use make_array_4d
  use interface_interpo_linear_type0
  use interface_grgrad_4th_gridpoint
  use interface_grgrad_midpoint_r3rd_nsbh
  use interface_grgrad_midpoint_r3rd_type0_ns
  use interface_dadbscalar_3rd2nd_type0
!  use def_vector_phi, only : vec_phig
  implicit none
  real(long), pointer :: souvec(:,:,:,:), ddivBeta(:,:,:,:)
  real(long), pointer :: fnc2(:,:,:), divBeta(:,:,:)
  real(long), pointer :: grad2x(:,:,:), grad2y(:,:,:), grad2z(:,:,:)
  real(long) :: vphig(3), san, san2,  ovdgc(3), lam
  real(long) :: emdgc, rhogc, pregc, hhgc, utgc, oterm, zfac, rjj
  real(long) :: psigc, alpgc, fnc2gc, afnc2inv, dxafn, dyafn, dzafn
  real(long) :: bvxdgc, bvydgc, bvzdgc, tfkax, tfkay, tfkaz, ene
  real(long) :: omegc, jomeg_intgc

  real(long) :: ovxu, ovyu, ovzu, vepxgc, vepygc, vepzgc
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
        call grgrad_4th_gridpoint(bvxd,dbxdx,dbxdy,dbxdz,irg,itg,ipg)
        call grgrad_4th_gridpoint(bvyd,dbydx,dbydy,dbydz,irg,itg,ipg)
        call grgrad_4th_gridpoint(bvzd,dbzdx,dbzdy,dbzdz,irg,itg,ipg)

        divBeta(irg,itg,ipg) = dbxdx + dbydy + dbzdz
!!!!        call grgrad_gridpoint_type0(psi,dxafn,dyafn,dzafn,irg,itg,ipg)
!!!!        ovxu = bvxd(irg,itg,ipg) + ome_bh*vec_phig(irg,itg,ipg,1)
!!!!        ovyu = bvyd(irg,itg,ipg) + ome_bh*vec_phig(irg,itg,ipg,2)
!!!!        ovzu = bvzd(irg,itg,ipg) + ome_bh*vec_phig(irg,itg,ipg,3)
!!!!        divBeta(irg,itg,ipg) = - 6.0d0/psigc &
!!!!        &                      * (ovxu*dxafn + ovyu*dyafn + ovzu*dzafn)
      end do
    end do
  end do
!
  call grgrad_midpoint_r3rd_nsbh(fnc2,grad2x,grad2y,grad2z,'ns')
!
  do ipg = 1, npg
    do itg = 1, ntg
      do irg = 1, nrg
        call grgrad_midpoint_r3rd_type0_ns(divBeta,dxafn,dyafn,dzafn,irg,itg,ipg)
        ddivBeta(irg,itg,ipg,1) = dxafn        
        ddivBeta(irg,itg,ipg,2) = dyafn
        ddivBeta(irg,itg,ipg,3) = dzafn
!!        call dadbscalar_3rd2nd_type0(bvxd,d2bvx,irg,itg,ipg,'bh')
!!        call dadbscalar_3rd2nd_type0(bvyd,d2bvy,irg,itg,ipg,'bh')
!!        call dadbscalar_3rd2nd_type0(bvzd,d2bvz,irg,itg,ipg,'bh')
!!        ddivBeta(irg,itg,ipg,1) = d2bvx(1,1) + d2bvy(1,2) + d2bvz(1,3)
!!        ddivBeta(irg,itg,ipg,2) = d2bvx(2,1) + d2bvy(2,2) + d2bvz(2,3)
!!        ddivBeta(irg,itg,ipg,3) = d2bvx(3,1) + d2bvy(3,2) + d2bvz(3,3)
      end do
    end do
  end do
!
  do ii = 1, 3
    do ipg = 1, npg
      do itg = 1, ntg
        do irg = 1, nrg
          call interpo_linear_type0(emdgc,emdg,irg,itg,ipg)
          call interpo_linear_type0(vepxgc ,vepxg ,irg,itg,ipg)
          call interpo_linear_type0(vepygc ,vepyg ,irg,itg,ipg)
          call interpo_linear_type0(vepzgc ,vepzg ,irg,itg,ipg)
          call interpo_linear_type0(omegc,omeg,irg,itg,ipg)
          call interpo_linear_type0(jomeg_intgc,jomeg_int,irg,itg,ipg)
          call interpo_linear_type0(psigc,psi,irg,itg,ipg)
          call interpo_linear_type0(alpgc,alph,irg,itg,ipg)
          call interpo_linear_type0(fnc2gc,fnc2,irg,itg,ipg)
          call interpo_linear_type0(bvxdgc,bvxd,irg,itg,ipg)
          call interpo_linear_type0(bvydgc,bvyd,irg,itg,ipg)
          call interpo_linear_type0(bvzdgc,bvzd,irg,itg,ipg)
          afnc2inv = alpgc/fnc2gc

          dxafn = grad2x(irg,itg,ipg)
          dyafn = grad2y(irg,itg,ipg)
          dzafn = grad2z(irg,itg,ipg)
          tfkax  = tfkij(irg,itg,ipg,ii,1)
          tfkay  = tfkij(irg,itg,ipg,ii,2)
          tfkaz  = tfkij(irg,itg,ipg,ii,3)
!
          zfac = 1.0d0
          if (emdgc <= 1.0d-15) then
            emdgc = 1.0d-15
            zfac  = 0.0d0
          end if
          call peos_q2hprho(emdgc, hhgc, pregc, rhogc, ene)
   
          vphig(1) = hvec_phig(irg,itg,ipg,1)
          vphig(2) = hvec_phig(irg,itg,ipg,2)
          vphig(3) = hvec_phig(irg,itg,ipg,3)

          ovdgc(1) = bvxdgc + ome*vphig(1)
          ovdgc(2) = bvydgc + ome*vphig(2)
          ovdgc(3) = bvzdgc + ome*vphig(3)

          lam      = ber + ovdgc(1)*vepxgc + ovdgc(2)*vepygc + ovdgc(3)*vepzgc
          utgc     = lam/hhgc/alpgc/alpgc

          oterm = 0.0d0
          if (ii == 1) oterm = vepxgc
          if (ii == 2) oterm = vepygc
          if (ii == 3) oterm = vepzgc
!
          rjj = rhogc*alpgc*utgc*oterm
!
          souvec(irg,itg,ipg,ii) = - 2.0d0*afnc2inv &
                 &   *(tfkax*dxafn + tfkay*dyafn + tfkaz*dzafn) &
                 &   - san*ddivBeta(irg,itg,ipg,ii)    &
                 &   + radi**2*16.0d0*pi*alpgc*rjj*zfac
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

end subroutine sourceterm_MoC_CF_with_divshift_peos_irrot
