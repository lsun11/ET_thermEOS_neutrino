subroutine test_analytic_solution
  use phys_constant, only  :   long, pi
  use grid_parameter, only  :   nrg, ntg, npg, nrf
  use def_metric, only  :   alph
  use coordinate_grav_r, only : rg
  use grid_points_binary_excision, only : rb
  implicit none
  integer     ::   irg,itg,ipg
  real(long)  ::   zfac, small = 1.0d-15
!
  do ipg = 0, npg
    do itg = 0, ntg
      do irg = 0, nrg
      if(irg.lt.nrf) &
      & alph(irg,itg,ipg) = - 2.0d0*pi/3.0d0*(3.0d0-rg(irg)**2) &
      &                     -(4.0d0*pi/3.0d0)*1.0d0/rb(irg,itg,ipg)
      if(irg.ge.nrf) &
      & alph(irg,itg,ipg) = -(4.0d0*pi/3.0d0)*1.0d0/rg(irg)  &
      &                     -(4.0d0*pi/3.0d0)*1.0d0/rb(irg,itg,ipg)
!!      if(irg.eq.0) &
!!      & alph(irg,itg,ipg) = - 4.0d0/pi &
!!      &                     - 4.0d0/pi - 4.0d0/(pi*rb(irg,itg,ipg))
!!      if(irg.lt.nrf.and.irg.ne.0) &
!!      & alph(irg,itg,ipg) = - 4.0d0*sin(pi*rg(irg)) &
!!      &                      /(pi**2*rg(irg)) &
!!      &                     - 4.0d0/pi - 4.0d0/(pi*rb(irg,itg,ipg))
!!      if(irg.ge.nrf) &
!!      & alph(irg,itg,ipg) = - 4.0d0/(pi*rg(irg))  &
!!      &                     - 4.0d0/(pi*rb(irg,itg,ipg))
      end do
    end do
  end do
!
end subroutine test_analytic_solution
