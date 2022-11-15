subroutine poisson_solver_At(sou,pot,char_sym)
  use phys_constant,  only : long
  use grid_parameter, only : nrg, npg, ntg, npgxzm, npgxzp, ntgeq
  use def_metric, only : alph
  use make_array_3d
  use make_array_2d
  use interface_poisson_solver
  use interface_poisson_solver_At_homosol_lesq
  use interface_interpo_gr2fl_surface
  use interface_calc_integrability_modify_At
  use interface_compute_fnc_multiple
  implicit none
!
  real(long), pointer :: pot(:,:,:), sou(:,:,:)
  real(long), pointer :: pot_vol(:,:,:), pot_surf(:,:,:)
  real(long), pointer :: va_tmp(:,:,:), work(:,:,:)
  real(long), pointer :: pot_nb(:,:), pot_bc(:,:)
  integer :: ipg
  character(len=6) :: char_sym
! 
  call alloc_array3d(pot_vol,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot_surf,0,nrg,0,ntg,0,npg)
  call alloc_array3d(va_tmp,0,nrg,0,ntg,0,npg)
  call alloc_array3d(work,0,nrg,0,ntg,0,npg)
  call alloc_array2d(pot_nb,0,ntg,0,npg)
  call alloc_array2d(pot_bc,0,ntg,0,npg)
!
  call poisson_solver(sou,pot_vol)
  call interpo_gr2fl_surface(pot_vol,pot_nb)
  call calc_integrability_modify_At(va_tmp,'gr')
  call compute_fnc_multiple(va_tmp,alph,work)
  call interpo_gr2fl_surface(work,pot_bc)
  call poisson_solver_At_homosol_lesq(pot_bc,pot_nb,pot_surf,char_sym)
!
  pot(0:nrg,0:ntg,0:npg) = pot_vol(0:nrg,0:ntg,0:npg) &
                       & + pot_surf(0:nrg,0:ntg,0:npg)
!
  deallocate(pot_vol)
  deallocate(pot_surf)
  deallocate(work)
  deallocate(va_tmp)
  deallocate(pot_nb)
  deallocate(pot_bc)
! 
end subroutine poisson_solver_At
