subroutine source_MoC_WL(souvec)
  use grid_parameter, only : nrg, ntg, npg, nrf, ntf, npf
  use interface_sourceterm_MoC_CF_drot_SFC
  use interface_sourceterm_MoC_CF_with_divshift
  use interface_sourceterm_MoC_WL_drot_SFC
  use interface_sourceterm_MoC_WL
  use interface_interpo_fl2gr_midpoint
  use interface_correct_matter_source_midpoint
  use make_array_3d
  use make_array_4d
  implicit none
  real(8), pointer :: souvec(:,:,:,:)
  real(8), pointer :: sou(:,:,:), souf(:,:,:), souvecf(:,:,:,:)
  real(8), pointer :: souvecf1(:,:,:,:), souvecf2(:,:,:,:)
  real(8), pointer :: souvec1(:,:,:,:), souvec2(:,:,:,:), &
  &                   souvec3(:,:,:,:)
  integer :: ia
!
  call alloc_array3d(sou,0,nrg,0,ntg,0,npg)
  call alloc_array3d(souf,0,nrf,0,ntf,0,npf)
  call alloc_array4d(souvecf,0,nrf,0,ntf,0,npf,1,3)
  call alloc_array4d(souvecf1,0,nrf,0,ntf,0,npf,1,3)
  call alloc_array4d(souvecf2,0,nrf,0,ntf,0,npf,1,3)
  call alloc_array4d(souvec1,0,nrg,0,ntg,0,npg,1,3)
  call alloc_array4d(souvec2,0,nrg,0,ntg,0,npg,1,3)
  call alloc_array4d(souvec3,0,nrg,0,ntg,0,npg,1,3)
!
  call sourceterm_MoC_CF_drot_SFC(souvecf1)
!!  call sourceterm_MoC_WL_corot(souvec3)
  call sourceterm_MoC_WL_drot_SFC(souvecf2)
  souvecf(0:nrf,0:ntf,0:npf,1:3) = souvecf1(0:nrf,0:ntf,0:npf,1:3) &
  &                              + souvecf2(0:nrf,0:ntf,0:npf,1:3)
  do ia = 1, 3
    souf(0:nrf,0:ntf,0:npf) = souvecf(0:nrf,0:ntf,0:npf,ia)
    call interpo_fl2gr_midpoint(souf,sou)
    call correct_matter_source_midpoint(sou)
    souvec1(0:nrg,0:ntg,0:npg,ia) = sou(0:nrg,0:ntg,0:npg)
  end do
!
  call sourceterm_MoC_CF_with_divshift(souvec2)
  call sourceterm_MoC_WL(souvec3)
  souvec(0:nrg,0:ntg,0:npg,1:3) = souvec1(0:nrg,0:ntg,0:npg,1:3) &
  &                             + souvec2(0:nrg,0:ntg,0:npg,1:3) &
  &                             + souvec3(0:nrg,0:ntg,0:npg,1:3)
!
  deallocate(sou)
  deallocate(souf)
  deallocate(souvecf)
  deallocate(souvecf1)
  deallocate(souvecf2)
  deallocate(souvec1)
  deallocate(souvec2)
  deallocate(souvec3)
!
end subroutine source_MoC_WL
