subroutine update_grfield(pot,grfield,convf)
  use phys_constant,  only : long, nnrg, nntg, nnpg
  use grid_parameter, only : nrg, ntg, npg, rgin
  use coordinate_grav_r, only : rg
  use make_array_3d
  implicit none
  real(long), pointer    :: pot(:,:,:)
  real(long), pointer    :: grfield(:,:,:)
  real(long), intent(in) :: convf
  real(long) :: work(0:nnrg,0:nntg,0:nnpg) = 0.0d0
  real(long) :: cf
  integer    :: irg,itg,ipg
!
  work(0:nrg,0:ntg,0:npg) = convf *    pot(0:nrg,0:ntg,0:npg) &
  &                + (1.0d0-convf)*grfield(0:nrg,0:ntg,0:npg)
  grfield(0:nrg,0:ntg,0:npg) = work(0:nrg,0:ntg,0:npg)
!

!  do irg=0,nrg
!    do itg=0,ntg
!      do ipg=0,npg
!        if (rg(irg)>1.7*rgin)  then
!          cf = convf
!        else
!          cf = 0.05
!        end if
!        work(irg,itg,ipg) = cf*pot(irg,itg,ipg) + (1.0d0-cf)*grfield(irg,itg,ipg)   
!      end do
!    end do
!  end do
!  grfield(0:nrg,0:ntg,0:npg) = work(0:nrg,0:ntg,0:npg)

end subroutine update_grfield
