subroutine sourceterm_poisson_solver_test(soug)
  use phys_constant, only  :   long, pi
  use grid_parameter, only  :   nrg, ntg, npg
  use coordinate_grav_r, only  : rg
  use def_matter, only  :   emdg, rs
  use def_matter_parameter, only  :  radi, pinx, ber
  use interface_interpo_linear_type0
  implicit none
  real(long), pointer :: soug(:,:,:)
  integer     ::   irg,itg,ipg
  real(long)  ::   emdw
  real(long)  ::   zfac, small = 1.0d-15
!
!
  do ipg = 1, npg
    do itg = 1, ntg
      do irg = 1, nrg
        call interpo_linear_type0(emdw,emdg,irg,itg,ipg)
        zfac = 1.0d0
        if (rg(irg).gt.rs(itg,ipg)+small) zfac = 0.0d0
        soug(irg,itg,ipg) = emdw*zfac
      end do
    end do
  end do
!
!
end subroutine sourceterm_poisson_solver_test
