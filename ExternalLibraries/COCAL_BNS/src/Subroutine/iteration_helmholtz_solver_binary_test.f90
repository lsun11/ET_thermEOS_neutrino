subroutine iteration_helmholtz_solver_binary_test(iter_count)
  use phys_constant, only :  long, nnrg, nntg, nnpg, nmpt
  use grid_parameter
  use coordinate_grav_r
  use coordinate_grav_phi
  use coordinate_grav_theta
  use weight_midpoint_grav
  use def_metric, only : psi
  use def_matter, only : emd, emdg
  use make_array_2d
  use make_array_3d
  use interface_update_grfield
  use interface_error_metric_type0
  use interface_interpo_fl2gr
  use interface_sourceterm_insurf_asymptotic_patch
  use interface_sourceterm_helmholtz_solver_test
  use interface_helmholtz_solver_binary
  use interface_helmholtz_solver_asymptotic_patch_homosol
  implicit none
  real(long), pointer :: sou(:,:,:), pot(:,:,:), psi_bak(:,:,:)
  real(long), pointer :: sou_insurf(:,:), dsou_insurf(:,:)
  real(long) :: error_psi, count
  integer    :: iter_count, flag = 0, flag0 = 0, impt, impt_bin
  integer    :: irf, itf, ipf, irg, itg, ipg, ihy
!
  call set_allocate_size_mpt
!
  call alloc_array2d(sou_insurf,0,ntg,0,npg)
  call alloc_array2d(dsou_insurf,0,ntg,0,npg)
  call alloc_array3d(sou,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot,0,nrg,0,ntg,0,npg)
  call alloc_array3d(psi_bak,0,nrg,0,ntg,0,npg)
! 
  iter_count = 0
  do
    iter_count = iter_count + 1      
    count = dble(iter_count) 
!
    do impt = 1, nmpt
      call copy_grid_parameter_from_mpt(impt)
      conv_gra = dmin1(conv0_gra,conv_ini*count)
      conv_den = dmin1(conv0_den,conv_ini*count)
      call copy_grid_parameter_to_mpt(impt)
!
      call copy_from_mpatch_helmholtz_test(impt)
      call calc_vector_x_grav(0)
      call calc_vector_x_matter(0)
      call calc_vector_phi_grav(0)
      call calc_vector_phi_matter(0)
      call copy_to_mpatch_helmholtz_test(impt)
! --
      call copy_from_mpatch_helmholtz_test(impt)
      call copy_metric_and_matter_BHNS_test_from_mpt(impt)
      if (impt.eq.1) then
        call sourceterm_helmholtz_solver_test(sou)
        call helmholtz_solver_binary(psi,sou,pot)
      end if
      if (impt.eq.2) then
        sou = 0.0d0
        impt_bin = 1
        call copy_from_mpatch_helmholtz_test(impt_bin)
        call copy_metric_and_matter_BHNS_test_from_mpt(impt_bin)
        call sourceterm_insurf_asymptotic_patch(impt_bin,impt,psi, &
        &                                       sou_insurf,dsou_insurf)
        call copy_from_mpatch_helmholtz_test(impt)
        call copy_metric_and_matter_BHNS_test_from_mpt(impt)
        call helmholtz_solver_asymptotic_patch_homosol(psi,sou,&
        &                                       sou_insurf,dsou_insurf,pot)
      end if
! --
      psi_bak(0:nrg,0:ntg,0:npg) = psi(0:nrg,0:ntg,0:npg)
      call update_grfield(pot,psi,conv_gra)
      if (impt.eq.1) call error_metric_type0(psi,psi_bak,error_psi,flag0,'ns')
      if (impt.eq.2) call error_metric_type0(psi,psi_bak,error_psi,flag0,'bh')
      flag = flag + flag0
      call printout_error_metric(iter_count,error_psi)
      call copy_to_mpatch_helmholtz_test(impt)
      call copy_metric_and_matter_BHNS_test_to_mpt(impt)
    end do
!
    if (flag == 0) exit
    if (iter_count >= iter_max) exit
    if (iter_count >= 20 .and. error_psi > 1.5d0) exit
    flag  = 0
    flag0 = 0
  end do
!
  deallocate(sou)
  deallocate(sou_insurf)
  deallocate(dsou_insurf)
  deallocate(pot)
  deallocate(psi_bak)
end subroutine iteration_helmholtz_solver_binary_test
