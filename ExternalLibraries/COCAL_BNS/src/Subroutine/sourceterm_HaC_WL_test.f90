subroutine sourceterm_HaC_WL_test(sou)
  use def_metric, only : psi
  use grid_parameter, only : nrg, ntg, npg
  use def_gamma_crist, only : gmcrix, gmcriy, gmcriz
  use def_ricci_tensor, only : rab
  use def_metric_hij, only : hxxu, hxyu, hxzu, hyyu, hyzu, hzzu
  use make_array_5d
  use make_array_4d
  use make_array_3d
  use interface_interpo_linear_type0
  use interface_grgrad_midpoint
  use interface_dadbscalar_type2
  implicit none
!t   real(8) :: t0, t1, t2, t3, tm
!
  real(8), pointer :: sou(:,:,:)
  real(8), pointer :: grad(:,:,:,:), dfdx(:,:,:), dfdy(:,:,:), dfdz(:,:,:)
  real(8), pointer :: dadbfn(:,:,:,:,:)
  real(8) :: dabfnc(3,3)
  real(8) :: gcdp, hd2p, hhgc, &
  &          psigc, rics, &
  &          rxx, rxy, rxz, ryx, ryy, ryz, rzx, rzy, rzz, &
  &          utgc, zfac, &
  &          gmxxu, gmxyu, gmxzu, gmyyu, gmyzu, gmzzu, gmyxu, gmzxu, gmzyu, &
  &          hhxxu, hhxyu, hhxzu, hhyyu, hhyzu, hhzzu, hhyxu, hhzxu, hhzyu
  integer :: ipg, irg, itg
!
!t call cpu_time(tm)
  call alloc_array5d(dadbfn,1,nrg,1,ntg,1,npg,1,3,1,3)
  call alloc_array4d(grad,1,nrg,1,ntg,1,npg,1,3)
  call alloc_array3d(dfdx,1,nrg,1,ntg,1,npg)
  call alloc_array3d(dfdy,1,nrg,1,ntg,1,npg)
  call alloc_array3d(dfdz,1,nrg,1,ntg,1,npg)
!
! --- Source for computing the conformal factor psi.
!
!t call cpu_time(t0)
!t write(6,*)'time partm', t0-tm
  call grgrad_midpoint(psi,dfdx,dfdy,dfdz)
  grad(1:nrg,1:ntg,1:npg,1) = dfdx(1:nrg,1:ntg,1:npg)
  grad(1:nrg,1:ntg,1:npg,2) = dfdy(1:nrg,1:ntg,1:npg)
  grad(1:nrg,1:ntg,1:npg,3) = dfdz(1:nrg,1:ntg,1:npg)
!t call cpu_time(t1)
!t write(6,*)'time part0', t1-t0
  call dadbscalar_type2(psi,dadbfn,'ns')
!t call cpu_time(t2)
!t write(6,*)'time part1', t2-t1
!
  do ipg = 1, npg
    do itg = 1, ntg
      do irg = 1, nrg
!
        call interpo_linear_type0(psigc, psi,irg,itg,ipg)
!
        call interpo_linear_type0(hhxxu,hxxu,irg,itg,ipg)
        call interpo_linear_type0(hhxyu,hxyu,irg,itg,ipg)
        call interpo_linear_type0(hhxzu,hxzu,irg,itg,ipg)
        call interpo_linear_type0(hhyyu,hyyu,irg,itg,ipg)
        call interpo_linear_type0(hhyzu,hyzu,irg,itg,ipg)
        call interpo_linear_type0(hhzzu,hzzu,irg,itg,ipg)
        gmxxu = hhxxu + 1.0d0
        gmyyu = hhyyu + 1.0d0
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
! --  Skip for IWM.
        rics = 0.0d0
        gcdp = 0.0d0
        hd2p = 0.0d0
!
        rics = gmxxu*rxx + gmxyu*rxy + gmxzu*rxz &
       &     + gmyxu*ryx + gmyyu*ryy + gmyzu*ryz &
       &     + gmzxu*rzx + gmzyu*rzy + gmzzu*rzz 
!
        gcdp = gmcrix(irg,itg,ipg)*grad(irg,itg,ipg,1) &
       &     + gmcriy(irg,itg,ipg)*grad(irg,itg,ipg,2) &
       &     + gmcriz(irg,itg,ipg)*grad(irg,itg,ipg,3)
!
!        call dadbscalar_type0(psi,dabfnc,irg,itg,ipg)
        dabfnc(1,1) = dadbfn(irg,itg,ipg,1,1)
        dabfnc(1,2) = dadbfn(irg,itg,ipg,1,2)
        dabfnc(1,3) = dadbfn(irg,itg,ipg,1,3)
        dabfnc(2,1) = dadbfn(irg,itg,ipg,2,1)
        dabfnc(2,2) = dadbfn(irg,itg,ipg,2,2)
        dabfnc(2,3) = dadbfn(irg,itg,ipg,2,3)
        dabfnc(3,1) = dadbfn(irg,itg,ipg,3,1)
        dabfnc(3,2) = dadbfn(irg,itg,ipg,3,2)
        dabfnc(3,3) = dadbfn(irg,itg,ipg,3,3)
        hd2p = hhxxu* dabfnc(1,1) &
       &     + hhxyu*(dabfnc(1,2) + dabfnc(2,1)) &
       &     + hhxzu*(dabfnc(1,3) + dabfnc(3,1)) &
       &     + hhyyu* dabfnc(2,2) &
       &     + hhyzu*(dabfnc(2,3) + dabfnc(3,2)) &
       &     + hhzzu* dabfnc(3,3)
!
        sou(irg,itg,ipg) = - hd2p + gcdp + 0.125d0*psigc*rics
!
      end do
    end do
  end do
!t call cpu_time(t3)
!t write(6,*)'time part2', t3-t2
!
  deallocate(dadbfn)
  deallocate(grad)
  deallocate(dfdx)
  deallocate(dfdy)
  deallocate(dfdz)
!
end subroutine sourceterm_HaC_WL_test
