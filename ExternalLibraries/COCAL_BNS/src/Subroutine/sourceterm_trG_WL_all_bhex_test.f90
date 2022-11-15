subroutine sourceterm_trG_WL_all_bhex(sou)
  use phys_constant, only : pi, long
  use def_metric
  use grid_parameter, only : nrg, ntg, npg
  use def_gamma_crist, only : gmcrix, gmcriy, gmcriz
  use def_ricci_tensor, only : rab
  use def_metric_hij, only : hxxu, hxyu, hxzu, hyyu, hyzu, hzzu
  use interface_interpo_linear_type0
  use interface_grgrad_midpoint
!  use interface_dadbscalar_type0
  use interface_dadbscalar_type3
  use make_array_1d
  use make_array_2d
  use make_array_3d
  implicit none
!
  real(long), pointer :: sou(:,:,:)
  real(long), pointer :: grad(:), dfdx(:,:,:), dfdy(:,:,:), dfdz(:,:,:)
  real(long), pointer :: dabfnc(:,:)
  real(long) :: aijaij,  alpsigc, gcdp, hd2p, rics, &
  &          rxx, rxy, rxz, ryx, ryy, ryz, rzx, rzy, rzz, fac512, tk, psi5, &
  &          gmxxu, gmxyu, gmxzu, gmyyu, gmyzu, gmzzu, gmyxu, gmzxu, gmzyu, &
  &          hhxxu, hhxyu, hhxzu, hhyyu, hhyzu, hhzzu, hhyxu, hhzxu, hhzyu, &
  &          bvxum, bvyum, bvzum, lie_beta_trk,  &
  &          ps4oal2, bbxx, bbxy, bbxz, bbyy, bbyz, bbzz, psim, alphm
  integer :: ipg, irg, itg
!
  call alloc_array1d(grad,1,3)
  call alloc_array2d(dabfnc,1,3,1,3)
  call alloc_array3d(dfdx,1,nrg,1,ntg,1,npg)
  call alloc_array3d(dfdy,1,nrg,1,ntg,1,npg)
  call alloc_array3d(dfdz,1,nrg,1,ntg,1,npg)
!
! --- Source for computing the alpha*psi.
!
  call grgrad_midpoint(alps,dfdx,dfdy,dfdz)
!  grad(1:nrg,1:ntg,1:npg,1) = dfdx(1:nrg,1:ntg,1:npg)
!  grad(1:nrg,1:ntg,1:npg,2) = dfdy(1:nrg,1:ntg,1:npg)
!  grad(1:nrg,1:ntg,1:npg,3) = dfdz(1:nrg,1:ntg,1:npg)
!
  fac512 = 5.0d0/12.0d0

  do ipg = 1, npg
    do itg = 1, ntg
      do irg = 1, nrg
!
        call interpo_linear_type0(psim, psi, irg,itg,ipg)
        call interpo_linear_type0(alphm,alph,irg,itg,ipg)
        call interpo_linear_type0(bvxum,bvxu,irg,itg,ipg)
        call interpo_linear_type0(bvyum,bvyu,irg,itg,ipg)
        call interpo_linear_type0(bvzum,bvzu,irg,itg,ipg)
        call interpo_linear_type0(alpsigc,alps,irg,itg,ipg)
        aijaij = tfkijkij(irg,itg,ipg)
        tk     = trk(irg,itg,ipg)
        psi5   = psim*psim*psim*psim*psim
!
        ps4oal2 = psim**4/alphm**2
        bbxx = ps4oal2*bvxum*bvxum
        bbxy = ps4oal2*bvxum*bvyum
        bbxz = ps4oal2*bvxum*bvzum
        bbyy = ps4oal2*bvyum*bvyum
        bbyz = ps4oal2*bvyum*bvzum
        bbzz = ps4oal2*bvzum*bvzum

        call interpo_linear_type0(hhxxu,hxxu,irg,itg,ipg)
        call interpo_linear_type0(hhxyu,hxyu,irg,itg,ipg)
        call interpo_linear_type0(hhxzu,hxzu,irg,itg,ipg)
        call interpo_linear_type0(hhyyu,hyyu,irg,itg,ipg)
        call interpo_linear_type0(hhyzu,hyzu,irg,itg,ipg)
        call interpo_linear_type0(hhzzu,hzzu,irg,itg,ipg)

        hhxxu = hhxxu + bbxx
        hhxyu = hhxyu + bbxy
        hhxzu = hhxzu + bbxz
        hhyyu = hhyyu + bbyy
        hhyzu = hhyzu + bbyz
        hhzzu = hhzzu + bbzz

        gmxxu = hhxxu + 1.0d0
        gmxyu = hhxyu
        gmxzu = hhxzu
        gmyyu = hhyyu + 1.0d0
        gmyzu = hhyzu
        gmzzu = hhzzu + 1.0d0
        gmyxu = hhxyu
        gmzxu = hhxzu
        gmzyu = hhyzu
!
        rxx = rab(irg,itg,ipg,1)
        rxy = rab(irg,itg,ipg,2)
        rxz = rab(irg,itg,ipg,3)
        ryy = rab(irg,itg,ipg,4)
        ryz = rab(irg,itg,ipg,5)
        rzz = rab(irg,itg,ipg,6)
        ryx = rxy 
        rzx = rxz
        rzy = ryz
!
        rics = 0.0d0
        gcdp = 0.0d0
        hd2p = 0.0d0
!
        rics = gmxxu*rxx + gmxyu*rxy + gmxzu*rxz &
        &    + gmyxu*ryx + gmyyu*ryy + gmyzu*ryz &
        &    + gmzxu*rzx + gmzyu*rzy + gmzzu*rzz 
!
        grad(1) = dfdx(irg,itg,ipg)
        grad(2) = dfdy(irg,itg,ipg)
        grad(3) = dfdz(irg,itg,ipg)

        gcdp = gmcrix(irg,itg,ipg)*grad(1) &
        &    + gmcriy(irg,itg,ipg)*grad(2) &
        &    + gmcriz(irg,itg,ipg)*grad(3)
!
!        call dadbscalar_type0(alps,dabfnc,irg,itg,ipg)
        call dadbscalar_type3_bhex(alps,dabfnc,irg,itg,ipg)
        hd2p = hhxxu* dabfnc(1,1) &
        &    + hhxyu*(dabfnc(1,2) + dabfnc(2,1)) &
        &    + hhxzu*(dabfnc(1,3) + dabfnc(3,1)) &
        &    + hhyyu* dabfnc(2,2) &
        &    + hhyzu*(dabfnc(2,3) + dabfnc(3,2)) &
        &    + hhzzu* dabfnc(3,3)
!
        lie_beta_trk = bvxum*dtrk(irg,itg,ipg,1) + bvyum*dtrk(irg,itg,ipg,2) + &
             &         bvzum*dtrk(irg,itg,ipg,3)

        sou(irg,itg,ipg) = - hd2p + gcdp + 0.125d0*alpsigc*rics + &
                         &   alphm*psi5*(0.875d0*aijaij + fac512*tk*tk) + &
                         &   psi5*lie_beta_trk
!
      end do
    end do
  end do
!
  deallocate(dabfnc)
  deallocate(grad)
  deallocate(dfdx)
  deallocate(dfdy)
  deallocate(dfdz)
!
end subroutine sourceterm_trG_WL_all_bhex

