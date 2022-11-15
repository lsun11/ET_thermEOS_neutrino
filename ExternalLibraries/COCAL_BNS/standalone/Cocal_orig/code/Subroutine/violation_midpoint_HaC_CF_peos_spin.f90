subroutine violation_midpoint_HaC_CF_peos_spin(HaC_vio,cobj)
  use phys_constant, only : long, pi
  use grid_parameter, only : nrg, ntg, npg
  use def_metric
  use def_matter, only : emdg, omeg, jomeg_int, vepxg, vepyg, vepzg
  use def_matter_parameter, only : ome, ber, radi, confpow
  use def_velocity_rot
  use def_vector_phi
  use make_array_3d
  use interface_grgrad_4th_gridpoint
  use interface_grgrad_4th_gridpoint_bhex
  use interface_grgrad_midpoint_r3rd_nsbh
  use interface_grgrad_midpoint_r3rd_type0_ns
  use interface_grgrad_midpoint_r3rd_type0_bh
  use interface_interpo_linear_type0
  implicit none
  real(long), pointer :: HaC_vio(:,:,:), Lapla_psi(:,:,:)
  real(long), pointer :: dpsidx(:,:,:), dpsidy(:,:,:), dpsidz(:,:,:)
  real(long) :: emdgc, rhogc, pregc, hhgc, utgc, rhoHc, zfac
  real(long) :: psigc, alpgc, alpsigc, aijaij, ene, jomeg_intgc, omegc
  real(long) :: vphig(3), ovdgc(3), bvxdgc, bvydgc, bvzdgc
  real(long) :: vepxgc, vepygc, vepzgc, lam
  real(long) :: wxgc, wygc, wzgc, psigc4, psigcp, alpgc2, dvep2, wdvep, w2, &
       &        wterm, uih2, hut  
  real(long) :: dxafn,dyafn,dzafn
  real(long) :: d2psidxx,d2psidxy,d2psidxz
  real(long) :: d2psidyx,d2psidyy,d2psidyz
  real(long) :: d2psidzx,d2psidzy,d2psidzz
  integer    :: irg, itg, ipg
  character(len=2), intent(in) :: cobj
!
  call alloc_array3d(Lapla_psi,0,nrg,0,ntg,0,npg)
  call alloc_array3d(dpsidx   ,0,nrg,0,ntg,0,npg)
  call alloc_array3d(dpsidy   ,0,nrg,0,ntg,0,npg)
  call alloc_array3d(dpsidz   ,0,nrg,0,ntg,0,npg)
!
  if(cobj=='ns') then
!
  do ipg = 0, npg
    do itg = 0, ntg
      do irg = 0, nrg
        call grgrad_4th_gridpoint(psi,dxafn,dyafn,dzafn,irg,itg,ipg)
        dpsidx(irg,itg,ipg) = dxafn
        dpsidy(irg,itg,ipg) = dyafn
        dpsidz(irg,itg,ipg) = dzafn
      end do
    end do
  end do

  do ipg = 1, npg
    do itg = 1, ntg
      do irg = 1, nrg
        call grgrad_midpoint_r3rd_type0_ns(dpsidx,d2psidxx,d2psidxy,d2psidxz,irg,itg,ipg)
        call grgrad_midpoint_r3rd_type0_ns(dpsidy,d2psidyx,d2psidyy,d2psidyz,irg,itg,ipg)
        call grgrad_midpoint_r3rd_type0_ns(dpsidz,d2psidzx,d2psidzy,d2psidzz,irg,itg,ipg)
        Lapla_psi(irg,itg,ipg) = d2psidxx + d2psidyy + d2psidzz
      end do
    end do
  end do
!
  else
!
  do ipg = 0, npg
    do itg = 0, ntg
      do irg = 0, nrg
        call grgrad_4th_gridpoint_bhex(psi,dxafn,dyafn,dzafn,irg,itg,ipg)
        dpsidx(irg,itg,ipg) = dxafn
        dpsidy(irg,itg,ipg) = dyafn
        dpsidz(irg,itg,ipg) = dzafn
      end do
    end do
  end do

  do ipg = 1, npg
    do itg = 1, ntg
      do irg = 1, nrg
        call grgrad_midpoint_r3rd_type0_bh(dpsidx,d2psidxx,d2psidxy,d2psidxz,irg,itg,ipg)
        call grgrad_midpoint_r3rd_type0_bh(dpsidy,d2psidyx,d2psidyy,d2psidyz,irg,itg,ipg)
        call grgrad_midpoint_r3rd_type0_bh(dpsidz,d2psidzx,d2psidzy,d2psidzz,irg,itg,ipg)
        Lapla_psi(irg,itg,ipg) = d2psidxx + d2psidyy + d2psidzz
      end do
    end do
  end do
!
  end if


  do ipg = 1, npg
    do itg = 1, ntg
      do irg = 1, nrg
        call interpo_linear_type0(emdgc,emdg,irg,itg,ipg)
        call interpo_linear_type0(vepxgc ,vepxg ,irg,itg,ipg)
        call interpo_linear_type0(vepygc ,vepyg ,irg,itg,ipg)
        call interpo_linear_type0(vepzgc ,vepzg ,irg,itg,ipg)
        call interpo_linear_type0(jomeg_intgc,jomeg_int,irg,itg,ipg)
        call interpo_linear_type0(psigc,psi,irg,itg,ipg)
        call interpo_linear_type0(alpgc,alph,irg,itg,ipg)
        call interpo_linear_type0(bvxdgc,bvxd,irg,itg,ipg)
        call interpo_linear_type0(bvydgc,bvyd,irg,itg,ipg)
        call interpo_linear_type0(bvzdgc,bvzd,irg,itg,ipg)
        call interpo_linear_type0(wxgc,wxspg,irg,itg,ipg)
        call interpo_linear_type0(wygc,wyspg,irg,itg,ipg)
        call interpo_linear_type0(wzgc,wzspg,irg,itg,ipg)

        aijaij = tfkijkij(irg,itg,ipg)
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
   
        rhoHc = hhgc*rhogc*(alpgc*utgc)**2 - pregc
!
        HaC_vio(irg,itg,ipg) = - 0.125d0*psigc**5*aijaij &
      &       - radi**2*2.0d0*pi*psigc**5*rhoHc*zfac  - Lapla_psi(irg,itg,ipg)
        HaC_vio(irg,itg,ipg) = 8.0d0*HaC_vio(irg,itg,ipg)/(psigc**5)
      end do
    end do
  end do

  deallocate(dpsidx)
  deallocate(dpsidy)
  deallocate(dpsidz)
  deallocate(Lapla_psi)

end subroutine violation_midpoint_HaC_CF_peos_spin

