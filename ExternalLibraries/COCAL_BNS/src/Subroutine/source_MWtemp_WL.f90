subroutine source_MWtemp_WL(sou)
  use grid_parameter, only : nrg, ntg, npg, nrf, ntf, npf, ntgeq
  use coordinate_grav_r, only : hrg
  use interface_sourceterm_MWtemp_CF
  use interface_sourceterm_MWtemp_WL
  use interface_sourceterm_MWtemp_current
  use interface_interpo_fl2gr_midpoint
  use interface_correct_matter_source_midpoint
  use interface_correct_MW_source_C0At
  use make_array_3d
  implicit none
  real(8), pointer :: sou(:,:,:)
  real(8), pointer :: souf(:,:,:), sou1(:,:,:), sou2(:,:,:), sou3(:,:,:)
  integer :: irg, itg, ipg
!
  call alloc_array3d(sou1,0,nrg,0,ntg,0,npg)
  call alloc_array3d(sou2,0,nrg,0,ntg,0,npg)
  call alloc_array3d(sou3,0,nrg,0,ntg,0,npg)
  call alloc_array3d(souf,0,nrf,0,ntf,0,npf)
  call sourceterm_MWtemp_CF(sou1)
  call correct_MW_source_C0At(sou1,2)
  call sourceterm_MWtemp_WL(sou2)
  call correct_MW_source_C0At(sou2,3)
  call sourceterm_MWtemp_current(souf)
  call interpo_fl2gr_midpoint(souf,sou3)
  call correct_matter_source_midpoint(sou3)
  sou(0:nrg,0:ntg,0:npg) = sou1(0:nrg,0:ntg,0:npg) &
  &                      + sou2(0:nrg,0:ntg,0:npg) &
  &                      + sou3(0:nrg,0:ntg,0:npg)
!
!!      itg = ntgeq; ipg = 2
!!      open(15,file='test_vec_sou',status='unknown')
!!        do irg = 1, nrg
!!          write(15,'(1p,9e20.12)')  hrg(irg), sou1(irg,itg,ipg) &
!!              &                             , sou2(irg,itg,ipg) &
!!              &                             , sou3(irg,itg,ipg)
!!        end do
!!      close(15)
!
  deallocate(sou1)
  deallocate(sou2)
  deallocate(sou3)
  deallocate(souf)
!
end subroutine source_MWtemp_WL
