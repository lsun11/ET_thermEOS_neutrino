subroutine violation_gridpoint_MoC_CF_peos_spin(MoC_vio,cobj)
  use phys_constant, only : long, pi
  use grid_parameter, only : nrg, ntg, npg
  use def_metric
  use def_metric_excurve_grid
  use def_bh_parameter, only : ome_bh
  use def_matter, only : emdg, omeg, vepxg, vepyg, vepzg, jomeg_int
  use def_matter_parameter, only : ome, ber, radi, confpow
  use def_vector_x
  use def_vector_phi
  use def_velocity_rot
  use make_array_3d
  use make_array_4d
  use interface_interpo_linear_type0
  use interface_grgrad_gridpoint
  use interface_grgrad_gridpoint_bhex
  use interface_grgrad_4th_gridpoint
  use interface_grgrad_4th_gridpoint_bhex
  use interface_grgrad_midpoint_r3rd_nsbh
  use interface_grgrad_midpoint_r3rd_type0_ns
  use interface_grgrad_midpoint_r3rd_type0_bh
  use interface_dadbscalar_3rd2nd_type0
!  use def_vector_phi, only : vec_phig
  implicit none
  real(long), pointer :: MoC_vio(:,:,:,:), ddivBeta(:,:,:,:), Lapla_beta(:,:,:,:)
  real(long), pointer :: fnc2(:,:,:), divBeta(:,:,:)
  real(long), pointer :: grad2x(:,:,:), grad2y(:,:,:), grad2z(:,:,:)
  real(long), pointer :: dbvxddx(:,:,:), dbvxddy(:,:,:), dbvxddz(:,:,:)
  real(long), pointer :: dbvyddx(:,:,:), dbvyddy(:,:,:), dbvyddz(:,:,:)
  real(long), pointer :: dbvzddx(:,:,:), dbvzddy(:,:,:), dbvzddz(:,:,:)

  real(long) :: d2bxdxx, d2bxdxy, d2bxdxz 
  real(long) :: d2bxdyx, d2bxdyy, d2bxdyz 
  real(long) :: d2bxdzx, d2bxdzy, d2bxdzz 
  real(long) :: d2bydxx, d2bydxy, d2bydxz
  real(long) :: d2bydyx, d2bydyy, d2bydyz
  real(long) :: d2bydzx, d2bydzy, d2bydzz
  real(long) :: d2bzdxx, d2bzdxy, d2bzdxz
  real(long) :: d2bzdyx, d2bzdyy, d2bzdyz
  real(long) :: d2bzdzx, d2bzdzy, d2bzdzz

  real(long) :: vphig(3), san, san2,  ovdgc(3), lam
  real(long) :: emdgc, rhogc, pregc, hhgc, utgc, oterm, zfac, rjj
  real(long) :: psigc, alpgc, fnc2gc, afnc2inv, dxafn, dyafn, dzafn
  real(long) :: bvxdgc, bvydgc, bvzdgc, tfkax, tfkay, tfkaz, ene
  real(long) :: omegc, jomeg_intgc

  real(long) :: ovxu, ovyu, ovzu, vepxgc, vepygc, vepzgc
  real(long) :: dbxdx,dbxdy,dbxdz, dbydx,dbydy,dbydz, dbzdx,dbzdy,dbzdz 
  integer :: ii, irg, itg, ipg, impt
  real(long) :: wxgc, wygc, wzgc, psigc4, psigcp, alpgc2, dvep2, wdvep, w2, &
       &        wterm, uih2, hut
  character(len=2), intent(in) :: cobj
!
  call alloc_array3d(fnc2   ,0,nrg,0,ntg,0,npg)
  call alloc_array3d(grad2x ,0,nrg,0,ntg,0,npg)
  call alloc_array3d(grad2y ,0,nrg,0,ntg,0,npg)
  call alloc_array3d(grad2z ,0,nrg,0,ntg,0,npg)
  call alloc_array3d(divBeta,0,nrg,0,ntg,0,npg)

  call alloc_array3d(dbvxddx,0,nrg,0,ntg,0,npg)
  call alloc_array3d(dbvxddy,0,nrg,0,ntg,0,npg)
  call alloc_array3d(dbvxddz,0,nrg,0,ntg,0,npg)

  call alloc_array3d(dbvyddx,0,nrg,0,ntg,0,npg)
  call alloc_array3d(dbvyddy,0,nrg,0,ntg,0,npg)
  call alloc_array3d(dbvyddz,0,nrg,0,ntg,0,npg)

  call alloc_array3d(dbvzddx,0,nrg,0,ntg,0,npg)
  call alloc_array3d(dbvzddy,0,nrg,0,ntg,0,npg)
  call alloc_array3d(dbvzddz,0,nrg,0,ntg,0,npg)

  call alloc_array4d(Lapla_beta,0,nrg,0,ntg,0,npg,1,3)
  call alloc_array4d(ddivBeta  ,0,nrg,0,ntg,0,npg,1,3)
!
  san = 1.0d0/3.0d0
  san2= 2.0d0/3.0d0
!
! --- Source terms of Momentum constraint 
! --- for computing shift.  
!
  if (cobj=='ns') then
!
  do ipg = 0, npg
    do itg = 0, ntg
      do irg = 0, nrg
        psigc = psi(irg,itg,ipg)
        alpgc = alph(irg,itg,ipg)
        if (alpgc.le.0.0d0) alpgc = 1.0d-20
        fnc2(irg,itg,ipg) = psi(irg,itg,ipg)**6/alpgc
        call grgrad_4th_gridpoint(bvxd,dbxdx,dbxdy,dbxdz,irg,itg,ipg)
        call grgrad_4th_gridpoint(bvyd,dbydx,dbydy,dbydz,irg,itg,ipg)
        call grgrad_4th_gridpoint(bvzd,dbzdx,dbzdy,dbzdz,irg,itg,ipg)

        divBeta(irg,itg,ipg) = dbxdx + dbydy + dbzdz

        dbvxddx(irg,itg,ipg) = dbxdx
        dbvxddy(irg,itg,ipg) = dbxdy
        dbvxddz(irg,itg,ipg) = dbxdz

        dbvyddx(irg,itg,ipg) = dbydx
        dbvyddy(irg,itg,ipg) = dbydy
        dbvyddz(irg,itg,ipg) = dbydz

        dbvzddx(irg,itg,ipg) = dbzdx
        dbvzddy(irg,itg,ipg) = dbzdy
        dbvzddz(irg,itg,ipg) = dbzdz
      end do
    end do
  end do
!
  call grgrad_gridpoint(fnc2,grad2x,grad2y,grad2z)
!
  do ipg = 0, npg
    do itg = 0, ntg
      do irg = 0, nrg
        call grgrad_4th_gridpoint(divBeta,dxafn,dyafn,dzafn,irg,itg,ipg)
        ddivBeta(irg,itg,ipg,1) = dxafn        
        ddivBeta(irg,itg,ipg,2) = dyafn
        ddivBeta(irg,itg,ipg,3) = dzafn

        call grgrad_4th_gridpoint(dbvxddx,d2bxdxx,d2bxdxy,d2bxdxz,irg,itg,ipg)
        call grgrad_4th_gridpoint(dbvxddy,d2bxdyx,d2bxdyy,d2bxdyz,irg,itg,ipg)
        call grgrad_4th_gridpoint(dbvxddz,d2bxdzx,d2bxdzy,d2bxdzz,irg,itg,ipg)
        Lapla_beta(irg,itg,ipg,1) = d2bxdxx + d2bxdyy + d2bxdzz

        call grgrad_4th_gridpoint(dbvyddx,d2bydxx,d2bydxy,d2bydxz,irg,itg,ipg)
        call grgrad_4th_gridpoint(dbvyddy,d2bydyx,d2bydyy,d2bydyz,irg,itg,ipg)
        call grgrad_4th_gridpoint(dbvyddz,d2bydzx,d2bydzy,d2bydzz,irg,itg,ipg)
        Lapla_beta(irg,itg,ipg,2) = d2bydxx + d2bydyy + d2bydzz

        call grgrad_4th_gridpoint(dbvzddx,d2bzdxx,d2bzdxy,d2bzdxz,irg,itg,ipg)
        call grgrad_4th_gridpoint(dbvzddy,d2bzdyx,d2bzdyy,d2bzdyz,irg,itg,ipg)
        call grgrad_4th_gridpoint(dbvzddz,d2bzdzx,d2bzdzy,d2bzdzz,irg,itg,ipg)
        Lapla_beta(irg,itg,ipg,3) = d2bzdxx + d2bzdyy + d2bzdzz
      end do
    end do
  end do
!
  else
!
  do ipg = 0, npg
    do itg = 0, ntg
      do irg = 0, nrg
        psigc = psi(irg,itg,ipg)
        alpgc = alph(irg,itg,ipg)
        if (alpgc.le.0.0d0) alpgc = 1.0d-20
        fnc2(irg,itg,ipg) = psi(irg,itg,ipg)**6/alpgc
        call grgrad_4th_gridpoint_bhex(bvxd,dbxdx,dbxdy,dbxdz,irg,itg,ipg)
        call grgrad_4th_gridpoint_bhex(bvyd,dbydx,dbydy,dbydz,irg,itg,ipg)
        call grgrad_4th_gridpoint_bhex(bvzd,dbzdx,dbzdy,dbzdz,irg,itg,ipg)

        divBeta(irg,itg,ipg) = dbxdx + dbydy + dbzdz

        dbvxddx(irg,itg,ipg) = dbxdx
        dbvxddy(irg,itg,ipg) = dbxdy
        dbvxddz(irg,itg,ipg) = dbxdz

        dbvyddx(irg,itg,ipg) = dbydx
        dbvyddy(irg,itg,ipg) = dbydy
        dbvyddz(irg,itg,ipg) = dbydz

        dbvzddx(irg,itg,ipg) = dbzdx
        dbvzddy(irg,itg,ipg) = dbzdy
        dbvzddz(irg,itg,ipg) = dbzdz
      end do
    end do
  end do
!
  call grgrad_gridpoint_bhex(fnc2,grad2x,grad2y,grad2z)
!
  do ipg = 0, npg
    do itg = 0, ntg
      do irg = 0, nrg
        call grgrad_4th_gridpoint_bhex(divBeta,dxafn,dyafn,dzafn,irg,itg,ipg)
        ddivBeta(irg,itg,ipg,1) = dxafn        
        ddivBeta(irg,itg,ipg,2) = dyafn
        ddivBeta(irg,itg,ipg,3) = dzafn

        call grgrad_4th_gridpoint_bhex(dbvxddx,d2bxdxx,d2bxdxy,d2bxdxz,irg,itg,ipg)
        call grgrad_4th_gridpoint_bhex(dbvxddy,d2bxdyx,d2bxdyy,d2bxdyz,irg,itg,ipg)
        call grgrad_4th_gridpoint_bhex(dbvxddz,d2bxdzx,d2bxdzy,d2bxdzz,irg,itg,ipg)
        Lapla_beta(irg,itg,ipg,1) = d2bxdxx + d2bxdyy + d2bxdzz

        call grgrad_4th_gridpoint_bhex(dbvyddx,d2bydxx,d2bydxy,d2bydxz,irg,itg,ipg)
        call grgrad_4th_gridpoint_bhex(dbvyddy,d2bydyx,d2bydyy,d2bydyz,irg,itg,ipg)
        call grgrad_4th_gridpoint_bhex(dbvyddz,d2bydzx,d2bydzy,d2bydzz,irg,itg,ipg)
        Lapla_beta(irg,itg,ipg,2) = d2bydxx + d2bydyy + d2bydzz

        call grgrad_4th_gridpoint_bhex(dbvzddx,d2bzdxx,d2bzdxy,d2bzdxz,irg,itg,ipg)
        call grgrad_4th_gridpoint_bhex(dbvzddy,d2bzdyx,d2bzdyy,d2bzdyz,irg,itg,ipg)
        call grgrad_4th_gridpoint_bhex(dbvzddz,d2bzdzx,d2bzdzy,d2bzdzz,irg,itg,ipg)
        Lapla_beta(irg,itg,ipg,3) = d2bzdxx + d2bzdyy + d2bzdzz
      end do
    end do
  end do
!
  end if

  do ii = 1, 3
    do ipg = 0, npg
      do itg = 0, ntg
        do irg = 0, nrg
          emdgc    = emdg(irg,itg,ipg)
          vepxgc   = vepxg(irg,itg,ipg)
          vepygc   = vepyg(irg,itg,ipg)
          vepzgc   = vepzg(irg,itg,ipg)
          omegc    = omeg(irg,itg,ipg)
          jomeg_intgc = jomeg_int(irg,itg,ipg)
          psigc    = psi(irg,itg,ipg)
          alpgc    = alph(irg,itg,ipg)
          fnc2gc   = fnc2(irg,itg,ipg)
          bvxdgc   = bvxd(irg,itg,ipg)
          bvydgc   = bvyd(irg,itg,ipg)
          bvzdgc   = bvzd(irg,itg,ipg)
          wxgc     = wxspg(irg,itg,ipg)
          wygc     = wyspg(irg,itg,ipg)
          wzgc     = wzspg(irg,itg,ipg)
          afnc2inv = alpgc/fnc2gc

          dxafn = grad2x(irg,itg,ipg)
          dyafn = grad2y(irg,itg,ipg)
          dzafn = grad2z(irg,itg,ipg)
          tfkax = tfkij_grid(irg,itg,ipg,ii,1)
          tfkay = tfkij_grid(irg,itg,ipg,ii,2)
          tfkaz = tfkij_grid(irg,itg,ipg,ii,3)
!
          zfac = 1.0d0
          if (emdgc <= 1.0d-15) then
            emdgc = 1.0d-15
            zfac  = 0.0d0
          end if
          call peos_q2hprho(emdgc, hhgc, pregc, rhogc, ene)
   
          vphig(1) = vec_phig(irg,itg,ipg,1)
          vphig(2) = vec_phig(irg,itg,ipg,2)
          vphig(3) = vec_phig(irg,itg,ipg,3)
          ovdgc(1) = bvxdgc + ome*vphig(1)
          ovdgc(2) = bvydgc + ome*vphig(2)
          ovdgc(3) = bvzdgc + ome*vphig(3)
          lam      = ber + ovdgc(1)*vepxgc + ovdgc(2)*vepygc + ovdgc(3)*vepzgc
          psigc4   = psigc**4
          psigcp   = psigc**confpow
          alpgc2   = alpgc**2

          dvep2    = (vepxgc**2 + vepygc**2 + vepzgc**2)/psigc4
          wdvep    = (wxgc*vepxgc + wygc*vepygc + wzgc*vepzgc)*psigcp
          w2       = psigc4*(wxgc*wxgc + wygc*wygc + wzgc*wzgc)*psigcp**2.0d0

          wterm    = wdvep + w2
          uih2     = dvep2 + 2.0d0*wdvep + w2

          if ( (lam*lam + 4.0d0*alpgc2*wterm)<0.0d0 ) then
            write(6,*)  "hut imaginary....exiting"
            stop
          end if
          hut = (lam + sqrt(lam*lam + 4.0d0*alpgc2*wterm))/(2.0d0*alpgc2)

          utgc = hut/hhgc

          oterm = 0.0d0
          if (ii == 1) oterm = vepxgc/psigc4 + psigcp*wxgc
          if (ii == 2) oterm = vepygc/psigc4 + psigcp*wygc
          if (ii == 3) oterm = vepzgc/psigc4 + psigcp*wzgc
!
          rjj = rhogc*alpgc*utgc*oterm
!
          MoC_vio(irg,itg,ipg,ii) = - 2.0d0*afnc2inv &
                 &   *(tfkax*dxafn + tfkay*dyafn + tfkaz*dzafn) &
                 &   - san*ddivBeta(irg,itg,ipg,ii)    &
                 &   + radi**2*16.0d0*pi*alpgc*psigc4*rjj*zfac  &
                 &   - Lapla_beta(irg,itg,ipg,ii)
          MoC_vio(irg,itg,ipg,ii) = MoC_vio(irg,itg,ipg,ii)/(2.0d0*alpgc*psigc**4)
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

  deallocate(dbvxddx)
  deallocate(dbvxddy)
  deallocate(dbvxddz)

  deallocate(dbvyddx)
  deallocate(dbvyddy)
  deallocate(dbvyddz)

  deallocate(dbvzddx)
  deallocate(dbvzddy)
  deallocate(dbvzddz)

  deallocate(Lapla_beta)
  deallocate(ddivBeta)

end subroutine violation_gridpoint_MoC_CF_peos_spin
