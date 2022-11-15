subroutine source_vep_CF_peos_v1(souv)
  use phys_constant, only  : long
  use grid_parameter, only : nrf, ntf, npf
  use def_metric_on_SFC_CF
  use def_matter
  use def_matter_parameter, only : ome, ber
  use def_vector_phi, only : hvec_phif, vec_phif
  use def_velocity_rot
  use def_velocity_potential
  use interface_interpo_linear_type0
  use interface_flgrad_midpoint_type0
  use interface_flgrad_4th_gridpoint
  use make_array_3d
  implicit none
  real(long), pointer :: souv(:,:,:)
  real(long), pointer :: sou(:,:,:), hut(:,:,:), aloh(:,:,:)
  real(long), pointer :: wx(:,:,:), wy(:,:,:), wz(:,:,:)
  real(long) :: psifc, alphfc, bvxdfc, bvydfc, bvzdfc
  real(long) :: rotshx, rotshy, rotshz
  real(long) :: emdfc, utfc, hhfc, prefc, rhofc, enefc, abin, abct
  real(long) :: hhut, pfinv, pf2inv, pf4
  real(long) :: dxemd, dyemd, dzemd, dxpsi, dypsi, dzpsi
  real(long) :: dxvpd, dyvpd, dzvpd, hwx, hwy, hwz
  real(long) :: dxhut, dyhut, dzhut, wdpsi, wdaloh, divw
  real(long) :: dxaloh, dyaloh, dzaloh
  real(long) :: dxwx, dywx, dzwx, dxwy, dywy, dzwy, dxwz, dywz, dzwz
  real(long) :: dxbvxd, dybvxd, dzbvxd, dxbvyd, dybvyd, dzbvyd, &
  &             dxbvzd, dybvzd, dzbvzd, divbvf
  real(long) :: vphif(3)
  real(long) :: ovdfc(3), ovdfc2
  real(long) :: dxvep, dyvep, dzvep, lam, alpfc2, souc

!  real(long) :: gcx, gcy, gcz
!  real(long) :: dabvep(3,3)
  integer :: ir, it, ip, irf,itf,ipf
!
  call alloc_array3d(sou , 0, nrf, 0, ntf, 0, npf)
  call alloc_array3d(hut , 0, nrf, 0, ntf, 0, npf)
  call alloc_array3d(aloh, 0, nrf, 0, ntf, 0, npf)
  call alloc_array3d(wx,   0, nrf, 0, ntf, 0, npf)
  call alloc_array3d(wy,   0, nrf, 0, ntf, 0, npf)
  call alloc_array3d(wz,   0, nrf, 0, ntf, 0, npf)
!
  do ip = 0, npf
    do it = 0, ntf
      do ir = 0, nrf
        psifc = psif(ir,it,ip)
        alphfc= alphf(ir,it,ip)
        emdfc = emd(ir,it,ip)
!
        call peos_q2hprho(emdfc, hhfc, prefc, rhofc, enefc)

        vphif(1) = vec_phif(ir,it,ip,1)
        vphif(2) = vec_phif(ir,it,ip,2)
        vphif(3) = vec_phif(ir,it,ip,3)

        ovdfc(1) = bvxdf(ir,it,ip) + ome*vphif(1)
        ovdfc(2) = bvydf(ir,it,ip) + ome*vphif(2)
        ovdfc(3) = bvzdf(ir,it,ip) + ome*vphif(3)

        call flgrad_4th_gridpoint(vep,dxvep,dyvep,dzvep,ir,it,ip)

        alpfc2 = alphfc**2
        lam    = ber + ovdfc(1)*dxvep + ovdfc(2)*dyvep + ovdfc(3)*dzvep

        hut(ir,it,ip) = lam/alpfc2

        utf(ir,it,ip) = hut(ir,it,ip)/hhfc

        aloh(ir,it,ip) = dlog(alphfc*rhofc/hhfc)
        wx(ir,it,ip) = vrot(ir,it,ip,1)
        wy(ir,it,ip) = vrot(ir,it,ip,2)
        wz(ir,it,ip) = vrot(ir,it,ip,3)
      end do
    end do
  end do
!
! =================================
!     Equation of continuity.
!     Homogeneous solution.
! =================================
! ----
!     Source term.
! ----
!
  do ip = 0, npf
    do it = 0, ntf
      do ir = 0, nrf
        rotshx = bvxdf(ir,it,ip) + ome*vec_phif(ir,it,ip,1)
        rotshy = bvydf(ir,it,ip) + ome*vec_phif(ir,it,ip,2)
        rotshz = bvzdf(ir,it,ip) + ome*vec_phif(ir,it,ip,3)
!
        psifc = psif(ir,it,ip)
        pfinv = 1.0d0/psifc
        pf2inv = pfinv**2
        pf4 = psifc**4
!
        call flgrad_4th_gridpoint(psif,dxpsi, dypsi, dzpsi, ir,it,ip)
        call flgrad_4th_gridpoint( vep,dxvpd, dyvpd, dzvpd, ir,it,ip)
        call flgrad_4th_gridpoint( hut,dxhut, dyhut, dzhut, ir,it,ip)
        call flgrad_4th_gridpoint(aloh,dxaloh,dyaloh,dzaloh,ir,it,ip)
!
        if(ir==nrf) then
          sou(ir,it,ip) = - 2.0d0*pfinv*(dxvpd*dxpsi + dyvpd*dypsi + dzvpd*dzpsi)      &
            &              + pf4*(rotshx*dxhut + rotshy*dyhut + rotshz*dzhut)      
        else
          sou(ir,it,ip) = - 2.0d0*pfinv*(dxvpd*dxpsi + dyvpd*dypsi + dzvpd*dzpsi)      &
            &              + pf4*(rotshx*dxhut + rotshy*dyhut + rotshz*dzhut)   &
            &              + (pf4*hhut*rotshx - dxvpd)*dxaloh    &
            &              + (pf4*hhut*rotshy - dyvpd)*dyaloh    &
            &              + (pf4*hhut*rotshz - dzvpd)*dzaloh
        end if
      end do
    end do
  end do
!
  do ip = 1, npf
    do it = 1, ntf
      do ir = 1, nrf
        call interpo_linear_type0(souc,sou,ir,it,ip)
        souv(ir,it,ip) = souc
      end do
    end do
  end do
!
  deallocate(sou)
  deallocate(hut)
  deallocate(aloh)
  deallocate(wx)
  deallocate(wy)
  deallocate(wz)

end subroutine source_vep_CF_peos_v1
