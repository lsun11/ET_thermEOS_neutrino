subroutine iteration_poisson_bbh_2pot_test(iter_count)
  use phys_constant, only :  long, nnrg, nntg, nnpg
  use grid_parameter
  use coordinate_grav_r
  use coordinate_grav_phi
  use coordinate_grav_theta
  use weight_midpoint_grav
  use def_metric, only : psi, alph
  use make_array_2d
  use make_array_3d
  use interface_poisson_solver
  use interface_update_grfield
  use interface_error_metric_type0
  use interface_interpo_fl2gr
  use interface_sourceterm_poisson_solver_test
  use interface_sourceterm_exsurf_eqm_binary
  use interface_sourceterm_surface_int
!  use interface_sourceterm_volume_int_bbh_2pot_test
  use interface_sourceterm_2pot_test
  use interface_poisson_solver_binary_bhex_homosol
!  use interface_poisson_solver_binary_bhex
!  use interface_bh_boundary_test
  use interface_bh_boundary_nh_psi_test
  use interface_bh_boundary_nh_alph_test
  use interface_interpolation_fillup_binary

  implicit none
  real(long), pointer :: sou(:,:,:)
  real(long), pointer :: pot(:,:,:), psi_bak(:,:,:), alph_bak(:,:,:)
  real(long), pointer :: sou_exsurf(:,:), dsou_exsurf(:,:)
  real(long), pointer :: sou_bhsurf(:,:), dsou_bhsurf(:,:)
  real(long), pointer :: sou_outsurf(:,:), dsou_outsurf(:,:)
  real(long) :: error_psi, count, error_alph
  integer    :: iter_count, flag_psi = 0, flag_alph = 0
!
  call alloc_array3d(sou,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot,0,nrg,0,ntg,0,npg)
  call alloc_array3d(psi_bak,0,nrg,0,ntg,0,npg)
  call alloc_array3d(alph_bak,0,nrg,0,ntg,0,npg)
  call alloc_array2d(sou_exsurf,0,ntg,0,npg)
  call alloc_array2d(dsou_exsurf,0,ntg,0,npg)
  call alloc_array2d(sou_bhsurf,0,ntg,0,npg)
  call alloc_array2d(dsou_bhsurf,0,ntg,0,npg)
  call alloc_array2d(sou_outsurf,0,ntg,0,npg)
  call alloc_array2d(dsou_outsurf,0,ntg,0,npg)
! 
  iter_count = 0
  do
    iter_count = iter_count + 1      
    count = dble(iter_count) 
    conv_gra = dmin1(conv0_gra,conv_ini*count)
    conv_den = dmin1(conv0_den,conv_ini*count)
!
    call calc_vector_x_grav(1)
!!    call calc_vector_x_matter(1)
    call calc_vector_phi_grav(1)
!!    call calc_vector_phi_matter(1)
!
!-- For psi
!-- For BH boundary substitute Dirichlet data to  sou_bhsurf
!--                            Neumann   data to dsou_bhsurf
!
    sou(0:nrg,0:ntg,0:npg) = 0.0d0
    call reset_bh_boundary('n') ! 'd' for Dirichlet
    call sourceterm_exsurf_eqm_binary(psi,sou_exsurf,dsou_exsurf)
    call sourceterm_surface_int(psi,0,sou_bhsurf,dsou_bhsurf)
    call sourceterm_surface_int(psi,nrg,sou_outsurf,dsou_outsurf)
!    call bh_boundary_test('nh',sou_bhsurf,dsou_bhsurf)
    call bh_boundary_nh_psi_test(dsou_bhsurf)
    call poisson_solver_binary_bhex_homosol('nd',sou, &
    &                                       sou_exsurf,dsou_exsurf, &
    &                                       sou_bhsurf,dsou_bhsurf, & 
    &                                       sou_outsurf,dsou_outsurf,pot)
    psi_bak = psi
    call update_grfield(pot,psi,conv_gra)
    call interpolation_fillup_binary(psi)
    call error_metric_type0(psi,psi_bak,error_psi,flag_psi,'bh')
    call printout_error_metric(iter_count,error_psi)
    call reset_bh_boundary('n') ! 'd' for Dirichlet
!   
! Now solve for alpha also
!-- For BH boundary substitute Dirichlet data to  sou_bhsurf
!--                            Neumann   data to dsou_bhsurf
!
    sou(0:nrg,0:ntg,0:npg) = 0.0d0
!    call sourceterm_volume_int_bbh_2pot_test(sou)
    call sourceterm_2pot_test(sou)
    call sourceterm_exsurf_eqm_binary(alph,sou_exsurf,dsou_exsurf)
    call sourceterm_surface_int(alph,0,sou_bhsurf,dsou_bhsurf)
    call sourceterm_surface_int(alph,nrg,sou_outsurf,dsou_outsurf)
!    call bh_boundary_test('nh',sou_bhsurf,dsou_bhsurf)
    call bh_boundary_nh_alph_test(dsou_bhsurf)
    call poisson_solver_binary_bhex_homosol('nd',sou, &
    &                                       sou_exsurf,dsou_exsurf, &
    &                                       sou_bhsurf,dsou_bhsurf, & 
    &                                       sou_outsurf,dsou_outsurf,pot)
    alph_bak = alph
    call update_grfield(pot,alph,conv_gra)
    call interpolation_fillup_binary(alph)
    call error_metric_type0(alph,alph_bak,error_alph,flag_alph,'bh')
    call printout_error_metric(iter_count,error_alph)
    call reset_bh_boundary('n') ! 'd' for Dirichlet 
!
    if ((flag_psi==0).and.(flag_alph==0)) exit
    if (iter_count >= iter_max) exit
    if (iter_count >= 50 .and. error_psi > 1.5d0) exit
    if (iter_count >= 50 .and. error_alph > 1.5d0) exit
    flag_psi = 0
    flag_alph = 0
  end do
!
  deallocate(sou)
  deallocate(pot)
  deallocate(psi_bak)
  deallocate(alph_bak)
  deallocate(sou_exsurf)
  deallocate(dsou_exsurf)
  deallocate(sou_bhsurf)
  deallocate(dsou_bhsurf)
  deallocate(sou_outsurf)
  deallocate(dsou_outsurf)
end subroutine iteration_poisson_bbh_2pot_test
