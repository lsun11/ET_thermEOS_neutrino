subroutine sourceterm_MWspatial_WL(souvec)
!
  use phys_constant, only : pi
  use def_matter_parameter, only : ome
  use def_metric, only : psi, alph, tfkij
  use def_emfield, only : vaxd, vayd, vazd, vaxu, vayu, vazu
  use grid_parameter, only : nrg, ntg, npg
  use coordinate_grav_r, only : rg
  use def_cristoffel_grid, only : cri_grid
  use def_gamma_crist, only : gmcrix, gmcriy, gmcriz
  use def_ricci_tensor, only : rab
  use def_faraday_tensor, only : fxd, fyd, fzd, fijd
  use def_emfield_derivatives, only : cdvaxd, cdvayd, cdvazd
  use def_formulation, only : swflu
  use def_cristoffel, only : cri
  use def_cutsw, only : cutfac
  use def_metric_hij, only : hxxu, hxyu, hxzu, hyyu, hyzu, hzzu
  use def_metric_rotshift, only : ovxd, ovyd, ovzd
  use def_formulation, only : chgra
  use interface_interpo_linear_type0
  use interface_grgrad_midpoint
  use interface_grgrad1g_midpoint
  use interface_dadbscalar_type0
  use interface_dadbscalar_type3
  use make_array_3d
  implicit none
!
  real(8), pointer :: souvec(:,:,:,:)
  real(8), pointer :: grad2x(:,:,:), grad2y(:,:,:), grad2z(:,:,:)
  real(8), pointer :: fnc2(:,:,:)
  real(8) :: grad(1:3), dabfnc(3,3), Fdalps2(3,3), AabFc(3,3), &
  &          fijdgc(3,3), tfkijgc(3,3), hiju(3,3), gmiju(3,3)
!
  real(8), pointer :: cri1va(:,:,:), cri2va(:,:,:), cri3va(:,:,:), &
  &                   cri4va(:,:,:), cri5va(:,:,:), cri6va(:,:,:)
  real(8) :: gmxxu, gmxyu, gmxzu, gmyyu, gmyzu, gmzzu, &
  &          gmyxu, gmzxu, gmzyu, &
  &          hhxxu, hhxyu, hhxzu, hhyxu, hhyyu, hhyzu, &
  &          hhzxu, hhzyu, hhzzu, &
  &          vaxdc, vaxgc, vaydc, vaygc, vazdc, vazgc, &
  &          c11, c12, c13, c14, c15, c16, &
  &          c21, c22, c23, c24, c25, c26, &
  &          c31, c32, c33, c34, c35, c36, &
  &          gc1, gc2, gc3, gclp, gcrdb1, gcrdb2, gdcb, &
  &          gmxvax, gmxvay, gmxvaz, gmyvax, gmyvay, gmyvaz, &
  &          gmzvax, gmzvay, gmzvaz, &
  &          hddb, rax, ray, raz, &
  &          san, san2, zfac, &
  &          cutoff, alpsi2, alpsi2inv, divlp, &
  &          dxc1b, dxc2b, dxc3b, dxc4b, dxc5b, dxc6b, &
  &          dyc1b, dyc2b, dyc3b, dyc4b, dyc5b, dyc6b, &
  &          dzc1b, dzc2b, dzc3b, dzc4b, dzc5b, dzc6b, &
  &          dvaxdx, dvaxdy, dvaxdz, dvaydx, dvaydy, dvaydz, &
  &          dvazdx, dvazdy, dvazdz, &
  &          dxafn, dyafn, dzafn, &
  &          vaxdgc, vaydgc, vazdgc, fxdgc, fydgc, fzdgc
  real(8) :: psigc, ricciva, Fap2dap2, p4AF
  integer :: ipg, irg, itg, ic1, ic2, ic3, ii, ic0(1:3)
!
  call alloc_array3d(fnc2,0,nrg,0,ntg,0,npg)
  call alloc_array3d(grad2x,0,nrg,0,ntg,0,npg)
  call alloc_array3d(grad2y,0,nrg,0,ntg,0,npg)
  call alloc_array3d(grad2z,0,nrg,0,ntg,0,npg)
  call alloc_array3d(cri1va,0,nrg,0,ntg,0,npg)
  call alloc_array3d(cri2va,0,nrg,0,ntg,0,npg)
  call alloc_array3d(cri3va,0,nrg,0,ntg,0,npg)
  call alloc_array3d(cri4va,0,nrg,0,ntg,0,npg)
  call alloc_array3d(cri5va,0,nrg,0,ntg,0,npg)
  call alloc_array3d(cri6va,0,nrg,0,ntg,0,npg)
!
! --- compute source terms for shift, which is evaluated on grids.
!
  do ipg = 0, npg
    do itg = 0, ntg
      do irg = 0, nrg
!
        vaxdc=vaxd(irg,itg,ipg)
        vaydc=vayd(irg,itg,ipg)
        vazdc=vazd(irg,itg,ipg)
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
        cri1va(irg,itg,ipg) = c11*vaxdc + c21*vaydc + c31*vazdc
        cri2va(irg,itg,ipg) = c12*vaxdc + c22*vaydc + c32*vazdc
        cri3va(irg,itg,ipg) = c13*vaxdc + c23*vaydc + c33*vazdc
        cri4va(irg,itg,ipg) = c14*vaxdc + c24*vaydc + c34*vazdc
        cri5va(irg,itg,ipg) = c15*vaxdc + c25*vaydc + c35*vazdc
        cri6va(irg,itg,ipg) = c16*vaxdc + c26*vaydc + c36*vazdc
!
      end do
    end do
  end do
!
  fnc2(0:nrg,0:ntg,0:npg) = alph(0:nrg,0:ntg,0:npg)*psi(0:nrg,0:ntg,0:npg)**2
  call grgrad_midpoint(fnc2,grad2x,grad2y,grad2z)
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
          call interpo_linear_type0(vaxgc,vaxu,irg,itg,ipg)
          call interpo_linear_type0(vaygc,vayu,irg,itg,ipg)
          call interpo_linear_type0(vazgc,vazu,irg,itg,ipg)
          call interpo_linear_type0(psigc,psi,irg,itg,ipg)
          call interpo_linear_type0(alpsi2,fnc2,irg,itg,ipg)
          alpsi2inv = 1.0d0/alpsi2
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
          hiju(1,1) = hhxxu ; hiju(1,2) = hhxyu ; hiju(1,3) = hhxzu
          hiju(2,1) = hhxyu ; hiju(2,2) = hhyyu ; hiju(2,3) = hhyzu
          hiju(3,1) = hhxzu ; hiju(3,2) = hhyzu ; hiju(3,3) = hhzzu
          gmiju(1,1) = gmxxu; gmiju(1,2) = gmxyu; gmiju(1,3) = gmxzu
          gmiju(2,1) = gmxyu; gmiju(2,2) = gmyyu; gmiju(2,3) = gmyzu
          gmiju(3,1) = gmxzu; gmiju(3,2) = gmyzu; gmiju(3,3) = gmzzu
!
          dxafn = grad2x(irg,itg,ipg)
          dyafn = grad2y(irg,itg,ipg)
          dzafn = grad2z(irg,itg,ipg)
          tfkijgc(1,1) = tfkij(irg,itg,ipg,1,1)
          tfkijgc(1,2) = tfkij(irg,itg,ipg,1,2)
          tfkijgc(1,3) = tfkij(irg,itg,ipg,1,3)
          tfkijgc(2,1) = tfkij(irg,itg,ipg,2,1)
          tfkijgc(2,2) = tfkij(irg,itg,ipg,2,2)
          tfkijgc(2,3) = tfkij(irg,itg,ipg,2,3)
          tfkijgc(3,1) = tfkij(irg,itg,ipg,3,1)
          tfkijgc(3,2) = tfkij(irg,itg,ipg,3,2)
          tfkijgc(3,3) = tfkij(irg,itg,ipg,3,3)
!
          dvaxdx = cdvaxd(irg,itg,ipg,1)
          dvaydx = cdvayd(irg,itg,ipg,1)
          dvazdx = cdvazd(irg,itg,ipg,1)
          dvaxdy = cdvaxd(irg,itg,ipg,2)
          dvaydy = cdvayd(irg,itg,ipg,2)
          dvazdy = cdvazd(irg,itg,ipg,2)
          dvaxdz = cdvaxd(irg,itg,ipg,3)
          dvaydz = cdvayd(irg,itg,ipg,3)
          dvazdz = cdvazd(irg,itg,ipg,3)
!
          fxdgc = fxd(irg,itg,ipg)  ! midpoint
          fydgc = fyd(irg,itg,ipg)  ! midpoint
          fzdgc = fzd(irg,itg,ipg)  ! midpoint
          fijdgc(1,1) = 0.0d0 ; fijdgc(2,2) = 0.0d0 ; fijdgc(3,3) = 0.0d0
          fijdgc(1,2) = fijd(irg,itg,ipg,1) ; fijdgc(2,1) = - fijdgc(1,2)
          fijdgc(1,3) = fijd(irg,itg,ipg,2) ; fijdgc(3,1) = - fijdgc(1,3)
          fijdgc(2,3) = fijd(irg,itg,ipg,3) ; fijdgc(3,2) = - fijdgc(2,3)
!
          hddb = 0.0d0
          gdcb = 0.0d0
          gcrdb1 = 0.0d0
          gcrdb2 = 0.0d0
          rax = 0.0d0
          ray = 0.0d0
          raz = 0.0d0
!
          c11 = cri(irg,itg,ipg,1,1) ; c12 = cri(irg,itg,ipg,1,2)
          c13 = cri(irg,itg,ipg,1,3) ; c14 = cri(irg,itg,ipg,1,4)
          c15 = cri(irg,itg,ipg,1,5) ; c16 = cri(irg,itg,ipg,1,6)
          c21 = cri(irg,itg,ipg,2,1) ; c22 = cri(irg,itg,ipg,2,2)
          c23 = cri(irg,itg,ipg,2,3) ; c24 = cri(irg,itg,ipg,2,4)
          c25 = cri(irg,itg,ipg,2,5) ; c26 = cri(irg,itg,ipg,2,6)
          c31 = cri(irg,itg,ipg,3,1) ; c32 = cri(irg,itg,ipg,3,2)
          c33 = cri(irg,itg,ipg,3,3) ; c34 = cri(irg,itg,ipg,3,4)
          c35 = cri(irg,itg,ipg,3,5) ; c36 = cri(irg,itg,ipg,3,6)
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
!          if(ii == 1) call dadbscalar_type0(vaxd,dabfnc,irg,itg,ipg)
!          if(ii == 2) call dadbscalar_type0(vayd,dabfnc,irg,itg,ipg)
!          if(ii == 3) call dadbscalar_type0(vazd,dabfnc,irg,itg,ipg)
          if(ii == 1) call dadbscalar_type3(vaxd,dabfnc,irg,itg,ipg)
          if(ii == 2) call dadbscalar_type3(vayd,dabfnc,irg,itg,ipg)
          if(ii == 3) call dadbscalar_type3(vazd,dabfnc,irg,itg,ipg)
          hddb = hhxxu*dabfnc(1,1) + hhxyu*dabfnc(1,2) + hhxzu*dabfnc(1,3) &
          &    + hhyxu*dabfnc(2,1) + hhyyu*dabfnc(2,2) + hhyzu*dabfnc(2,3) &
          &    + hhzxu*dabfnc(3,1) + hhzyu*dabfnc(3,2) + hhzzu*dabfnc(3,3)
!
! --- divergence of cristoffel*shift.
!
          if (ii == 1) then
            call grgrad1g_midpoint(cri1va,grad,irg,itg,ipg)
            dxc1b = grad(1)
            dyc1b = grad(2)
            dzc1b = grad(3)
            call grgrad1g_midpoint(cri2va,grad,irg,itg,ipg)
            dxc2b = grad(1)
            dyc2b = grad(2)
            dzc2b = grad(3)
            call grgrad1g_midpoint(cri3va,grad,irg,itg,ipg)
            dxc3b = grad(1)
            dyc3b = grad(2)
            dzc3b = grad(3)
            gdcb = gmxxu*dxc1b + gmxyu*dxc2b + gmxzu*dxc3b &
            &    + gmyxu*dyc1b + gmyyu*dyc2b + gmyzu*dyc3b &
            &    + gmzxu*dzc1b + gmzyu*dzc2b + gmzzu*dzc3b
          end if
          if (ii == 2) then
            call grgrad1g_midpoint(cri2va,grad,irg,itg,ipg)
            dxc2b = grad(1)
            dyc2b = grad(2)
            dzc2b = grad(3)
            call grgrad1g_midpoint(cri4va,grad,irg,itg,ipg)
            dxc4b = grad(1)
            dyc4b = grad(2)
            dzc4b = grad(3)
            call grgrad1g_midpoint(cri5va,grad,irg,itg,ipg)
            dxc5b = grad(1)
            dyc5b = grad(2)
            dzc5b = grad(3)
            gdcb = gmxxu*dxc2b + gmxyu*dxc4b + gmxzu*dxc5b &
            &    + gmyxu*dyc2b + gmyyu*dyc4b + gmyzu*dyc5b &
            &    + gmzxu*dzc2b + gmzyu*dzc4b + gmzzu*dzc5b
          end if
          if (ii == 3) then
            call grgrad1g_midpoint(cri3va,grad,irg,itg,ipg)
            dxc3b = grad(1)
            dyc3b = grad(2)
            dzc3b = grad(3)
            call grgrad1g_midpoint(cri5va,grad,irg,itg,ipg)
            dxc5b = grad(1)
            dyc5b = grad(2)
            dzc5b = grad(3)
            call grgrad1g_midpoint(cri6va,grad,irg,itg,ipg)
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
          if (ii == 1) gcrdb1 = gc1*dvaxdx + gc2*dvaxdy + gc3*dvaxdz
          if (ii == 2) gcrdb1 = gc1*dvaydx + gc2*dvaydy + gc3*dvaydz
          if (ii == 3) gcrdb1 = gc1*dvazdx + gc2*dvazdy + gc3*dvazdz
!
          gmxvax = gmxxu*dvaxdx + gmxyu*dvaxdy + gmxzu*dvaxdz
          gmxvay = gmxxu*dvaydx + gmxyu*dvaydy + gmxzu*dvaydz
          gmxvaz = gmxxu*dvazdx + gmxyu*dvazdy + gmxzu*dvazdz
          gmyvax = gmyxu*dvaxdx + gmyyu*dvaxdy + gmyzu*dvaxdz
          gmyvay = gmyxu*dvaydx + gmyyu*dvaydy + gmyzu*dvaydz
          gmyvaz = gmyxu*dvazdx + gmyyu*dvazdy + gmyzu*dvazdz
          gmzvax = gmzxu*dvaxdx + gmzyu*dvaxdy + gmzzu*dvaxdz
          gmzvay = gmzxu*dvaydx + gmzyu*dvaydy + gmzzu*dvaydz
          gmzvaz = gmzxu*dvazdx + gmzyu*dvazdy + gmzzu*dvazdz
!
          if (ii == 1) gcrdb2 = c11*gmxvax + c21*gmxvay + c31*gmxvaz &
          &                   + c12*gmyvax + c22*gmyvay + c32*gmyvaz &
          &                   + c13*gmzvax + c23*gmzvay + c33*gmzvaz
!
          if (ii == 2) gcrdb2 = c12*gmxvax + c22*gmxvay + c32*gmxvaz &
          &                   + c14*gmyvax + c24*gmyvay + c34*gmyvaz &
          &                   + c15*gmzvax + c25*gmzvay + c35*gmzvaz
!
          if (ii == 3) gcrdb2 = c13*gmxvax + c23*gmxvay + c33*gmxvaz &
          &                   + c15*gmyvax + c25*gmyvay + c35*gmyvaz &
          &                   + c16*gmzvax + c26*gmzvay + c36*gmzvaz
!
! --- Ricci A
          ricciva = rax*vaxgc + ray*vaygc + raz*vazgc
! --- Other terms
          Fdalps2(1,1) = fijdgc(ii,1)*dxafn
          Fdalps2(1,2) = fijdgc(ii,1)*dyafn
          Fdalps2(1,3) = fijdgc(ii,1)*dzafn
          Fdalps2(2,1) = fijdgc(ii,2)*dxafn
          Fdalps2(2,2) = fijdgc(ii,2)*dyafn
          Fdalps2(2,3) = fijdgc(ii,2)*dzafn
          Fdalps2(3,1) = fijdgc(ii,3)*dxafn
          Fdalps2(3,2) = fijdgc(ii,3)*dyafn
          Fdalps2(3,3) = fijdgc(ii,3)*dzafn
          call compute_trace(hiju,Fdalps2,Fap2dap2)
          Fap2dap2 = alpsi2inv*Fap2dap2
!
          AabFc(1,1) = tfkijgc(ii,1)*fxdgc
          AabFc(1,2) = tfkijgc(ii,1)*fydgc
          AabFc(1,3) = tfkijgc(ii,1)*fzdgc
          AabFc(2,1) = tfkijgc(ii,2)*fxdgc
          AabFc(2,2) = tfkijgc(ii,2)*fydgc
          AabFc(2,3) = tfkijgc(ii,2)*fzdgc
          AabFc(3,1) = tfkijgc(ii,3)*fxdgc
          AabFc(3,2) = tfkijgc(ii,3)*fydgc
          AabFc(3,3) = tfkijgc(ii,3)*fzdgc
          call compute_trace(hiju,AabFc,p4AF)
          p4AF = 2.0d0*psigc**4*p4AF
!
          souvec(irg,itg,ipg,ii) = - hddb + gdcb + gcrdb1 + gcrdb2 &
          &                      + ricciva + Fap2dap2 - p4AF
!
        end do
      end do
    end do
  end do
!$omp end do
!$omp end parallel
!
  deallocate(fnc2)
  deallocate(grad2x)
  deallocate(grad2y)
  deallocate(grad2z)
  deallocate(cri1va)
  deallocate(cri2va)
  deallocate(cri3va)
  deallocate(cri4va)
  deallocate(cri5va)
  deallocate(cri6va)
!
end subroutine sourceterm_MWspatial_WL
