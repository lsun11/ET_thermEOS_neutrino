subroutine sourceterm_MoC_WL_SEM(souvec)
  use phys_constant, only : long, pi
  use grid_parameter, only : nrg, ntg, npg
  use def_metric, only : alph
  use def_matter_parameter, only : radi
  use def_SEM_tensor, only : jmd
  use interface_interpo_linear_type0
  implicit none
  real(long), pointer :: souvec(:,:,:,:)
  real(long) :: rjj, alpgc
  integer :: ii, irg, itg, ipg
!
! --- Source terms of Momentum constraint for computing shift.  
!
  do ii = 1, 3
    do ipg = 1, npg
      do itg = 1, ntg
        do irg = 1, nrg
          call interpo_linear_type0(alpgc,alph,irg,itg,ipg)
          rjj = jmd(irg,itg,ipg,ii)
          souvec(irg,itg,ipg,ii) = radi**2*16.0d0*pi*alpgc*rjj
        end do
      end do
    end do
  end do     
!
end subroutine sourceterm_MoC_WL_SEM
