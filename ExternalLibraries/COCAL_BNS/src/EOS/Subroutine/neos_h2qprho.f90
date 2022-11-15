subroutine neos_h2qprho(h,q,pre,rho,ened)
!
  use def_neos_parameter   !abc,abi,rhoi,qi,hi,nphase
  implicit none
!
  real(8), intent(in)  :: h
  real(8), intent(out) :: q, pre, rho, ened
!  real(8)              :: qq, hin, qin, abin, abct
!  real(8)              :: fac1, fac2, fack, small = 1.0d-16
  integer              :: iphase
!
  if (h < hi(0)) then
    q   = 0.0d0
    pre = 0.0d0
    rho = 0.0d0
    ened= 0.0d0
  end if

  do i = 1, nphase
    if( (h.ge.hi(i-1)) .and. (h.lt.hi(i)))   iphase = i
  end do
!
  i0 = min0(max0(iphase-2,0),nphase-3) - 1
  x4(1:4) = hi(i0+1:i0+4)
  f4(1:4) = qi(i0+1:i0+4)
  q       = fn_lagint(x4,f4,h)

  f4(1:4) = prei(i0+1:i0+4)
  pre     = fn_lagint(x4,f4,h)

  f4(1:4) = rhoi(i0+1:i0+4)
  rho     = fn_lagint(x4,f4,h)

  f4(1:4) = enei(i0+1:i0+4)
  ened    = fn_lagint(x4,f4,h)

!
end subroutine neos_h2qprho
