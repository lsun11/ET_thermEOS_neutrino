subroutine allocate_poisson_solver_test
  use phys_constant, only : long
  use grid_parameter
  use def_metric
  use def_matter
  use def_vector_x
  use def_vector_phi
  use make_array_2d
  use make_array_3d
  implicit none
!
  call alloc_array2d(rs, 0, ntf, 0, npf)
  call alloc_array3d(emdg, 0, nrg, 0, ntg, 0, npg)
  call alloc_array3d(emd, 0, nrf, 0, ntf, 0, npf)
  call alloc_array3d(psi, 0, nrg, 0, ntg, 0, npg)
  call alloc_array3d(alph, 0, nrg, 0, ntg, 0, npg)
  call allocate_vector_x
  call allocate_vector_phi
!
end subroutine allocate_poisson_solver_test
