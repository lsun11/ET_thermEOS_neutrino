include '../Include_file/include_modulefiles_AHfinder.f90'
include '../Include_file/include_interface_modulefiles_AHfinder.f90'
include '../Include_file/include_subroutines_AHfinder.f90'
include '../Include_file/include_functions.f90'
!
program Main_AHfinder
  use grid_parameter, only : indata_type, outdata_type, iter_max
  use grid_parameter_binary_excision
  use grid_points_binary_excision
  use weight_midpoint_binary_excision
  implicit none
  integer :: iseq, iter_count, total_iteration
!
  call coordinate_patch_kit_bhex
  call read_parameter_bh
  call read_parameter_binary_excision
  call calc_parameter_binary_excision
  call allocate_grid_points_binary_excision
  call calc_grid_points_binary_excision
  call allocate_weight_midpoint_binary_excision
  call calc_weight_midpoint_binary_excision
  call allocate_BBH_CF
  call allocate_horizon
  call initial_AHfinder
  if (indata_type.eq.'IN') call initial_metric_CF
  if (indata_type.eq.'3D') call IO_input_initial_3D
!
  call calc_vector_bh(2)
  call excurve
  call iteration_AHfinder(iter_count)
  if (total_iteration.ge.iter_max) then
    write(6,*)' ** Solution did not converge **'
  end if
!
  call calc_AHarea_AHfinder
  call IO_output_AHfinder
  call IO_output_AHfinder_gnuplot
!
end program Main_AHfinder
