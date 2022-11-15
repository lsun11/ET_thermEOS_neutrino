subroutine source_trG_CF(sou)
  use grid_parameter, only : nrg, ntg, npg, nrf, ntf, npf
  use interface_sourceterm_trG_CF
!  use interface_sourceterm_trG_drot
  use interface_sourceterm_trG_drot_SFC
  use interface_interpo_fl2gr_midpoint
  use interface_correct_matter_source_midpoint
  use make_array_3d
  implicit none
  real(8), pointer :: sou(:,:,:), sou1(:,:,:), sou2(:,:,:), souf(:,:,:)
!
  call alloc_array3d(sou1,0,nrg,0,ntg,0,npg)
  call alloc_array3d(sou2,0,nrg,0,ntg,0,npg)
  call alloc_array3d(souf,0,nrf,0,ntf,0,npf)
  call sourceterm_trG_CF(sou1)
!  call sourceterm_trG_drot(sou2)
  call sourceterm_trG_drot_SFC(souf)
  call interpo_fl2gr_midpoint(souf,sou2)
  call correct_matter_source_midpoint(sou2)
  sou(0:nrg,0:ntg,0:npg) = sou1(0:nrg,0:ntg,0:npg) &
  &                      + sou2(0:nrg,0:ntg,0:npg)
  deallocate(sou1)
  deallocate(sou2)
  deallocate(souf)
!
end subroutine source_trG_CF
