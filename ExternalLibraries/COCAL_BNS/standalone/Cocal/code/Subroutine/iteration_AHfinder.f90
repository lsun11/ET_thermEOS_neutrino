subroutine iteration_AHfinder(iter_count)
  use phys_constant, only :  long
  use grid_parameter
  use def_horizon, only : ahz
  use make_array_2d
  use make_array_3d
  use interface_sourceterm_AHfinder
  use interface_poisson_solver_AHfinder
  use interface_update_surface
  use interface_error_surface
  implicit none
  real(long), pointer :: sou(:,:), pot(:,:), pot_bak(:,:)
  real(long) :: count, error_ahz
  real(long) :: conv_ahz, conv0_ahz = 0.5d0, conv0_ini = 0.2d0
  integer    :: iter_count, flag=0
!
  call alloc_array2d(sou,0,ntg,0,npg)
  call alloc_array2d(pot,0,ntg,0,npg)
  call alloc_array2d(pot_bak,0,ntg,0,npg)
!
  iter_count = 0
!
  do
    iter_count = iter_count + 1
    count = dble(iter_count)
!    conv_gra = dmin1(conv0_gra,conv_ini*count)
    conv_ahz = dmin1(conv0_ahz,conv0_ini*count)
!
! --- Compute source terms.
    sou = 0.0d0 ; pot = 0.0d0
    call sourceterm_AHfinder(sou)
    call poisson_solver_AHfinder(sou,pot)
    pot_bak(0:ntg,0:npg) = ahz(0:ntg,0:npg)
!    call update_surface(pot,ahz,conv_gra)
    call update_surface(pot,ahz,conv_ahz)
    call error_surface(pot_bak,ahz,error_ahz,flag)
!
    call printout_error(iter_count,error_ahz)
    if (flag==0) exit
    if (iter_count >= iter_max) exit
    flag = 0
  end do
!
  deallocate(sou)
  deallocate(pot)
  deallocate(pot_bak)
end subroutine iteration_AHfinder
