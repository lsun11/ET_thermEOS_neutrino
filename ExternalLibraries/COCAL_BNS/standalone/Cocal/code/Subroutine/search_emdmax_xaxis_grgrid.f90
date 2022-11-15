subroutine search_emdmax_xaxis_grgrid(iremax)
  use phys_constant,  only  : long
  use grid_parameter, only  : nrg, ntgxy, nrgin, nrf
  use def_matter, only  :   emdg
  use def_quantities, only : rho_max, pre_max, epsi_max, q_max
  use coordinate_grav_r, only : rg  
  implicit none
  integer, intent(out) :: iremax
  real(long) :: emdmax, hmax
  integer    :: irg
!
! search maximum emd on positive x-axis

!    do irg=0,nrf
!    write(6,*)  irg, rg(irg), emdg(irg,ntgxy,0)
!    end do

  emdmax = -1.0d0
  iremax = 0
  do irg = 0, nrg
    if (emdg(irg,ntgxy,0).gt.emdmax) then
      emdmax = emdg(irg,ntgxy,0)
      iremax = irg
    end if
  end do

  q_max = emdmax
  call peos_q2hprho(q_max, hmax, pre_max, rho_max, epsi_max)
!
end subroutine search_emdmax_xaxis_grgrid
