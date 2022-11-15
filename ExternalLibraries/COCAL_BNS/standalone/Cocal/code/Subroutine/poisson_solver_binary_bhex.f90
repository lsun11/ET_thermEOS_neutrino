subroutine poisson_solver_binary_bhex(sou,sou_exsurf,dsou_exsurf, &
                                    &     sou_insurf,dsou_insurf, &
                                    &    sou_outsurf,dsou_outsurf,pot)
  use phys_constant,  only : long
  use grid_parameter, only : nrg, npg, ntg
  use make_array_3d
  use interface_poisson_solver_binary_vol_int
  use interface_poisson_solver_binary_surf_int
  use interface_poisson_solver_bhex_surf_int_all
  implicit none
  real(long), pointer :: pot(:,:,:), sou(:,:,:)
  real(long), pointer :: sou_exsurf(:,:), dsou_exsurf(:,:)
  real(long), pointer :: sou_insurf(:,:), dsou_insurf(:,:)
  real(long), pointer :: sou_outsurf(:,:), dsou_outsurf(:,:)
  real(long), pointer :: sou_iosurf(:,:,:)
  real(long), pointer :: pot_vol(:,:,:), pot_exsurf(:,:,:), pot_iosurf(:,:,:)
! 
  call alloc_array3d(pot_vol,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot_exsurf,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot_iosurf,0,nrg,0,ntg,0,npg)
  call alloc_array3d(sou_iosurf,0,ntg,0,npg,1,4)
!
  call poisson_solver_binary_vol_int(sou,pot_vol)
  call poisson_solver_binary_surf_int(sou_exsurf,dsou_exsurf,pot_exsurf)
  sou_iosurf(1:ntg,1:npg,1) = dsou_insurf(1:ntg,1:npg)
  sou_iosurf(1:ntg,1:npg,2) = sou_insurf(1:ntg,1:npg)
  sou_iosurf(1:ntg,1:npg,3) = dsou_outsurf(1:ntg,1:npg)
  sou_iosurf(1:ntg,1:npg,4) = sou_outsurf(1:ntg,1:npg)
  call poisson_solver_bhex_surf_int_all(sou_iosurf,pot_iosurf)
  pot(0:nrg,0:ntg,0:npg) = pot_vol(0:nrg,0:ntg,0:npg) &
                       & + pot_exsurf(0:nrg,0:ntg,0:npg) &
                       & + pot_iosurf(0:nrg,0:ntg,0:npg)
!
  deallocate(pot_vol)
  deallocate(pot_exsurf)
  deallocate(pot_iosurf)
  deallocate(sou_iosurf)
! 
end subroutine poisson_solver_binary_bhex
