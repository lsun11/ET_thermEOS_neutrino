module def_metric_excurve_grid
  use phys_constant, only : long
  implicit none
  real(long), pointer :: tfkij_grid(:,:,:,:,:), tfkijkij_grid(:,:,:)
  real(long), pointer :: trk_grid(:,:,:)
  real(long), pointer :: Lij_grid(:,:,:,:,:)
  real(long), pointer :: L1ij_grid(:,:,:,:,:)
end module def_metric_excurve_grid
