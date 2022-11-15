subroutine iteration_poisson_bbh_2pot_test1(iter_count)
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
  use interface_error_metric_type1
  use interface_error_metric_type2
  use interface_interpolation_fillup_binary
!
  use interface_bh_boundary_d_psi
  use interface_bh_boundary_dh_psi_test
  use interface_bh_boundary_dh_alph_test
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
  use interface_sourceterm_volume_int_bbh_2pot_test
!
  implicit none
  real(long), pointer :: sou(:,:,:), pot(:,:,:)
  real(long), pointer :: pot_bak(:,:,:), work(:,:,:)
  real(long), pointer :: sou_exsurf(:,:), dsou_exsurf(:,:)
  real(long), pointer :: sou_bhsurf(:,:), dsou_bhsurf(:,:)
  real(long), pointer :: sou_outsurf(:,:), dsou_outsurf(:,:)
  real(long) :: count, error_psi,error_alph
  real(long) :: pari
  integer    :: iter_count, flag_psi=0, flag_alph=0
  integer    :: irg, itg, ipg, ihy, nn, ii
  character(2) :: chgreen
  character(30) :: char1, char2, char3
  integer    :: ire_psi=0, ite_psi=0, ipe_psi=0, ire_alph=0, ite_alph=0, ipe_alph=0

!
  call alloc_array3d(sou,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot_bak,0,nrg,0,ntg,0,npg)
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
    call calc_vector_bh(2)
!---
    sou(0:nrg,0:ntg,0:npg) = 0.0d0
    call sourceterm_exsurf_eqm_binary(psi,sou_exsurf,dsou_exsurf)
    call sourceterm_surface_int(psi,0,sou_bhsurf,dsou_bhsurf)
    call sourceterm_surface_int(psi,nrg,sou_outsurf,dsou_outsurf)
    call bh_boundary_dh_psi_test(sou_bhsurf)
    call outer_boundary_d_psi(sou_outsurf)
    call poisson_solver_binary_bhex_homosol('dd',sou, &
    &                                       sou_exsurf,dsou_exsurf, &
    &                                       sou_bhsurf,dsou_bhsurf, & 
    &                                       sou_outsurf,dsou_outsurf,pot)
    pot_bak = psi
    call update_grfield(pot,psi,conv_gra)
    call interpolation_fillup_binary(psi)
!    call error_metric_type0(psi,pot_bak,error_psi,flag_psi,'bh')
    call error_metric_type1(psi,pot_bak,error_psi,ire_psi,ite_psi,ipe_psi,flag_psi,'bh')
!---
    sou(0:nrg,0:ntg,0:npg) = 0.0d0
    call sourceterm_volume_int_bbh_2pot_test(sou)
    call sourceterm_exsurf_eqm_binary(alph,sou_exsurf,dsou_exsurf)
    call sourceterm_surface_int(alph,0,sou_bhsurf,dsou_bhsurf)
    call sourceterm_surface_int(alph,nrg,sou_outsurf,dsou_outsurf)
    call bh_boundary_dh_alph_test(sou_bhsurf)
    call outer_boundary_d_alps(sou_outsurf)
    call poisson_solver_binary_bhex_homosol('dd',sou, &
    &                                       sou_exsurf,dsou_exsurf, &
    &                                       sou_bhsurf,dsou_bhsurf, & 
    &                                       sou_outsurf,dsou_outsurf,pot)
    pot_bak = alph
    call update_grfield(pot,alph,conv_gra)
    call interpolation_fillup_binary(alph)
!    call error_metric_type0(alph,pot_bak,error_alph,flag_alph,'bh')
    call error_metric_type1(alph,pot_bak,error_alph,ire_alph,ite_alph,ipe_alph,flag_alph,'bh')
!---
    call printout_error_all_metric(iter_count,error_psi,ire_psi,ite_psi,ipe_psi,&
           &                        error_alph,ire_alph,ite_alph,ipe_alph )
!
    if ((flag_psi==0).and.(flag_alph==0)) exit
    if (iter_count >= iter_max) exit
!
!    if (iter_count==5)  exit
!    if (iter_count >= 50 .and. error_psi > 1.5d0) exit
!    if (iter_count >= 50 .and. error_alph > 1.5d0) exit
    flag_psi = 0
    flag_alph = 0
  end do
!
  deallocate(sou)
  deallocate(pot)
  deallocate(pot_bak)
  deallocate(work)
  deallocate(sou_exsurf)
  deallocate(dsou_exsurf)
  deallocate(sou_bhsurf)
  deallocate(dsou_bhsurf)
  deallocate(sou_outsurf)
  deallocate(dsou_outsurf)

end subroutine iteration_poisson_bbh_2pot_test1
