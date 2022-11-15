subroutine neos_q2hprho(q,h,pre,rho,ened)
!
  use def_neos_parameter     !abc,abi,rhoi,qi,hi,nphase
  implicit none
!
  real(8), intent(inout) :: q
  real(8), intent(out)   :: h, pre, rho
  real(8)                :: hin, qin, abin, abct, fac1, fac2, fack, small, ened
  integer                :: iphase, i0, i
  real(8), external      :: fn_lagint
  real(8)                :: x4(4), f4(4)
!
  if (q < qi(0)) then
    h   = 1.0d0
    pre = 0.0d0
    rho = 0.0d0
    ened= 0.0d0
  end if

  do i = 1, nphase
    if( (q.ge.qi(i-1)) .and. (q.lt.qi(i)))   iphase = i
  end do
!
  i0 = min0(max0(iphase-2,0),nphase-3) - 1
  x4(1:4) = qi(i0+1:i0+4)
  f4(1:4) = hi(i0+1:i0+4)
  h       = fn_lagint(x4,f4,q)

  f4(1:4) = prei(i0+1:i0+4)
  pre     = fn_lagint(x4,f4,q)

  f4(1:4) = rhoi(i0+1:i0+4)
  rho     = fn_lagint(x4,f4,q)

  f4(1:4) = enei(i0+1:i0+4)
  ened    = fn_lagint(x4,f4,q)
!
end subroutine neos_q2hprho
