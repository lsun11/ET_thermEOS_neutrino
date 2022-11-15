subroutine source_trG_WL_EMF(sou)
  use grid_parameter, only : nrg, ntg, npg, nrf, ntf, npf, ntgeq, npgxzp
  use coordinate_grav_r, only : hrg
  use interface_sourceterm_trG_CF
  use interface_sourceterm_trG_WL
  use interface_sourceterm_trG_WL_EMF
  use interface_sourceterm_trG_WL_SEM
  use interface_interpo_fl2gr_midpoint
  use interface_correct_matter_source_midpoint
  use make_array_3d
  implicit none
  real(8), pointer :: sou(:,:,:)
  real(8), pointer :: sou1(:,:,:), sou2(:,:,:), sou3(:,:,:), sou4(:,:,:)
  real(8), pointer :: souf(:,:,:)
  integer :: irg
  call alloc_array3d(sou1,0,nrg,0,ntg,0,npg)
  call alloc_array3d(sou2,0,nrg,0,ntg,0,npg)
  call alloc_array3d(sou3,0,nrg,0,ntg,0,npg)
  call alloc_array3d(sou4,0,nrg,0,ntg,0,npg)
  call alloc_array3d(souf,0,nrf,0,ntf,0,npf)
  call sourceterm_trG_CF(sou1)
  call sourceterm_trG_WL(sou2)
  call sourceterm_trG_WL_EMF(sou3)
  call sourceterm_trG_WL_SEM(souf)
  call interpo_fl2gr_midpoint(souf,sou4)
  call correct_matter_source_midpoint(sou4)
  sou(0:nrg,0:ntg,0:npg) = sou1(0:nrg,0:ntg,0:npg) &
  &                      + sou2(0:nrg,0:ntg,0:npg) &
  &                      + sou3(0:nrg,0:ntg,0:npg) &
  &                      + sou4(0:nrg,0:ntg,0:npg)
!
  deallocate(sou1)
  deallocate(sou2)
  deallocate(sou3)
  deallocate(sou4)
  deallocate(souf)
!
end subroutine source_trG_WL_EMF
