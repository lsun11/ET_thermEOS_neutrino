subroutine search_emdmax_xaxis_grid(iremax)
  use phys_constant,  only  : long
  use grid_parameter, only  : nrf, ntfxy
  use def_matter, only  :   emd
  implicit none
  real(long) :: emdmax
  integer    :: ir, iremax
!
! search maximum emd on positive x-axis
  emdmax = emd(0,ntfxy,0)
  iremax = 0
  do ir = 0, nrf
    if (emd(ir,ntfxy,0).gt.emdmax) then
      emdmax = emd(ir,ntfxy,0)
      iremax = ir
    end if
  end do
!
end subroutine search_emdmax_xaxis_grid
