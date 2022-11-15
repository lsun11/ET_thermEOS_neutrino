subroutine source_MoC_CF(souvec)
  use grid_parameter, only : nrg, ntg, npg, nrf, ntf, npf
!  use interface_sourceterm_MoC_CF_drot
  use interface_sourceterm_MoC_CF_drot_SFC
  use interface_sourceterm_MoC_CF_with_divshift
  use interface_interpo_fl2gr_midpoint
  use interface_correct_matter_source_midpoint
  use interface_correct_MW_source_C0At
  use make_array_3d
  use make_array_4d
  implicit none
  real(8), pointer :: souvec(:,:,:,:), sou(:,:,:), souf(:,:,:)
  real(8), pointer :: souvec1(:,:,:,:), souvec2(:,:,:,:), souvecf(:,:,:,:)
  integer :: ipg, itg, irg, ia
!
  call alloc_array3d(sou,0,nrg,0,ntg,0,npg)
  call alloc_array3d(souf,0,nrf,0,ntf,0,npf)
  call alloc_array4d(souvec1,0,nrg,0,ntg,0,npg,1,3)
  call alloc_array4d(souvec2,0,nrg,0,ntg,0,npg,1,3)
  call alloc_array4d(souvecf,0,nrf,0,ntf,0,npf,1,3)
!
!  call sourceterm_MoC_CF_drot(souvec1)
  call sourceterm_MoC_CF_drot_SFC(souvecf)
  do ia = 1, 3
!    sou(0:nrg,0:ntg,0:npg) = souvec1(0:nrg,0:ntg,0:npg,ia)
    souf(0:nrf,0:ntf,0:npf) = souvecf(0:nrf,0:ntf,0:npf,ia)
    call interpo_fl2gr_midpoint(souf,sou)
    call correct_matter_source_midpoint(sou)
    souvec1(0:nrg,0:ntg,0:npg,ia) = sou(0:nrg,0:ntg,0:npg)
  end do
  call sourceterm_MoC_CF_with_divshift(souvec2)
!testtest
!  do ia = 1, 3
!    sou(0:nrg,0:ntg,0:npg) = souvec2(0:nrg,0:ntg,0:npg,ia)
!    call correct_MW_source_C0At(sou,2)
!    souvec2(0:nrg,0:ntg,0:npg,ia) = sou(0:nrg,0:ntg,0:npg)
!  end do
!testtest
!
  souvec(0:nrg,0:ntg,0:npg,1:3) = souvec1(0:nrg,0:ntg,0:npg,1:3) &
  &                             + souvec2(0:nrg,0:ntg,0:npg,1:3)
!
  deallocate(sou)
  deallocate(souf)
  deallocate(souvec1)
  deallocate(souvec2)
  deallocate(souvecf)
!
end subroutine source_MoC_CF
