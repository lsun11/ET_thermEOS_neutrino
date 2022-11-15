subroutine iteration_helmholtz_solver_binary_test(iter_count)
  use phys_constant, only :  long, nnrg, nntg, nnpg
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
  use interface_error_metric
  use interface_interpo_fl2gr
  use interface_sourceterm_helmholtz_solver_test
  use interface_helmholtz_solver_binary
  implicit none
  real(long), pointer :: sou(:,:,:), pot(:,:,:), psi_bak(:,:,:)
  real(long), pointer :: sou_exsurf(:,:), dsou_exsurf(:,:)
  real(long) :: error_psi, count
  integer    :: iter_count, flag = 0
  integer    :: irf, itf, ipf, irg, itg, ipg, ihy
!
  call alloc_array3d(sou,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot,0,nrg,0,ntg,0,npg)
  call alloc_array3d(psi_bak,0,nrg,0,ntg,0,npg)
! 
  iter_count = 0
  do
    iter_count = iter_count + 1      
    count = dble(iter_count) 
    conv_gra = dmin1(conv0_gra,conv_ini*count)
    conv_den = dmin1(conv0_den,conv_ini*count)
!
    call calc_vector_x_grav(0)
    call calc_vector_x_matter(0)
    call calc_vector_phi_grav(0)
    call calc_vector_phi_matter(0)
! --
    call sourceterm_helmholtz_solver_test(sou)
    call helmholtz_solver_binary(psi,sou,pot)
    psi_bak = psi
    call update_grfield(pot,psi,conv_gra)
    call error_metric(psi,psi_bak,error_psi,flag)
    call printout_error_metric(iter_count,error_psi)
!
    if (flag == 0) exit
    if (iter_count >= iter_max) exit
    flag = 0
  end do
!
  deallocate(sou)
  deallocate(pot)
  deallocate(psi_bak)
end subroutine iteration_helmholtz_solver_binary_test
