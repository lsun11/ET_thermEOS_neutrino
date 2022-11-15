subroutine source_virial_WL_MHD(sou_Tkin,sou_Pint,sou_Memf,sou_Wgra)
  use phys_constant,  only : long
  use grid_parameter, only : nrg, ntg, npg
  use def_SEM_tensor_EMF, only : trsm_EMF
  use interface_source_virial_WL
  implicit none
  real(long), pointer :: sou_Tkin(:,:,:), sou_Pint(:,:,:), &
  &                      sou_Memf(:,:,:), sou_Wgra(:,:,:)
!
! --- Compute source terms for virial relations.
! --- sources for kinetic and internal energies are defined on SCF grid points.
! --- sources for EM, and gravitational energies are defined on mid points.
!
  call source_virial_WL(sou_Tkin,sou_Pint,sou_Wgra)
  sou_Memf(0:nrg,0:ntg,0:npg)= trsm_EMF(0:nrg,0:ntg,0:npg)
!
end subroutine source_virial_WL_MHD
