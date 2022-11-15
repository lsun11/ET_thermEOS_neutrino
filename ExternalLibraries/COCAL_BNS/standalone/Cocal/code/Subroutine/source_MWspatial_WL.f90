subroutine source_MWspatial_WL(souvec)
  use grid_parameter, only : nrg, ntg, npg, nrf, ntf, npf, ntgeq
  use coordinate_grav_r, only : hrg
  use interface_sourceterm_MWspatial_current_CF
  use interface_sourceterm_MWspatial_current_WL
  use interface_sourceterm_MWspatial_CF
  use interface_sourceterm_MWspatial_WL
  use interface_interpo_fl2gr_midpoint
  use interface_correct_matter_source_midpoint
  use interface_correct_MW_source_C0At
  use make_array_3d
  use make_array_4d
  implicit none
  real(8), pointer :: souvec(:,:,:,:)
  real(8), pointer :: souvecf1(:,:,:,:), souvecf2(:,:,:,:)
  real(8), pointer :: sou(:,:,:), souf(:,:,:), souvecf(:,:,:,:)
  real(8), pointer :: souvec1(:,:,:,:), souvec2(:,:,:,:), &
  &                   souvec3(:,:,:,:)
  integer :: ia, irg, itg, ipg
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
  call sourceterm_MWspatial_current_CF(souvecf1)
  call sourceterm_MWspatial_current_WL(souvecf2)
  souvecf(0:nrf,0:ntf,0:npf,1:3) = souvecf1(0:nrf,0:ntf,0:npf,1:3) &
  &                              + souvecf2(0:nrf,0:ntf,0:npf,1:3)
  do ia = 1, 3
    souf(0:nrf,0:ntf,0:npf) = souvecf(0:nrf,0:ntf,0:npf,ia)
    call interpo_fl2gr_midpoint(souf,sou)
    call correct_matter_source_midpoint(sou)
    souvec1(0:nrg,0:ntg,0:npg,ia) = sou(0:nrg,0:ntg,0:npg)
  end do
!
  call sourceterm_MWspatial_CF(souvec2)
  do ia = 1, 3
    sou(0:nrg,0:ntg,0:npg) = souvec2(0:nrg,0:ntg,0:npg,ia)
    call correct_MW_source_C0At(sou,2)
    souvec2(0:nrg,0:ntg,0:npg,ia) = sou(0:nrg,0:ntg,0:npg)
  end do
!
  call sourceterm_MWspatial_WL(souvec3)
  do ia = 1, 3
    sou(0:nrg,0:ntg,0:npg) = souvec3(0:nrg,0:ntg,0:npg,ia)
    call correct_MW_source_C0At(sou,3)
    souvec3(0:nrg,0:ntg,0:npg,ia) = sou(0:nrg,0:ntg,0:npg)
  end do
!
!testtest
!  souvec1(0:nrg,0:ntg,0:npg,3) = 0.0d0
!  souvec2(0:nrg,0:ntg,0:npg,3) = 0.0d0
!  souvec3(0:nrg,0:ntg,0:npg,3) = 0.0d0
!
      itg = ntgeq-2; ipg = 2
!!       itg = ntgeq; ipg = 2
       open(15,file='test_vec_sou',status='unknown')
         do irg = 1, nrg
           write(15,'(1p,9e20.12)')  hrg(irg), souvec1(irg,itg,ipg,3) &
               &                             , souvec2(irg,itg,ipg,3) &
               &                             , souvec3(irg,itg,ipg,3) &
               &                             , souvec1(irg,itg+1,ipg,3) &
               &                             , souvec2(irg,itg+1,ipg,3) &
               &                             , souvec3(irg,itg+1,ipg,3)
         end do
       close(15)
!testtest
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
end subroutine source_MWspatial_WL
