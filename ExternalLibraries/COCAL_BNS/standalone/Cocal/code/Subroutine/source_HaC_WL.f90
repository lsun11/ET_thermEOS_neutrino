subroutine source_HaC_WL(sou)
  use grid_parameter, only : nrg, ntg, npg, nrf, ntf, npf
  use interface_sourceterm_HaC_CF
!  use interface_sourceterm_HaC_CF_corot
  use interface_sourceterm_HaC_drot_SFC
  use interface_sourceterm_HaC_WL
!  use interface_sourceterm_HaC_WL_test
  use interface_interpo_fl2gr_midpoint
  use interface_correct_matter_source_midpoint
  use make_array_3d
  implicit none
  real(8), pointer :: sou(:,:,:), sou1(:,:,:), sou2(:,:,:), sou3(:,:,:)
  real(8), pointer :: souf(:,:,:)
!t   real(8) :: t1, t2, t3
  call alloc_array3d(sou1,0,nrg,0,ntg,0,npg)
  call alloc_array3d(sou2,0,nrg,0,ntg,0,npg)
  call alloc_array3d(sou3,0,nrg,0,ntg,0,npg)
  call alloc_array3d(souf,0,nrf,0,ntf,0,npf)
  call sourceterm_HaC_CF(sou1)
!  call sourceterm_HaC_CF_corot(sou2)
  call sourceterm_HaC_drot_SFC(souf)
  call interpo_fl2gr_midpoint(souf,sou2)
  call correct_matter_source_midpoint(sou2)
!t call cpu_time(t1)
  call sourceterm_HaC_WL(sou3)
!t call cpu_time(t2)
!t write(6,*)'time sou1', t2-t1
!t   call sourceterm_HaC_WL_test(sou3)
!t call cpu_time(t3)
!t write(6,*)'time sou2', t3-t2
  sou(0:nrg,0:ntg,0:npg) = sou1(0:nrg,0:ntg,0:npg) &
  &                      + sou2(0:nrg,0:ntg,0:npg) &
  &                      + sou3(0:nrg,0:ntg,0:npg)
  deallocate(sou1)
  deallocate(sou2)
  deallocate(sou3)
  deallocate(souf)
!
!  use def_velocity_potential, only : ramg
!  use def_metric, only : alph
!  use flusw, only : swflu
!        call interpo_linear_type0(ramgc,ramg,irg,itg,ipg)
!        call interpo_linear_type0(alpgc,alph,irg,itg,ipg)
!        utgc  = swflu *ramgc/(alpgc**2*hhgc) &
!           &      +(1.0d0-swflu)*hhgc/ber
!
end subroutine source_HaC_WL
