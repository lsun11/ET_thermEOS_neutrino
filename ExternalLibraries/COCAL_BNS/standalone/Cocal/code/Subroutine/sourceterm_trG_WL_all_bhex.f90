subroutine sourceterm_trG_WL_all_bhex(sou)
  use phys_constant, only : pi, long
  use def_metric, only : psi, alph, alps, tfkijkij, trk, &
         &               dtrk, bvxu, bvyu, bvzu
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
  real(long) :: aijaij, alpgc, psigc, alpsigc, gcdp, hd2p, rics, &
  &          rxx, rxy, rxz, ryx, ryy, ryz, rzx, rzy, rzz, fac512, tk, psi5, &
  &          gmxxu, gmxyu, gmxzu, gmyyu, gmyzu, gmzzu, gmyxu, gmzxu, gmzyu, &
  &          hhxxu, hhxyu, hhxzu, hhyyu, hhyzu, hhzzu, hhyxu, hhzxu, hhzyu, &
  &          bvxgc, bvygc, bvzgc, lie_beta_trk
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
        call interpo_linear_type0(bvxgc,bvxu,irg,itg,ipg)
        call interpo_linear_type0(bvygc,bvyu,irg,itg,ipg)
        call interpo_linear_type0(bvzgc,bvzu,irg,itg,ipg)

        call interpo_linear_type0(alpsigc,alps,irg,itg,ipg)
        call interpo_linear_type0(psigc,psi,irg,itg,ipg)
        call interpo_linear_type0(alpgc,alph,irg,itg,ipg)
        aijaij = tfkijkij(irg,itg,ipg)
        tk     = trk(irg,itg,ipg)
        psi5   = psigc*psigc*psigc*psigc*psigc
!
        call interpo_linear_type0(hhxxu,hxxu,irg,itg,ipg)
        call interpo_linear_type0(hhxyu,hxyu,irg,itg,ipg)
        call interpo_linear_type0(hhxzu,hxzu,irg,itg,ipg)
        call interpo_linear_type0(hhyyu,hyyu,irg,itg,ipg)
        call interpo_linear_type0(hhyzu,hyzu,irg,itg,ipg)
        call interpo_linear_type0(hhzzu,hzzu,irg,itg,ipg)
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
        lie_beta_trk = bvxgc*dtrk(irg,itg,ipg,1) + bvygc*dtrk(irg,itg,ipg,2) + &
             &         bvzgc*dtrk(irg,itg,ipg,3)

        sou(irg,itg,ipg) = - hd2p + gcdp + 0.125d0*alpsigc*rics + &
                         &   alpgc*psi5*(0.875d0*aijaij + fac512*tk*tk) + &
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

