module phys_constant
  implicit none
  Integer, parameter :: long = SELECTED_REAL_KIND(15,307)
  real(long), parameter :: pi = 3.141592653589793d+0
  real(long), parameter :: g = 6.67428d-08
  real(long), parameter :: c = 2.99792458d+10
  real(long), parameter :: msol   = 1.98892d+33
  real(long), parameter :: solmas = 1.98892d+33
  real(long), parameter :: mag_mu0= 4.0d0*pi*1.0d-02
  real(long), parameter :: fpieps0= 4.0d0*pi/(mag_mu0*c**2)
! Gauss: a conversion factor from G=c=M=4piepsilon=1 unit to cgs Gauss.
! statV: a conversion factor from G=c=M=4piepsilon=1 unit to cgs Gauss.
!  real(long), parameter ::
!  Gauss=(c**6/(fpieps0*G**3*msol**2))**0.5d0*10.0
!  real(long), parameter ::
!  statV=(c**8/(fpieps0*G**3*msol**2))**0.5d0*10.0/c
  real(long), parameter :: Gauss = 2.355368504154456d+19
  real(long), parameter :: statV = 2.355368504154456d+19
  integer, parameter :: nnrg = 520, nntg = 256, nnpg = 256, nnlg = 20
  integer, parameter :: nnrf = 500, nntf = 256, nnpf = 256, nnlf = 20
  integer, parameter :: nnpeos = 10
  integer, parameter :: nnmpt = 5
  integer, parameter :: nmpt = 3
!  integer, parameter :: nmpt = 3
end module phys_constant

