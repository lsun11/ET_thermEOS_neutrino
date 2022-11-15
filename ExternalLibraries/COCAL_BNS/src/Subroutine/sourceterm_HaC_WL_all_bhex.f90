subroutine sourceterm_HaC_WL_all_bhex(sou)
  use phys_constant, only : pi, long
  use def_metric, only : psi, tfkijkij, trk, dtrk
  use grid_parameter, only : nrg, ntg, npg
  use def_gamma_crist, only : gmcrix, gmcriy, gmcriz
  use def_ricci_tensor, only : rab
  use def_metric_hij, only : hxxu, hxyu, hxzu, hyyu, hyzu, hzzu
  use make_array_1d
  use make_array_2d
  use make_array_3d
  use interface_interpo_linear_type0
  use interface_grgrad_midpoint
!  use interface_dadbscalar_type0
  use interface_dadbscalar_type3
  implicit none
!
  real(long), pointer :: sou(:,:,:)
  real(long), pointer :: grad(:), dfdx(:,:,:), dfdy(:,:,:), dfdz(:,:,:)
  real(long), pointer :: dabfnc(:,:)
  real(long) :: aijaij, gcdp, hd2p, hhgc, &
  &          psigc, rics, &
  &          rxx, rxy, rxz, ryx, ryy, ryz, rzx, rzy, rzz, &
  &          utgc, zfac, fac23, tk, psi5, &
  &          gmxxu, gmxyu, gmxzu, gmyyu, gmyzu, gmzzu, gmyxu, gmzxu, gmzyu, &
  &          hhxxu, hhxyu, hhxzu, hhyyu, hhyzu, hhzzu, hhyxu, hhzxu, hhzyu
  integer :: ipg, irg, itg
!
  call alloc_array1d(grad,1,3)
  call alloc_array2d(dabfnc,1,3,1,3)
  call alloc_array3d(dfdx,1,nrg,1,ntg,1,npg)
  call alloc_array3d(dfdy,1,nrg,1,ntg,1,npg)
  call alloc_array3d(dfdz,1,nrg,1,ntg,1,npg)
!
! --- Source for computing the conformal factor psi.
!
  call grgrad_midpoint(psi,dfdx,dfdy,dfdz)
!  grad(1:nrg,1:ntg,1:npg,1) = dfdx(1:nrg,1:ntg,1:npg)
!  grad(1:nrg,1:ntg,1:npg,2) = dfdy(1:nrg,1:ntg,1:npg)
!  grad(1:nrg,1:ntg,1:npg,3) = dfdz(1:nrg,1:ntg,1:npg)
!
  fac23 = 2.0d0/3.0d0

  do ipg = 1, npg
    do itg = 1, ntg
      do irg = 1, nrg
!
        call interpo_linear_type0(psigc, psi,irg,itg,ipg)
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
! --    Skip for IWM.
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
!        call dadbscalar_type0(psi,dabfnc,irg,itg,ipg)
        call dadbscalar_type3_bhex(psi,dabfnc,irg,itg,ipg)
        hd2p = hhxxu* dabfnc(1,1) &
        &    + hhxyu*(dabfnc(1,2) + dabfnc(2,1)) &
        &    + hhxzu*(dabfnc(1,3) + dabfnc(3,1)) &
        &    + hhyyu* dabfnc(2,2) &
        &    + hhyzu*(dabfnc(2,3) + dabfnc(3,2)) &
        &    + hhzzu* dabfnc(3,3)
!

        sou(irg,itg,ipg) = - hd2p + gcdp + 0.125d0*psigc*rics - &
                         &   0.125d0*psi5*(aijaij - fac23*tk*tk)
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
end subroutine sourceterm_HaC_WL_all_bhex
