subroutine poisson_solver_homogeneous_sol_spin(surp,vpot_b)
  use phys_constant, only :  long, nmpt
  use grid_parameter, only : nrf, ntf, npf, nlg
  use def_metric_on_SFC_CF
  use coordinate_grav_r
  use trigonometry_grav_theta, only : hcosecthg
  use trigonometry_grav_phi, only : sinmpg, hsinmpg, hcosmpg
  use def_matter
  use def_velocity_rot
  use def_velocity_potential
  use def_matter_parameter, only : emdc, radi, ome, confpow
  use def_vector_phi, only : hvec_phif_surface
  use legendre_fn_grav, only : yplmg, hyplmg, hdtyplmg
  use interface_interpo_linear_surface_type0
  use interface_flgrad_midpoint_surface_type0
  use interface_flgrad_midpoint_type0_2Dsurf_sph
  use interface_interpo_linear_type0_2Dsurf
  use interface_calc_surface_normal_midpoint
  use interface_minv
  use make_array_1d
  use make_array_2d
  implicit none
  real(long), pointer :: surp(:,:), vpot_b(:,:,:)
  real(long), pointer :: sgg(:), gg(:,:)
!  real(long) :: hhxxu, hhxyu, hhxzu, hhyxu, hhyyu, hhyzu, &
!  &             hhzxu, hhzyu, hhzzu
!  real(long) :: gamxxu, gamxyu, gamxzu, gamyxu, gamyyu, gamyzu, &
!  &             gamzxu, gamzyu, gamzzu
  real(long) :: dxvep, dyvep, dzvep, dtrs, dprs, hrs
  real(long) :: rnr, rnth, rnphi, rnx, rny, rnz, flm, fllmm, surf
  real(long) :: erx, ery, erz, ethx, ethy, ethz, ephix, ephiy, ephiz
  integer    :: ir, it, ip, nbou, imm, ivec, im, ill, il, ieqs
  real(long) :: psifc, alphfc, bvxdfc, bvydfc, bvzdfc
  real(long) :: rotshx, rotshy, rotshz
  real(long) :: emdfc, utfc, hhfc, prefc, rhofc, enefc, abin, abct
  real(long) :: hhut, pfinv, pf2inv, psif4
  real(long) :: wxs,wys,wzs,psif4p
  integer    ::  ii,jj

!  write(6,*) ""
!  write(6,*) confpow, wxspf(nrf,ntf/2,0), wyspf(nrf,ntf/2,0), wzspf(nrf,ntf/2,0)
!
! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
!     Coefficients of harmonic solution is computed.
! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
!
  nbou = (nlg/2+1)*nlg/2
  call alloc_array1d(sgg,1,nbou+1)
  call alloc_array2d(gg,1,nbou+1,1,nbou+1)
!
  sgg(1:nbou+1) = 0.0d0
   gg(1:nbou+1,1:nbou+1) = 0.0d0
  alm(1:nlg,1:nlg) = 0.0d0
!
! --- Boundary equations are solved.
!
  ir = nrf
  ieqs = 0
  do il = 1, nlg
    do im = 2-mod(il,2), il, 2
      ieqs = ieqs + 1
!
      do ip = 1, npf
        do it = 1, ntf
!
          call interpo_linear_surface_type0(emdfc,emd,ir,it,ip)
          call interpo_linear_surface_type0(utfc,utf,ir,it,ip)
          call peos_q2hprho(emdfc, hhfc, prefc, rhofc, enefc)
          hhut = hhfc*utfc
          call interpo_linear_surface_type0(psifc,psif,ir,it,ip)
          psif4 = psifc**4
          psif4p= psifc**(4.0d0+confpow)

          call flgrad_midpoint_type0_2Dsurf_sph(rs,dtrs,dprs,it,ip)

          call interpo_linear_type0_2Dsurf(hrs,rs,it,ip)
          call calc_surface_normal_midpoint(rs,rnx,rny,rnz,it,ip)

          call interpo_linear_surface_type0(bvxdfc,bvxdf,ir,it,ip)
          call interpo_linear_surface_type0(bvydfc,bvydf,ir,it,ip)
          call interpo_linear_surface_type0(bvzdfc,bvzdf,ir,it,ip)
          rotshx = bvxdfc + ome*hvec_phif_surface(it,ip,1)
          rotshy = bvydfc + ome*hvec_phif_surface(it,ip,2)
          rotshz = bvzdfc + ome*hvec_phif_surface(it,ip,3)
!
          call interpo_linear_surface_type0(wxs,wxspf,ir,it,ip)
          call interpo_linear_surface_type0(wys,wyspf,ir,it,ip)
          call interpo_linear_surface_type0(wzs,wzspf,ir,it,ip)
!
          flm = dble(il)*hrs**(il-1)*hyplmg(il,im,it)*hsinmpg(im,ip) - &
          &     hrs**(il-2)*dtrs*hdtyplmg(il,im,it)*hsinmpg(im,ip) -  &
          &     hrs**(il-2)*hcosecthg(it)**2*dprs*hyplmg(il,im,it)*    &
          &     dble(im)*hcosmpg(im,ip)
!
          sgg(ieqs) = sgg(ieqs) + ( - surp(it,ip) +    &
          &   hhut*psif4*(rotshx*rnx + rotshy*rny + rotshz*rnz)  &
          &              - psif4p*(wxs*rnx + wys*rny + wzs*rnz) )*flm
!
          ivec = 0
          do ill = 1, nlg
            do imm = 2-mod(ill,2), ill, 2
              ivec = ivec + 1
!
              fllmm =  &
              & dble(ill)*hrs**(ill-1)*hyplmg(ill,imm,it)*hsinmpg(imm,ip) - &
              & hrs**(ill-2)*dtrs*hdtyplmg(ill,imm,it)*hsinmpg(imm,ip) -    &
              & hrs**(ill-2)*hcosecthg(it)**2*dprs*hyplmg(ill,imm,it)*      &
              & dble(imm)*hcosmpg(imm,ip)
!
              gg(ieqs,ivec) = gg(ieqs,ivec) + fllmm*flm
!
            end do
          end do
!
          if(ivec.ne.nbou) write(6,*) ' harmonic ivec wrong ', ivec, nbou
!
        end do
      end do
!
    end do
  end do
!
  if(ieqs.ne.nbou) write(6,*) ' harmonic ieqs wrong ', ieqs, nbou
!
!  do ii=1,5
!    do jj=1,5
!      write(6,*) gg(ii,jj)
!    end  do
!  end do
!
!  do ii=1,5
!    write(6,*)  "*************", sgg(ii)
!  end do

  call minv(gg,sgg,nbou,nbou+1)
!
!  do ii=1,5
!    write(6,*)  nbou, sgg(ii)
!  end do

  ieqs = 0
  do il = 1, nlg
    do im = 2-mod(il,2), il, 2
      ieqs = ieqs + 1
      alm(il,im) = sgg(ieqs)
    end do
  end do
  if(ieqs.ne.nbou) write(6,*) ' harmonic alm wrong ', ieqs, nbou

!
! --  calculate homogeneous part.
!
  do ip = 0, npf
    do it = 0, ntf
      do ir = 0, nrf
!
        surf = 0.0d0
        do il = 1, nlg
          do im = 2-mod(il,2), il, 2
            surf = surf + alm(il,im)*(rg(ir)*rs(it,ip))**il*   &
            &             yplmg(il,im,it)*sinmpg(im,ip) 
         end do
        end do
!
        vpot_b(ir,it,ip) = surf
!
      end do
    end do
  end do

!
!  if (iter.eq.itmx) then
!    do 141 il = 1, nlg
!      do 141 im = 2-mod(il,2), il, 2
!      write(24,*)il,im,alm(il,im)
! 141  continue
!      end if
!
  deallocate(sgg)
  deallocate(gg)
!
end subroutine poisson_solver_homogeneous_sol_spin
