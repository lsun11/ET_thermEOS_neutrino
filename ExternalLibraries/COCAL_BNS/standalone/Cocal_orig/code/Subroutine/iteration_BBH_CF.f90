subroutine iteration_BBH_CF(iter_count)
  use phys_constant, only :  long
  use grid_parameter
  use coordinate_grav_r
  use coordinate_grav_phi
  use coordinate_grav_theta
  use weight_midpoint_grav
  use make_array_2d
  use make_array_3d
  use make_array_4d
  use def_metric

  use def_metric_excurve_grid, only : tfkij_grid, tfkijkij_grid
  use def_matter
  use def_bh_parameter, only : bh_bctype
  use def_vector_bh
  use interface_poisson_solver_binary_bhex_homosol
  use interface_sourceterm_exsurf_eqm_binary
  use interface_sourceterm_surface_int
  use interface_compute_shift
  use interface_compute_alps2alph
  use interface_update_grfield
  use interface_update_parameter
  use interface_error_metric_type0
  use interface_error_metric_type2
  use interface_interpolation_fillup_binary
!
  use interface_bh_boundary_d_psi
  use interface_bh_boundary_nh_psi_test
  use interface_bh_boundary_d_alps
  use interface_bh_boundary_CF
  use interface_bh_boundary_AH_d_psi
  use interface_bh_boundary_AH_n_psi
  use interface_bh_boundary_AH_r_psi
  use interface_bh_boundary_AH_d_alps
  use interface_bh_boundary_AH_n_alps
  use interface_outer_boundary_d_psi
  use interface_outer_boundary_d_alps
  use interface_outer_boundary_d_bvxd
  use interface_outer_boundary_d_bvyd
  use interface_outer_boundary_d_bvzd
  use interface_outer_boundary_d_Bfun
  use interface_outer_boundary_n_Bfun
  use interface_outer_boundary_d_potx
  use interface_outer_boundary_d_poty
  use interface_outer_boundary_d_potz
  use interface_sourceterm_HaC_CF
  use interface_sourceterm_trG_CF
  use interface_sourceterm_MoC_CF
  use interface_sourceterm_MoC_CF_type1_bhex
  use interface_sourceterm_Bfun
  use interface_interpolation_fillup_binary_parity
  use interface_sourceterm_exsurf_eqm_binary_parity
  use interface_compute_shift_v2
  use interface_compute_dBfun
  use gnufor2
!
  implicit none
  real(long), pointer :: sou(:,:,:), pot(:,:,:)
  real(long), pointer :: Bfun(:,:,:), potx(:,:,:), poty(:,:,:), potz(:,:,:) 
  real(long), pointer :: pot_bak(:,:,:), work(:,:,:)
  real(long), pointer :: potx_bak(:,:,:), poty_bak(:,:,:), potz_bak(:,:,:) 
  real(long), pointer :: dBfundx(:,:,:), dBfundy(:,:,:), dBfundz(:,:,:) 
  real(long), pointer :: souvec(:,:,:,:)
  real(long), pointer :: sou_exsurf(:,:), dsou_exsurf(:,:)
  real(long), pointer :: sou_bhsurf(:,:), dsou_bhsurf(:,:)
  real(long), pointer :: sou_outsurf(:,:), dsou_outsurf(:,:)
  real(long) :: count, error_psi,error_alph, error_bvxd, error_bvyd, error_bvzd
  real(long) :: error_potx, error_poty, error_potz, error_Bfun
  real(long) :: pari
  integer    :: iter_count, flag_psi=0, flag_alph=0, &
  &             flag_bvxd=0, flag_bvyd=0, flag_bvzd=0
  integer    :: flag_potx=0, flag_poty=0, flag_potz=0, flag_Bfun=0
  integer    :: irg, itg, ipg, ihy, nn, ii
  character(2) :: chgreen
  character(30) :: char1, char2, char3
!
  call alloc_array4d(souvec,0,nrg,0,ntg,0,npg,1,3)
  call alloc_array3d(sou,0,nrg,0,ntg,0,npg)
!  call alloc_array3d(Bfun,0,nrg,0,ntg,0,npg)
!  call alloc_array3d(dBfundx,0,nrg,0,ntg,0,npg)
!  call alloc_array3d(dBfundy,0,nrg,0,ntg,0,npg)
!  call alloc_array3d(dBfundz,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot,0,nrg,0,ntg,0,npg)
  call alloc_array3d(potx,0,nrg,0,ntg,0,npg)
  call alloc_array3d(poty,0,nrg,0,ntg,0,npg)
  call alloc_array3d(potz,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot_bak,0,nrg,0,ntg,0,npg)
  call alloc_array3d(potx_bak,0,nrg,0,ntg,0,npg)
  call alloc_array3d(poty_bak,0,nrg,0,ntg,0,npg)
  call alloc_array3d(potz_bak,0,nrg,0,ntg,0,npg)
  call alloc_array3d(work,0,nrg,0,ntg,0,npg)
  call alloc_array2d(sou_exsurf,0,ntg,0,npg)
  call alloc_array2d(dsou_exsurf,0,ntg,0,npg)
  call alloc_array2d(sou_bhsurf,0,ntg,0,npg)
  call alloc_array2d(dsou_bhsurf,0,ntg,0,npg)
  call alloc_array2d(sou_outsurf,0,ntg,0,npg)
  call alloc_array2d(dsou_outsurf,0,ntg,0,npg)
!
  iter_count = 0
!
  souvec(0:nrg,0:ntg,0:npg,1:3) = 0.0d0

!  psi(0:nrg,0:ntg,0:npg) =1.0d0
!  alph(0:nrg,0:ntg,0:npg)=1.0d0
!  alps(0:nrg,0:ntg,0:npg)=1.0d0
!  bvxd(0:nrg,0:ntg,0:npg)=0.0d0
!  bvyd(0:nrg,0:ntg,0:npg)=0.0d0
!  bvzd(0:nrg,0:ntg,0:npg)=0.0d0

!  tfkijkij(1:nrg,1:ntg,1:npg)     =0.0d0
!  tfkij(1:nrg,1:ntg,1:npg,1:3,1:3)=0.0d0

!  tfkijkij_grid(0:nrg,0:ntg,0:npg)     =0.0d0
!  tfkij_grid(0:nrg,0:ntg,0:npg,1:3,1:3)=0.0d0
!  
  do
    iter_count = iter_count + 1      
    count = dble(iter_count) 
    conv_gra = dmin1(conv0_gra,conv_ini*count)
    conv_den = dmin1(conv0_den,conv_ini*count)
!---
!    call calc_vector_x_grav(1)
!    call calc_vector_x_matter(1)
!    call calc_vector_phi_grav(1)
!    call calc_vector_phi_matter(1)
    call calc_vector_bh(2)
    call excurve
    call excurve_CF_gridpoint_bhex
!---
    sou(0:nrg,0:ntg,0:npg) = 0.0d0
    call sourceterm_HaC_CF(sou)
    call sourceterm_exsurf_eqm_binary(psi,sou_exsurf,dsou_exsurf)
    call sourceterm_surface_int(psi,0,sou_bhsurf,dsou_bhsurf)
    call sourceterm_surface_int(psi,nrg,sou_outsurf,dsou_outsurf)
!    call bh_boundary_AH_r_psi(dsou_bhsurf)
    call bh_boundary_CF(sou_bhsurf,dsou_bhsurf,'psi ')
    call outer_boundary_d_psi(sou_outsurf)
    if (bh_bctype.eq.'TU') chgreen = 'dd'
    if (bh_bctype.eq.'AH'.or.bh_bctype.eq.'PG') chgreen = 'nd'
    call poisson_solver_binary_bhex_homosol('nd',sou, &
!    call poisson_solver_binary_bhex_homosol('rd',sou, &
    &                                       sou_exsurf,dsou_exsurf, &
    &                                       sou_bhsurf,dsou_bhsurf, & 
    &                                       sou_outsurf,dsou_outsurf,pot)
    pot_bak = psi
    call update_grfield(pot,psi,conv_gra)
    call interpolation_fillup_binary(psi)
    call error_metric_type0(psi,pot_bak,error_psi,flag_psi,'bh')
!---
    sou(0:nrg,0:ntg,0:npg) = 0.0d0
    alps(0:nrg,0:ntg,0:npg) = alph(0:nrg,0:ntg,0:npg)*psi(0:nrg,0:ntg,0:npg)
    call sourceterm_trG_CF(sou)
    call sourceterm_exsurf_eqm_binary(alps,sou_exsurf,dsou_exsurf)
    call sourceterm_surface_int(alps,0,sou_bhsurf,dsou_bhsurf)
    call sourceterm_surface_int(alps,nrg,sou_outsurf,dsou_outsurf)
!    call bh_boundary_AH_d_alps(sou_bhsurf)
    call bh_boundary_CF(sou_bhsurf,dsou_bhsurf,'alps')
    call outer_boundary_d_alps(sou_outsurf)
    call poisson_solver_binary_bhex_homosol('dd',sou, &
    &                                       sou_exsurf,dsou_exsurf, &
    &                                       sou_bhsurf,dsou_bhsurf, & 
    &                                       sou_outsurf,dsou_outsurf,pot)
    call compute_alps2alph(pot,psi)
    pot_bak = alph
    call update_grfield(pot,alph,conv_gra)
    call interpolation_fillup_binary(alph)
    call error_metric_type0(alph,pot_bak,error_alph,flag_alph,'bh')
!---
    call sourceterm_MoC_CF_type1_bhex(souvec)
    do ii = 1, 3
      sou(0:nrg,0:ntg,0:npg) = souvec(0:nrg,0:ntg,0:npg,ii)
      if      (ii.eq.1) then 
        work(0:nrg,0:ntg,0:npg) = bvxd(0:nrg,0:ntg,0:npg)
        pari = -1.0d0
      else if (ii.eq.2) then
        work(0:nrg,0:ntg,0:npg) = bvyd(0:nrg,0:ntg,0:npg)
        pari = -1.0d0
      else if (ii.eq.3) then
        work(0:nrg,0:ntg,0:npg) = bvzd(0:nrg,0:ntg,0:npg)
        pari =  1.0d0
      end if
      call sourceterm_exsurf_eqm_binary_parity(work,sou_exsurf,dsou_exsurf,&
      &                                        pari)
      call sourceterm_surface_int(work,0,sou_bhsurf,dsou_bhsurf)
      call sourceterm_surface_int(work,nrg,sou_outsurf,dsou_outsurf)
      if      (ii.eq.1) then 
        call bh_boundary_CF(sou_bhsurf,dsou_bhsurf,'bvxd')
        call outer_boundary_d_bvxd(sou_outsurf)
      else if (ii.eq.2) then
        call bh_boundary_CF(sou_bhsurf,dsou_bhsurf,'bvyd')
        call outer_boundary_d_bvyd(sou_outsurf)
      else if (ii.eq.3) then
        call bh_boundary_CF(sou_bhsurf,dsou_bhsurf,'bvzd')
        call outer_boundary_d_bvzd(sou_outsurf)
      end if
     
      call poisson_solver_binary_bhex_homosol('dd',sou, &
      &                                       sou_exsurf,dsou_exsurf, &
      &                                       sou_bhsurf,dsou_bhsurf, & 
      &                                       sou_outsurf,dsou_outsurf,pot)
      if (ii.eq.1) potx(0:nrg,0:ntg,0:npg) = pot(0:nrg,0:ntg,0:npg)
      if (ii.eq.2) poty(0:nrg,0:ntg,0:npg) = pot(0:nrg,0:ntg,0:npg)
      if (ii.eq.3) potz(0:nrg,0:ntg,0:npg) = pot(0:nrg,0:ntg,0:npg)
    end do
!
    potx_bak = bvxd
    poty_bak = bvyd
    potz_bak = bvzd
    call update_grfield(potx,bvxd,conv_gra)
    call update_grfield(poty,bvyd,conv_gra)
    call update_grfield(potz,bvzd,conv_gra)
!    caalll reset_bh_boundary_CF
    call interpolation_fillup_binary_parity(bvxd,-1.0d0)
    call interpolation_fillup_binary_parity(bvyd,-1.0d0)
    call interpolation_fillup_binary_parity(bvzd,1.0d0)
    if (bh_bctype.eq.'TU') call reset_metric_CF
!    if (bh_bctype.eq.'AH') call reset_metric_CF_AH
!    call error_metric_type2(bvxd,potx_bak,error_bvxd,flag_bvxd,'bh')
!    call error_metric_type2(bvyd,poty_bak,error_bvyd,flag_bvyd,'bh')
!    call error_metric_type2(bvzd,potz_bak,error_bvzd,flag_bvzd,'bh')
    call error_metric_type0(bvxd,potx_bak,error_bvxd,flag_bvxd,'bh')
    call error_metric_type0(bvyd,poty_bak,error_bvyd,flag_bvyd,'bh')
    call error_metric_type0(bvzd,potz_bak,error_bvzd,flag_bvzd,'bh')
!---
    call printout_error_metric_combined(iter_count,error_psi,error_alph,&
    &                                  error_bvxd,error_bvyd,error_bvzd)
!
    if ((flag_psi==0).and.(flag_alph==0).and. &
    &   (flag_bvxd==0).and.(flag_bvyd==0).and.(flag_bvzd==0)) exit
    if (iter_count >= iter_max) exit
!
!    if (iter_count==5)  exit
!    if (iter_count >= 50 .and. error_psi > 1.5d0) exit
!    if (iter_count >= 50 .and. error_alph > 1.5d0) exit
!    if (iter_count >= 50 .and. error_bvxd > 1.5d0) exit
!    if (iter_count >= 50 .and. error_bvyd > 1.5d0) exit
!    if (iter_count >= 50 .and. error_bvzd > 1.5d0) exit
    flag_psi = 0
    flag_alph = 0
    flag_bvxd = 0
    flag_bvyd = 0
    flag_bvzd = 0
    flag_Bfun = 0
  end do
!
  deallocate(souvec)
  deallocate(sou)
!  deallocate(Bfun)
!  deallocate(dBfundx)
!  deallocate(dBfundy)
!  deallocate(dBfundz)
!  deallocate(potx)
!  deallocate(poty)
!  deallocate(potz)
  deallocate(pot)
  deallocate(potx)
  deallocate(poty)
  deallocate(potz)
  deallocate(pot_bak)
  deallocate(potx_bak)
  deallocate(poty_bak)
  deallocate(potz_bak)
  deallocate(work)
  deallocate(sou_exsurf)
  deallocate(dsou_exsurf)
  deallocate(sou_bhsurf)
  deallocate(dsou_bhsurf)
  deallocate(sou_outsurf)
  deallocate(dsou_outsurf)

end subroutine iteration_BBH_CF
