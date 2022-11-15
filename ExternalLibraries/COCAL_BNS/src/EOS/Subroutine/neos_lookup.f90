subroutine neos_lookup(qp,qpar,iphase)
!
  use phys_constant             !nnneos
  use def_neos_parameter        !abc,abi,rhoi,qi,hi,nphase
  implicit none
!
  real(8), intent(in)  :: qp, qpar(0:nnpeos)
  real(8)              :: det
  integer, intent(out) :: iphase
  integer              :: ii
!
! --  Monotonically increasing qpar is assumed.
!
  iphase = 1
!  do ii = 1, nphase
!    det = (qp-qpar(ii))*(qp-qpar(ii-1))
!    if (det <= 0.0d0) iphase = ii
!  end do
!
end subroutine neos_lookup
