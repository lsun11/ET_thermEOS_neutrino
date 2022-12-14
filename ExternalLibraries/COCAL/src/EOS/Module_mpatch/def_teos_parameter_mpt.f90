module def_peos_parameter_mpt
  use phys_constant         !nnpeos, nmpt
  implicit none
  real(8) :: enei_(0:nnteos,nmpt), prei_(0:nnteos,nmpt), rhoi_(0:nnteos,nmpt), &
      &      qi_(0:nnteos,nmpt), hi_(0:nnteos,nmpt)
  real(8) :: rhocgs_(0:nnteos,nmpt), precgs_(0:nnteos,nmpt), enecgs_(0:nnteos,nmpt)
  
  real(8) :: def_peos_param_real_(0:20,nmpt)
  integer :: def_peos_param_int_(0:10,nmpt)
  
!  real(8) :: rhoini_cgs_(nnmpt), rhoini_gcm1_(nnmpt), emdini_gcm1_(nnmpt)  !used in TOV solver
!  integer :: nphase_(nnmpt)
end module def_peos_parameter_mpt
