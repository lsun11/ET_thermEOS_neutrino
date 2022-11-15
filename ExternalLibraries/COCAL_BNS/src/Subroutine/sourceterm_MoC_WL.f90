subroutine sourceterm_MoC_WL(souvec)
!
  use phys_constant, only : pi
  use def_matter_parameter, only : ome
  use def_metric, only : psi, alph, tfkij, bvxu, bvyu, bvzu, bvxd, bvyd, bvzd
  use def_matter, only : emdg
  use grid_parameter, only : nrg, ntg, npg
  use coordinate_grav_r, only : rg
  use def_cristoffel_grid, only : cri_grid
  use def_gamma_crist, only : gmcrix, gmcriy, gmcriz
  use def_ricci_tensor, only : rab
  use def_formulation, only : swflu
  use def_shift_derivatives, only : cdbvxd, cdbvyd, cdbvzd, &
  &                                 pdbvxd, pdbvyd, pdbvzd
  use def_Lie_derivatives, only : elpxx, elpxy, elpxz, elpyy, elpyz, elpzz
  use def_Lie_derivatives_grid, only : elpxx_grid, elpxy_grid, elpxz_grid, &
  &                                    elpyy_grid, elpyz_grid, elpzz_grid
  use def_cristoffel, only : cri
  use def_cutsw, only : cutfac
  use def_metric_hij, only : hxxu, hxyu, hxzu, hyyu, hyzu, hzzu
  use def_metric_rotshift, only : ovxd, ovyd, ovzd
  use def_formulation, only : chgra
  use interface_interpo_linear_type0
  use interface_grgrad_midpoint
  use interface_grgrad1g_midpoint
  use interface_grgrad_4th_gridpoint
  use interface_dadbscalar_type0
  use interface_dadbscalar_type3
  use make_array_3d
  implicit none
!
  real(8), pointer :: souvec(:,:,:,:)
  real(8), pointer :: grad2x(:,:,:), grad2y(:,:,:), grad2z(:,:,:)
  real(8), pointer :: grad4x(:,:,:), grad4y(:,:,:), grad4z(:,:,:)
  real(8), pointer :: fnc2(:,:,:), fnc4(:,:,:)
  real(8) :: dabfnc(1:3,1:3)
!
  real(8), pointer :: cri1be(:,:,:), cri2be(:,:,:), cri3be(:,:,:), &
           &          cri4be(:,:,:), cri5be(:,:,:), cri6be(:,:,:)
  real(8) :: gmxxu, gmxyu, gmxzu, gmyyu, gmyzu, gmzzu, &
  &          gmyxu, gmzxu, gmzyu, &
  &          hhxxu, hhxyu, hhxzu, hhyxu, hhyyu, hhyzu, &
  &          hhzxu, hhzyu, hhzzu, &
  &          pdbvxdx, pdbvxdy, pdbvxdz, pdbvydx, pdbvydy, pdbvydz, &
  &          pdbvzdx, pdbvzdy, pdbvzdz, &
  &          bvxdc, bvxgc, bvydc, bvygc, bvzdc, bvzgc, &
  &          c11, c12, c13, c14, c15, c16, &
  &          c21, c22, c23, c24, c25, c26, &
  &          c31, c32, c33, c34, c35, c36, &
  &          gc1, gc2, gc3, gclp, gcrdb1, gcrdb2, gdcb, &
  &          gmxbvx, gmxbvy, gmxbvz, gmybvx, gmybvy, gmybvz, &
  &          gmzbvx, gmzbvy, gmzbvz, &
  &          gradfnc4, hddb, pdivlp, rax, ray, raz, tfkax, tfkay, tfkaz, &
  &          san, san2, zfac, &
  &          cutoff, afnc2inv, divlp, dxafn, &
  &          dxc1b, dxc2b, dxc3b, dxc4b, dxc5b, dxc6b, &
  &          dyc1b, dyc2b, dyc3b, dyc4b, dyc5b, dyc6b, &
  &          dzc1b, dzc2b, dzc3b, dzc4b, dzc5b, dzc6b, &
  &          dbvxdx, dbvxdy, dbvxdz, dbvydx, dbvydy, dbvydz, &
  &          dbvzdx, dbvzdy, dbvzdz, &
  &          dexxdx, dexxdy, dexxdz, dexydx, dexydy, dexydz, &
  &          dexzdx, dexzdy, dexzdz, &
  &          deyydx, deyydy, deyydz, deyzdx, deyzdy, deyzdz, &
  &          dezzdx, dezzdy, dezzdz, &
  &          dyafn, dzafn, elpxxd, elpxxm, elpxyd, elpxym, elpxzd, elpxzm, &
  &          elpyxd, elpyxm, elpyyd, elpyym, elpyzd, elpyzm, &
  &          elpzxd, elpzxm, elpzyd, elpzym, elpzzd, elpzzm, &
  &          grad(1:3), ene, fnc2gc, &
  &          bvxdgc, bvydgc, bvzdgc
  integer :: ipg, irg, itg, ic1, ic2, ic3, ii, ic0(1:3)
!
  call alloc_array3d(fnc2,0,nrg,0,ntg,0,npg)
  call alloc_array3d(fnc4,0,nrg,0,ntg,0,npg)
  call alloc_array3d(grad2x,0,nrg,0,ntg,0,npg)
  call alloc_array3d(grad2y,0,nrg,0,ntg,0,npg)
  call alloc_array3d(grad2z,0,nrg,0,ntg,0,npg)
  call alloc_array3d(grad4x,0,nrg,0,ntg,0,npg)
  call alloc_array3d(grad4y,0,nrg,0,ntg,0,npg)
  call alloc_array3d(grad4z,0,nrg,0,ntg,0,npg)
  call alloc_array3d(cri1be,0,nrg,0,ntg,0,npg)
  call alloc_array3d(cri2be,0,nrg,0,ntg,0,npg)
  call alloc_array3d(cri3be,0,nrg,0,ntg,0,npg)
  call alloc_array3d(cri4be,0,nrg,0,ntg,0,npg)
  call alloc_array3d(cri5be,0,nrg,0,ntg,0,npg)
  call alloc_array3d(cri6be,0,nrg,0,ntg,0,npg)
!
! --- compute source terms for shift, which is evaluated on grids.
!
  do ipg = 0, npg
    do itg = 0, ntg
      do irg = 0, nrg
        hhxxu=hxxu(irg,itg,ipg)
        hhxyu=hxyu(irg,itg,ipg)
        hhxzu=hxzu(irg,itg,ipg)
        hhyyu=hyyu(irg,itg,ipg)
        hhyzu=hyzu(irg,itg,ipg)
        hhzzu=hzzu(irg,itg,ipg)
        hhyxu = hhxyu
        hhzxu = hhxzu
        hhzyu = hhyzu
!
        call grgrad_4th_gridpoint(bvxd,pdbvxdx,pdbvxdy,pdbvxdz,irg,itg,ipg)
        call grgrad_4th_gridpoint(bvyd,pdbvydx,pdbvydy,pdbvydz,irg,itg,ipg)
        call grgrad_4th_gridpoint(bvzd,pdbvzdx,pdbvzdy,pdbvzdz,irg,itg,ipg)
!
        fnc4(irg,itg,ipg) = hhxxu*pdbvxdx+hhxyu*pdbvxdy+hhxzu*pdbvxdz &
           &              + hhyxu*pdbvydx+hhyyu*pdbvydy+hhyzu*pdbvydz &
           &              + hhzxu*pdbvzdx+hhzyu*pdbvzdy+hhzzu*pdbvzdz
!
        bvxdc=bvxd(irg,itg,ipg)
        bvydc=bvyd(irg,itg,ipg)
        bvzdc=bvzd(irg,itg,ipg)
        c11 = cri_grid(irg,itg,ipg,1,1)
        c12 = cri_grid(irg,itg,ipg,1,2)
        c13 = cri_grid(irg,itg,ipg,1,3)
        c14 = cri_grid(irg,itg,ipg,1,4)
        c15 = cri_grid(irg,itg,ipg,1,5)
        c16 = cri_grid(irg,itg,ipg,1,6)
        c21 = cri_grid(irg,itg,ipg,2,1)
        c22 = cri_grid(irg,itg,ipg,2,2)
        c23 = cri_grid(irg,itg,ipg,2,3)
        c24 = cri_grid(irg,itg,ipg,2,4)
        c25 = cri_grid(irg,itg,ipg,2,5)
        c26 = cri_grid(irg,itg,ipg,2,6)
        c31 = cri_grid(irg,itg,ipg,3,1)
        c32 = cri_grid(irg,itg,ipg,3,2)
        c33 = cri_grid(irg,itg,ipg,3,3)
        c34 = cri_grid(irg,itg,ipg,3,4)
        c35 = cri_grid(irg,itg,ipg,3,5)
        c36 = cri_grid(irg,itg,ipg,3,6)
        cri1be(irg,itg,ipg) = c11*bvxdc + c21*bvydc + c31*bvzdc
        cri2be(irg,itg,ipg) = c12*bvxdc + c22*bvydc + c32*bvzdc
        cri3be(irg,itg,ipg) = c13*bvxdc + c23*bvydc + c33*bvzdc
        cri4be(irg,itg,ipg) = c14*bvxdc + c24*bvydc + c34*bvzdc
        cri5be(irg,itg,ipg) = c15*bvxdc + c25*bvydc + c35*bvzdc
        cri6be(irg,itg,ipg) = c16*bvxdc + c26*bvydc + c36*bvzdc
!
      end do
    end do
  end do
!
  fnc2(0:nrg,0:ntg,0:npg) = psi(0:nrg,0:ntg,0:npg)**6/alph(0:nrg,0:ntg,0:npg)
  call grgrad_midpoint(fnc2,grad2x,grad2y,grad2z)
  call grgrad_midpoint(fnc4,grad4x,grad4y,grad4z)
!
  san = 1.0d0/3.0d0
  san2= 2.0d0/3.0d0
!
!$omp parallel num_threads(3), default(firstprivate), shared(souvec)
!$omp do
  do ii = 1, 3
!
    do ipg = 1, npg
      do itg = 1, ntg
        do irg = 1, nrg
!
          cutoff = 1.0d0
          if (chgra == 'c'.or.chgra == 'C'.or.chgra == 'W') then
            if (rg(irg) > cutfac*pi/ome) cutoff = 0.0d0
          end if
!
          call interpo_linear_type0(bvxgc,bvxu,irg,itg,ipg)
          call interpo_linear_type0(bvygc,bvyu,irg,itg,ipg)
          call interpo_linear_type0(bvzgc,bvzu,irg,itg,ipg)
!
          call interpo_linear_type0(hhxxu,hxxu,irg,itg,ipg)
          call interpo_linear_type0(hhxyu,hxyu,irg,itg,ipg)
          call interpo_linear_type0(hhxzu,hxzu,irg,itg,ipg)
          call interpo_linear_type0(hhyyu,hyyu,irg,itg,ipg)
          call interpo_linear_type0(hhyzu,hyzu,irg,itg,ipg)
          call interpo_linear_type0(hhzzu,hzzu,irg,itg,ipg)
          hhyxu = hhxyu
          hhzxu = hhxzu
          hhzyu = hhyzu
          gmxxu = hhxxu + 1.0d0
          gmxyu = hhxyu
          gmxzu = hhxzu
          gmyyu = hhyyu + 1.0d0
          gmyzu = hhyzu
          gmzzu = hhzzu + 1.0d0
          gmyxu = gmxyu
          gmzxu = gmxzu
          gmzyu = gmyzu
!
          dxafn = grad2x(irg,itg,ipg)
          dyafn = grad2y(irg,itg,ipg)
          dzafn = grad2z(irg,itg,ipg)
          tfkax  = tfkij(irg,itg,ipg,ii,1)
          tfkay  = tfkij(irg,itg,ipg,ii,2)
          tfkaz  = tfkij(irg,itg,ipg,ii,3)
!
          dbvxdx = cdbvxd(irg,itg,ipg,1)
          dbvydx = cdbvyd(irg,itg,ipg,1)
          dbvzdx = cdbvzd(irg,itg,ipg,1)
          dbvxdy = cdbvxd(irg,itg,ipg,2)
          dbvydy = cdbvyd(irg,itg,ipg,2)
          dbvzdy = cdbvzd(irg,itg,ipg,2)
          dbvxdz = cdbvxd(irg,itg,ipg,3)
          dbvydz = cdbvyd(irg,itg,ipg,3)
          dbvzdz = cdbvzd(irg,itg,ipg,3)
!
          hddb = 0.0d0
          gdcb = 0.0d0
          gcrdb1 = 0.0d0
          gcrdb2 = 0.0d0
          gradfnc4 = 0.0d0
          rax = 0.0d0
          ray = 0.0d0
          raz = 0.0d0
          divlp = 0.0d0
!
          if (chgra /= 'i') then
!
            if (ii == 1) gradfnc4 = grad4x(irg,itg,ipg)
            if (ii == 2) gradfnc4 = grad4y(irg,itg,ipg)
            if (ii == 3) gradfnc4 = grad4z(irg,itg,ipg)
!
            c11 = cri(irg,itg,ipg,1,1)
            c12 = cri(irg,itg,ipg,1,2)
            c13 = cri(irg,itg,ipg,1,3)
            c14 = cri(irg,itg,ipg,1,4)
            c15 = cri(irg,itg,ipg,1,5)
            c16 = cri(irg,itg,ipg,1,6)
            c21 = cri(irg,itg,ipg,2,1)
            c22 = cri(irg,itg,ipg,2,2)
            c23 = cri(irg,itg,ipg,2,3)
            c24 = cri(irg,itg,ipg,2,4)
            c25 = cri(irg,itg,ipg,2,5)
            c26 = cri(irg,itg,ipg,2,6)
            c31 = cri(irg,itg,ipg,3,1)
            c32 = cri(irg,itg,ipg,3,2)
            c33 = cri(irg,itg,ipg,3,3)
            c34 = cri(irg,itg,ipg,3,4)
            c35 = cri(irg,itg,ipg,3,5)
            c36 = cri(irg,itg,ipg,3,6)
!
            gc1 = gmcrix(irg,itg,ipg)
            gc2 = gmcriy(irg,itg,ipg)
            gc3 = gmcriz(irg,itg,ipg)
!
            ic1 = 1*(ii-2)*(ii-3)/2 - 2*(ii-1)*(ii-3) + 3*(ii-1)*(ii-2)/2
            ic2 = 2*(ii-2)*(ii-3)/2 - 4*(ii-1)*(ii-3) + 5*(ii-1)*(ii-2)/2
            ic3 = 3*(ii-2)*(ii-3)/2 - 5*(ii-1)*(ii-3) + 6*(ii-1)*(ii-2)/2
!
            rax = rab(irg,itg,ipg,ic1)
            ray = rab(irg,itg,ipg,ic2)
            raz = rab(irg,itg,ipg,ic3)
!
            ic0(1) = ic1
            ic0(2) = ic2
            ic0(3) = ic3
!
! --- hbcdadbwa
!
!            if(ii == 1) call dadbscalar_type0(bvxd,dabfnc,irg,itg,ipg)
!            if(ii == 2) call dadbscalar_type0(bvyd,dabfnc,irg,itg,ipg)
!            if(ii == 3) call dadbscalar_type0(bvzd,dabfnc,irg,itg,ipg)
            if(ii == 1) call dadbscalar_type3(bvxd,dabfnc,irg,itg,ipg)
            if(ii == 2) call dadbscalar_type3(bvyd,dabfnc,irg,itg,ipg)
            if(ii == 3) call dadbscalar_type3(bvzd,dabfnc,irg,itg,ipg)
            hddb = hhxxu*dabfnc(1,1) + hhxyu*dabfnc(1,2) + hhxzu*dabfnc(1,3) &
            &    + hhyxu*dabfnc(2,1) + hhyyu*dabfnc(2,2) + hhyzu*dabfnc(2,3) &
            &    + hhzxu*dabfnc(3,1) + hhzyu*dabfnc(3,2) + hhzzu*dabfnc(3,3)
!
! --- divergence of cristoffel*shift.
!
            if (ii == 1) then
              call grgrad1g_midpoint(cri1be,grad,irg,itg,ipg)
              dxc1b = grad(1)
              dyc1b = grad(2)
              dzc1b = grad(3)
              call grgrad1g_midpoint(cri2be,grad,irg,itg,ipg)
              dxc2b = grad(1)
              dyc2b = grad(2)
              dzc2b = grad(3)
              call grgrad1g_midpoint(cri3be,grad,irg,itg,ipg)
              dxc3b = grad(1)
              dyc3b = grad(2)
              dzc3b = grad(3)
              gdcb = gmxxu*dxc1b + gmxyu*dxc2b + gmxzu*dxc3b &
                 &     + gmyxu*dyc1b + gmyyu*dyc2b + gmyzu*dyc3b &
                 &     + gmzxu*dzc1b + gmzyu*dzc2b + gmzzu*dzc3b
            end if
            if (ii == 2) then
              call grgrad1g_midpoint(cri2be,grad,irg,itg,ipg)
              dxc2b = grad(1)
              dyc2b = grad(2)
              dzc2b = grad(3)
              call grgrad1g_midpoint(cri4be,grad,irg,itg,ipg)
              dxc4b = grad(1)
              dyc4b = grad(2)
              dzc4b = grad(3)
              call grgrad1g_midpoint(cri5be,grad,irg,itg,ipg)
              dxc5b = grad(1)
              dyc5b = grad(2)
              dzc5b = grad(3)
              gdcb = gmxxu*dxc2b + gmxyu*dxc4b + gmxzu*dxc5b &
                 &     + gmyxu*dyc2b + gmyyu*dyc4b + gmyzu*dyc5b &
                 &     + gmzxu*dzc2b + gmzyu*dzc4b + gmzzu*dzc5b
            end if
            if (ii == 3) then
              call grgrad1g_midpoint(cri3be,grad,irg,itg,ipg)
              dxc3b = grad(1)
              dyc3b = grad(2)
              dzc3b = grad(3)
              call grgrad1g_midpoint(cri5be,grad,irg,itg,ipg)
              dxc5b = grad(1)
              dyc5b = grad(2)
              dzc5b = grad(3)
              call grgrad1g_midpoint(cri6be,grad,irg,itg,ipg)
              dxc6b = grad(1)
              dyc6b = grad(2)
              dzc6b = grad(3)
              gdcb = gmxxu*dxc3b + gmxyu*dxc5b + gmxzu*dxc6b &
              &    + gmyxu*dyc3b + gmyyu*dyc5b + gmyzu*dyc6b &
              &    + gmzxu*dzc3b + gmzyu*dzc5b + gmzzu*dzc6b
            end if
!
! --- other two terms from tilded laplacian.
!
            if (ii == 1) gcrdb1 = gc1*dbvxdx + gc2*dbvxdy + gc3*dbvxdz
            if (ii == 2) gcrdb1 = gc1*dbvydx + gc2*dbvydy + gc3*dbvydz
            if (ii == 3) gcrdb1 = gc1*dbvzdx + gc2*dbvzdy + gc3*dbvzdz
!
            gmxbvx = gmxxu*dbvxdx + gmxyu*dbvxdy + gmxzu*dbvxdz
            gmxbvy = gmxxu*dbvydx + gmxyu*dbvydy + gmxzu*dbvydz
            gmxbvz = gmxxu*dbvzdx + gmxyu*dbvzdy + gmxzu*dbvzdz
            gmybvx = gmyxu*dbvxdx + gmyyu*dbvxdy + gmyzu*dbvxdz
            gmybvy = gmyxu*dbvydx + gmyyu*dbvydy + gmyzu*dbvydz
            gmybvz = gmyxu*dbvzdx + gmyyu*dbvzdy + gmyzu*dbvzdz
            gmzbvx = gmzxu*dbvxdx + gmzyu*dbvxdy + gmzzu*dbvxdz
            gmzbvy = gmzxu*dbvydx + gmzyu*dbvydy + gmzzu*dbvydz
            gmzbvz = gmzxu*dbvzdx + gmzyu*dbvzdy + gmzzu*dbvzdz
!
            if (ii == 1) &
               & gcrdb2 = c11*gmxbvx + c21*gmxbvy + c31*gmxbvz &
               &        + c12*gmybvx + c22*gmybvy + c32*gmybvz &
               &        + c13*gmzbvx + c23*gmzbvy + c33*gmzbvz
!
            if (ii == 2) &
               & gcrdb2 = c12*gmxbvx + c22*gmxbvy + c32*gmxbvz &
               &        + c14*gmybvx + c24*gmybvy + c34*gmybvz &
               &        + c15*gmzbvx + c25*gmzbvy + c35*gmzbvz
!
            if (ii == 3) &
               & gcrdb2 = c13*gmxbvx + c23*gmxbvy + c33*gmxbvz &
               &        + c15*gmybvx + c25*gmybvy + c35*gmybvz &
               &        + c16*gmzbvx + c26*gmzbvy + c36*gmzbvz
!
! --  Helical term, \tD_b (L\phi)_a^b.
!
            if (chgra == 'h'.or.chgra == 'c'.or.chgra == 'C' &
               &.or.chgra == 'H'.or.chgra == 'W') then
!
              elpxxd = elpxx(irg,itg,ipg)
              elpxyd = elpxy(irg,itg,ipg)
              elpxzd = elpxz(irg,itg,ipg)
              elpyyd = elpyy(irg,itg,ipg)
              elpyzd = elpyz(irg,itg,ipg)
              elpzzd = elpzz(irg,itg,ipg)
              elpyxd = elpxyd
              elpzxd = elpxzd
              elpzyd = elpyzd
!
              elpxxm = gmxxu*elpxxd + gmxyu*elpxyd + gmxzu*elpxzd
              elpxym = gmyxu*elpxxd + gmyyu*elpxyd + gmyzu*elpxzd
              elpxzm = gmzxu*elpxxd + gmzyu*elpxyd + gmzzu*elpxzd
              elpyxm = gmxxu*elpyxd + gmxyu*elpyyd + gmxzu*elpyzd
              elpyym = gmyxu*elpyxd + gmyyu*elpyyd + gmyzu*elpyzd
              elpyzm = gmzxu*elpyxd + gmzyu*elpyyd + gmzzu*elpyzd
              elpzxm = gmxxu*elpzxd + gmxyu*elpzyd + gmxzu*elpzzd
              elpzym = gmyxu*elpzxd + gmyyu*elpzyd + gmyzu*elpzzd
              elpzzm = gmzxu*elpzxd + gmzyu*elpzyd + gmzzu*elpzzd
!
              if (ii == 1) then
                call grgrad1g_midpoint(elpxx_grid,grad,irg,itg,ipg)
                dexxdx = grad(1)
                dexxdy = grad(2)
                dexxdz = grad(3)
                call grgrad1g_midpoint(elpxy_grid,grad,irg,itg,ipg)
                dexydx = grad(1)
                dexydy = grad(2)
                dexydz = grad(3)
                call grgrad1g_midpoint(elpxz_grid,grad,irg,itg,ipg)
                dexzdx = grad(1)
                dexzdy = grad(2)
                dexzdz = grad(3)
                pdivlp = gmxxu*dexxdx + gmxyu*dexxdy + gmxzu*dexxdz &
                   &       + gmyxu*dexydx + gmyyu*dexydy + gmyzu*dexydz &
                   &       + gmzxu*dexzdx + gmzyu*dexzdy + gmzzu*dexzdz
                gclp = c11*elpxxm + c12*elpxym + c13*elpxzm &
                   &     + c21*elpyxm + c22*elpyym + c23*elpyzm &
                   &     + c31*elpzxm + c32*elpzym + c33*elpzzm
                divlp = pdivlp - gclp
              end if
              if (ii == 2) then
                call grgrad1g_midpoint(elpxy_grid,grad,irg,itg,ipg)
                dexydx = grad(1)
                dexydy = grad(2)
                dexydz = grad(3)
                call grgrad1g_midpoint(elpyy_grid,grad,irg,itg,ipg)
                deyydx = grad(1)
                deyydy = grad(2)
                deyydz = grad(3)
                call grgrad1g_midpoint(elpyz_grid,grad,irg,itg,ipg)
                deyzdx = grad(1)
                deyzdy = grad(2)
                deyzdz = grad(3)
                pdivlp = gmxxu*dexydx + gmxyu*dexydy + gmxzu*dexydz &
                   &       + gmyxu*deyydx + gmyyu*deyydy + gmyzu*deyydz &
                   &       + gmzxu*deyzdx + gmzyu*deyzdy + gmzzu*deyzdz
                gclp = c12*elpxxm + c14*elpxym + c15*elpxzm &
                   &     + c22*elpyxm + c24*elpyym + c25*elpyzm &
                   &     + c32*elpzxm + c34*elpzym + c35*elpzzm
                divlp = pdivlp - gclp
              end if
              if (ii == 3) then
                call grgrad1g_midpoint(elpxz_grid,grad,irg,itg,ipg)
                dexzdx = grad(1)
                dexzdy = grad(2)
                dexzdz = grad(3)
                call grgrad1g_midpoint(elpyz_grid,grad,irg,itg,ipg)
                deyzdx = grad(1)
                deyzdy = grad(2)
                deyzdz = grad(3)
                call grgrad1g_midpoint(elpzz_grid,grad,irg,itg,ipg)
                dezzdx = grad(1)
                dezzdy = grad(2)
                dezzdz = grad(3)
                pdivlp = gmxxu*dexzdx + gmxyu*dexzdy + gmxzu*dexzdz &
                   &       + gmyxu*deyzdx + gmyyu*deyzdy + gmyzu*deyzdz &
                   &       + gmzxu*dezzdx + gmzyu*dezzdy + gmzzu*dezzdz
                gclp = c13*elpxxm + c15*elpxym + c16*elpxzm &
                   &     + c23*elpyxm + c25*elpyym + c26*elpyzm &
                   &     + c33*elpzxm + c35*elpzym + c36*elpzzm
                divlp = pdivlp - gclp
              end if
!
            end if
!
          end if
!
          souvec(irg,itg,ipg,ii) = &
          &    - hddb + gdcb + gcrdb1 + gcrdb2 - san*gradfnc4 &
          &    -(rax*bvxgc + ray*bvygc + raz*bvzgc) - ome*divlp*cutoff &
          &    - 2.0d0*afnc2inv*( &
          &    + hhxxu*tfkax*dxafn + hhxyu*tfkax*dyafn + hhxzu*tfkax*dzafn &
          &    + hhyxu*tfkay*dxafn + hhyyu*tfkay*dyafn + hhyzu*tfkay*dzafn &
          &    + hhzxu*tfkaz*dxafn + hhzyu*tfkaz*dyafn + hhzzu*tfkaz*dzafn)
!
        end do
      end do
    end do
  end do
!$omp end do
!$omp end parallel
!
  deallocate(fnc4)
  deallocate(fnc2)
  deallocate(grad2x)
  deallocate(grad2y)
  deallocate(grad2z)
  deallocate(grad4x)
  deallocate(grad4y)
  deallocate(grad4z)
  deallocate(cri1be)
  deallocate(cri2be)
  deallocate(cri3be)
  deallocate(cri4be)
  deallocate(cri5be)
  deallocate(cri6be)
!
end subroutine sourceterm_MoC_WL
