subroutine violation_gridpoint_HaC_CF_peos_corot(HaC_vio,cobj)
  use phys_constant, only : long, pi
  use grid_parameter, only : nrg, ntg, npg
  use def_metric
  use def_metric_excurve_grid
  use def_matter, only : emdg, omeg, jomeg_int
  use def_matter_parameter, only : ome, ber, radi
  use def_vector_phi
  use make_array_3d
  use interface_grgrad_4th_gridpoint
  use interface_grgrad_4th_gridpoint_bhex
  use interface_grgrad_midpoint_r3rd_nsbh
  use interface_grgrad_midpoint_r3rd_type0_ns
  use interface_grgrad_midpoint_r3rd_type0_bh
  use interface_grgrad_gridpoint
  use interface_grgrad_gridpoint_bhex
  use interface_interpo_linear_type0
  implicit none
  real(long), pointer :: HaC_vio(:,:,:), Lapla_psi(:,:,:)
  real(long), pointer :: dpsidx(:,:,:), dpsidy(:,:,:), dpsidz(:,:,:)
  real(long) :: emdgc, rhogc, pregc, hhgc, utgc, rhoHc, zfac
  real(long) :: psigc, alpgc, alpsigc, aijaij, ene, omegc, jomeg_intgc
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
  if (cobj=='ns')  then
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

  do ipg = 0, npg
    do itg = 0, ntg
      do irg = 0, nrg
        call grgrad_4th_gridpoint(dpsidx,d2psidxx,d2psidxy,d2psidxz,irg,itg,ipg)
        call grgrad_4th_gridpoint(dpsidy,d2psidyx,d2psidyy,d2psidyz,irg,itg,ipg)
        call grgrad_4th_gridpoint(dpsidz,d2psidzx,d2psidzy,d2psidzz,irg,itg,ipg)
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

  do ipg = 0, npg
    do itg = 0, ntg
      do irg = 0, nrg
        call grgrad_4th_gridpoint_bhex(dpsidx,d2psidxx,d2psidxy,d2psidxz,irg,itg,ipg)
        call grgrad_4th_gridpoint_bhex(dpsidy,d2psidyx,d2psidyy,d2psidyz,irg,itg,ipg)
        call grgrad_4th_gridpoint_bhex(dpsidz,d2psidzx,d2psidzy,d2psidzz,irg,itg,ipg)
        Lapla_psi(irg,itg,ipg) = d2psidxx + d2psidyy + d2psidzz
      end do
    end do
  end do
!
  end if

  do ipg = 0, npg
    do itg = 0, ntg
      do irg = 0, nrg
        emdgc    = emdg(irg,itg,ipg)
        jomeg_intgc = jomeg_int(irg,itg,ipg)
        psigc    = psi(irg,itg,ipg)
        alpgc    = alph(irg,itg,ipg)
        aijaij = tfkijkij_grid(irg,itg,ipg)
        zfac = 1.0d0
        if (emdgc <= 1.0d-15) then 
          emdgc = 1.0d-15
          zfac  = 0.0d0
        end if
        call peos_q2hprho(emdgc, hhgc, pregc, rhogc, ene)
        utgc  = hhgc/ber*exp(jomeg_intgc)
        rhoHc = hhgc*rhogc*(alpgc*utgc)**2 - pregc
!
        HaC_vio(irg,itg,ipg) = - 0.125d0*psigc**5*aijaij &
      &            - radi**2*2.0d0*pi*psigc**5*rhoHc*zfac - Lapla_psi(irg,itg,ipg)
        HaC_vio(irg,itg,ipg) = 8.0d0*HaC_vio(irg,itg,ipg)/(psigc**5)
      end do
    end do
  end do
!
  deallocate(dpsidx)
  deallocate(dpsidy)
  deallocate(dpsidz)
  deallocate(Lapla_psi)

end subroutine violation_gridpoint_HaC_CF_peos_corot

