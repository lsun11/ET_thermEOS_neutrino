!______________________________________________
include '../Include_file/include_modulefiles_RNS_WL_peos.f90'
include '../Include_file/include_interface_modulefiles_RNS_WL_peos.f90'
include '../Include_file/include_subroutines_RNS_WL_peos.f90'
include '../Include_file/include_PEOS_modulefile.f90'
include '../Include_file/include_PEOS_subroutines.f90'
include '../Include_file/include_functions.f90'
!______________________________________________
!
!              Main Program
!______________________________________________
! ==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+=
!
!     General relativistic binary in equilibrium. 
!     Einstein field equation and equations for irrotational 
!     fluid flow are solved assuming the helical symmetry.  
!     Using self-consistent field method.
!
!     Parameters
!     chrot == i : Irrotational flow  |  chope == L : invert Laplacian
!           == c : Corotational flow  |        == H : invert Helmholtz
!
!     chgra == h : Helically symmetric source
!           == w : SUF Waveless source
!           == i : IWM formalism
!           == c : Waveless Helical cut off source for Laplacian
!           == C : Waveless Helical cut off source for Helmholtz
!           == H : Helical cut off source (Simple cutoff)
!           == W : Helical -> Waveless source for Helmholtz op.
!
! ==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+=
!
PROGRAM Main_RNS_WL_peos
!
  use grid_parameter, only : indata_type, outdata_type, & 
  &                          iter_max, num_sol_seq,  &
  &                          sw_mass_iter, sw_art_deform, ntfxy
  use def_matter, only : emd
  use def_matter_parameter, only : emdc
  use def_formulation
  implicit none
  integer :: flag_restmass, count_adj
  integer :: iseq, iter_count, total_iteration, nmx
!
  call coordinate_patch_kit_grav
  call read_parameter_drot
  call allocate_metric_and_matter_WL
  call allocate_SEM_tensor
  if (indata_type.eq.'1D') call IO_input_initial_1D
  if (indata_type.eq.'3D') call IO_input_initial_3D
  if (indata_type.eq.'3D') call IO_input_initial_3D_WL
  if (sw_mass_iter.eq.'y') then 
    call search_emdmax_xaxis_grid(nmx)
    emdc = emd(nmx,ntfxy,0)
  end if
!
  if (sw_art_deform.eq.'y') call artificial_deformation
!
  call choose_formulation
!
  call peos_initialize
  call initialize_field
!
  do iseq = 1, num_sol_seq
    total_iteration = 0
    flag_restmass   = 0 ! 0, 1 = iterate for a constant rest mass
!                       !    2 = rest mass converged
!                       !  999 = no rest mass iteration and converged
    count_adj       = 0 ! count number of adjustment of the rest mass
    do                  ! -- iteration for a constant rest mass
      call iteration_WL(iter_count)
      total_iteration = total_iteration + iter_count
      write(6,*)'-- Total # of iteration --', total_iteration
      call calc_physical_quantities_WL
      call printout_physq_console
      if (total_iteration.ge.iter_max) exit
      if (sw_mass_iter.ne.'y') exit
      call adjust_rest_mass(flag_restmass,count_adj)
      if (flag_restmass.eq.2) exit
    end do
    write(6,*)'== Solution sequence # == ', iseq
    if (total_iteration.ge.iter_max) then
      write(6,*)' ** Solution did not converge **'
    else 
      if (sw_mass_iter.ne.'y') flag_restmass = 999
    end if
    call calc_physical_quantities_WL
    call calc_quad_pole_peos
!
    call printout_physq_WL_MHD(iseq,flag_restmass)
    call printout_quad_pole(iseq)
    call printout_physq_plot(iseq,flag_restmass)
!testtest    if (sw_mass_iter.ne.'y') exit
    call printout_NS_shape_seq(iseq)
    call next_solution
  end do
  if (outdata_type.eq.'1D') call IO_output_solution_1D
  if (outdata_type.eq.'3D') call IO_output_solution_3D
  if (outdata_type.eq.'3D') call IO_output_solution_3D_WL
!!  call printout_debug
  call printout_NS_shape
!
END PROGRAM Main_RNS_WL_peos
