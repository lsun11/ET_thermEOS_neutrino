subroutine sourceterm_MoC_WL_EMF(souvec)
  use phys_constant, only : long, pi
  use grid_parameter, only : nrg, ntg, npg
  use def_metric, only : alph
  use def_SEM_tensor_EMF, only : jmd_EMF
  use interface_interpo_linear_type0
  implicit none
  real(long), pointer :: souvec(:,:,:,:)
  real(long) :: alphgc, rjj
  integer :: ii, irg, itg, ipg
!
! --- Source terms of Momentum constraint 
! --- for computing shift.  
!
  do ii = 1, 3
    do ipg = 1, npg
      do itg = 1, ntg
        do irg = 1, nrg
          call interpo_linear_type0(alphgc,alph,irg,itg,ipg)
          rjj = jmd_EMF(irg,itg,ipg,ii)
          souvec(irg,itg,ipg,ii) = 16.0d0*pi*alphgc*rjj
        end do
      end do
    end do
  end do     
!
end subroutine sourceterm_MoC_WL_EMF
