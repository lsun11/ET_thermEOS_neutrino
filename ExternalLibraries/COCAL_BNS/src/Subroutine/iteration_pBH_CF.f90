subroutine iteration_pBH_CF(iter_count)
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
  use def_metric_pBH
!
  use def_metric_excurve_grid, only : tfkij_grid, tfkijkij_grid
  use def_matter
  use def_bh_parameter, only : bh_bctype
  use def_vector_bh
  use interface_poisson_solver
  use interface_poisson_solver_1bh_homosol
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
  use interface_sourceterm_HaC_CF_pBH
  use interface_sourceterm_trG_CF
  use interface_sourceterm_trG_CF_pBH
  use interface_sourceterm_MoC_CF
  use interface_sourceterm_MoC_CF_type1_bhex
  use interface_sourceterm_Bfun
  use interface_interpolation_fillup_binary_parity
  use interface_sourceterm_exsurf_eqm_binary_parity
  use interface_compute_shift_v2
  use interface_compute_dBfun
  use interface_compute_wme2psi
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
  real(long) :: pari, pot_tmp
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
  do
    iter_count = iter_count + 1      
    count = dble(iter_count) 
    conv_gra = dmin1(conv0_gra,conv_ini*count)
    conv_den = dmin1(conv0_den,conv_ini*count)
!---
    call calc_vector_x_grav(1)
    call calc_vector_phi_grav(1)
!2bh    call excurve
    call excurve_TrpBH
    call calc_TrpBH
!2bh    call excurve_CF_gridpoint_bhex
!---
!
    call compute_psi2wme
    sou(0:nrg,0:ntg,0:npg) = 0.0d0
    call sourceterm_HaC_CF_pBH(sou)
!
    call poisson_solver(sou,pot)  ! solve for log(wme)
    pot(0,0:ntg,0:npg) = -30.0d0
    pot = dexp(pot)
    call compute_wme2psi(pot)  ! transform wme to psi
!
    pot_bak = psi
    call update_grfield(pot,psi,conv_gra)
    call error_metric_type0(psi,pot_bak,error_psi,flag_psi,'bh')
!---
!
    call compute_psi2wme
    sou(0:nrg,0:ntg,0:npg) = 0.0d0
    call sourceterm_trG_CF_pBH(sou)
!
    call poisson_solver(sou,pot)  ! solve for log(alpha**(1/sqrt(2)))
    pot(0,0:ntg,0:npg) = -30.0d0
    pot = dexp(pot)**dsqrt(2.0d0)
!
    pot_bak = alph
    call update_grfield(pot,alph,conv_gra)
    call error_metric_type0(alph,pot_bak,error_alph,flag_alph,'bh')
!
!p itg = 2; ipg = 2
!p do irg = 0, nrg
!p !write(6,*)rg(irg), Nwme(irg,itg,ipg),  wme(irg,itg,ipg)
!p write(6,*)rg(irg), 1.0d0/psi(irg,itg,ipg)**index_wme, &
!p                    1.0d0/psi_trpBH(irg)**index_wme, &
!p                    alph(irg,itg,ipg), &
!p !                   1.0d0/(alph_trpBH(irg)*psi_trpBH(irg)**2)**index_wme, &
!p                    alph_trpBH(irg)
!p end do
!---
!
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

end subroutine iteration_pBH_CF
