subroutine sourceterm_AHfinder(sou)
  use phys_constant, only : long
  use grid_parameter, only : nrg, ntg, npg
  use def_horizon, only : ahz
  use coordinate_grav_r, only : rg, hrg
  use def_metric, only : psi, alph, tfkij
  use interface_grgrad_4th_gridpoint_bhex
  use interface_grgrad_midpoint_r3rd_type0
  use interface_interpo_linear_type0
  use interface_interpo_linear_type0_2Dsurf
  use make_array_3d
  implicit none
  real(long), pointer :: sou(:,:)
  real(long), pointer :: dFrhdx_grid(:,:,:), dFrhdx(:,:,:)
  real(long), pointer :: dFrhdy_grid(:,:,:), dFrhdy(:,:,:)
  real(long), pointer :: dFrhdz_grid(:,:,:), dFrhdz(:,:,:)
  real(long), pointer :: Frh(:,:,:), dfn(:,:,:), dfn_grid(:,:,:)
  real(long), pointer :: fnc0(:,:,:), fnc2(:,:,:)
  real(long), external :: lagint_4th
  real(long) :: sgmu(3,3), aij(3,3)
  real(long) :: r4(4), f4(4)
  real(long) :: detr, dfnw, dfnw_grid, dlpfdf, pdfkabsab, psi2, psi4, &
  &             dfdx, dfdy, dfdz, dFrhdxgc, dFrhdygc, dFrhdzgc, &
  &             rgv, sxd, sxu, syd, syu, szd, szu, p2dfnw, term2
  integer :: ia, ib, ii, ipg, ir0, irg, irg0, itg
!
  call alloc_array3d(Frh ,0,nrg,0,ntg,0,npg)
  call alloc_array3d(dFrhdx_grid,0,nrg,0,ntg,0,npg)
  call alloc_array3d(dFrhdy_grid,0,nrg,0,ntg,0,npg)
  call alloc_array3d(dFrhdz_grid,0,nrg,0,ntg,0,npg)
  call alloc_array3d(dfn_grid,0,nrg,0,ntg,0,npg)
  call alloc_array3d(fnc0,0,nrg,0,ntg,0,npg)
  call alloc_array3d(dFrhdx,1,nrg,1,ntg,1,npg)
  call alloc_array3d(dFrhdy,1,nrg,1,ntg,1,npg)
  call alloc_array3d(dFrhdz,1,nrg,1,ntg,1,npg)
  call alloc_array3d(dfn,1,nrg,1,ntg,1,npg)
  call alloc_array3d(fnc2,1,nrg,1,ntg,1,npg)
!
!-- Define F = r - Rh
  do ipg = 0, npg
    do itg = 0, ntg
      do irg = 0, nrg
        Frh(irg,itg,ipg) = rg(irg) - ahz(itg,ipg)
      end do
    end do
  end do
!-- gridpoint
  do ipg = 0, npg
    do itg = 0, ntg
      do irg = 0, nrg
        call grgrad_4th_gridpoint_bhex(Frh,dfdx,dfdy,dfdz,irg,itg,ipg)
        dFrhdx_grid(irg,itg,ipg) = dfdx
        dFrhdy_grid(irg,itg,ipg) = dfdy
        dFrhdz_grid(irg,itg,ipg) = dfdz
        dfn_grid(irg,itg,ipg) = dsqrt(dabs(dfdx*dfdx + dfdy*dfdy + dfdz*dfdz))
        dfnw_grid = dfn_grid(irg,itg,ipg)
        psi4 = psi(irg,itg,ipg)**4
        fnc0(irg,itg,ipg) = dlog(psi4/dfnw_grid)
      end do
    end do
  end do
!-- midpoint
  do ipg = 1, npg
    do itg = 1, ntg
      do irg = 1, nrg
        call grgrad_midpoint_r3rd_type0(Frh,dfdx,dfdy,dfdz,irg,itg,ipg,'bh')
        dFrhdx(irg,itg,ipg) = dfdx
        dFrhdy(irg,itg,ipg) = dfdy
        dFrhdz(irg,itg,ipg) = dfdz
        dfn(irg,itg,ipg) = dsqrt(dabs(dfdx*dfdx + dfdy*dfdy + dfdz*dfdz))
        dfnw = dfn(irg,itg,ipg)
        call interpo_linear_type0(psi2,psi,irg,itg,ipg)
        psi2 = psi2**2
        fnc2(irg,itg,ipg) = psi2*dfnw
      end do
    end do
  end do
!
! -- source term, midpoints.
!
  do ipg = 1, npg
    do itg = 1, ntg
      call interpo_linear_type0_2Dsurf(rgv,ahz,itg,ipg)
      irg0 = 1
      do irg = 1, nrg-1
        detr = (hrg(irg+1)-rgv)*(hrg(irg)-rgv)
        if(detr <= 0.0d0) then
          irg0 = irg
          exit
        end if
      end do
      ir0 = min0(max0(irg0-1,1),nrg-3)
!
      do ii = 1, 4
        irg = ir0-1 + ii
        r4(ii) = hrg(irg)
!
        dFrhdxgc = dFrhdx(irg,itg,ipg)
        dFrhdygc = dFrhdy(irg,itg,ipg)
        dFrhdzgc = dFrhdz(irg,itg,ipg)
        call grgrad_midpoint_r3rd_type0(fnc0,dfdx,dfdy,dfdz,irg,itg,ipg,'bh')
        dlpfdf = dfdx*dFrhdxgc + dfdy*dFrhdygc + dfdz*dFrhdzgc
!
        dfnw = dfn(irg,itg,ipg)
        p2dfnw = fnc2(irg,itg,ipg)
        sxd = dFrhdxgc/dfnw
        syd = dFrhdygc/dfnw
        szd = dFrhdzgc/dfnw
        sxu = sxd ; syu = syd ; szu = szd
!
        sgmu(1,1) = 1.0d0 - sxu*sxu
        sgmu(1,2) =       - sxu*syu
        sgmu(1,3) =       - sxu*szu
        sgmu(2,1) =       - syu*sxu
        sgmu(2,2) = 1.0d0 - syu*syu
        sgmu(2,3) =       - syu*szu
        sgmu(3,1) =       - szu*sxu
        sgmu(3,2) =       - szu*syu
        sgmu(3,3) = 1.0d0 - szu*szu
!
        aij(1,1) = tfkij(irg,itg,ipg,1,1)
        aij(1,2) = tfkij(irg,itg,ipg,1,2)
        aij(1,3) = tfkij(irg,itg,ipg,1,3)
        aij(2,1) = tfkij(irg,itg,ipg,2,1)
        aij(2,2) = tfkij(irg,itg,ipg,2,2)
        aij(2,3) = tfkij(irg,itg,ipg,2,3)
        aij(3,1) = tfkij(irg,itg,ipg,3,1)
        aij(3,2) = tfkij(irg,itg,ipg,3,2)
        aij(3,3) = tfkij(irg,itg,ipg,3,3)
!
! --  trk = 0
        term2 = 0.0d0
        do ib = 1,3
          do ia = 1,3
            term2 = term2 + aij(ia,ib)*sgmu(ia,ib)
          end do
        end do
        pdfkabsab = p2dfnw*term2
!
        f4(ii) = dlpfdf - pdfkabsab
!
      end do
!
      sou(itg,ipg) = rgv**2*lagint_4th(r4,f4,rgv)
!
    end do
  end do
!
  deallocate(Frh)
  deallocate(dFrhdx_grid)
  deallocate(dFrhdy_grid)
  deallocate(dFrhdz_grid)
  deallocate(dfn_grid)
  deallocate(fnc0)
  deallocate(dFrhdx)
  deallocate(dFrhdy)
  deallocate(dFrhdz)
  deallocate(dfn)
  deallocate(fnc2)
end subroutine sourceterm_AHfinder
