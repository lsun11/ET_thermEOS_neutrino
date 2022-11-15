subroutine iteration_peos_gp4th(iter_count)
  use phys_constant, only :  long, nnrg, nntg, nnpg
  use grid_parameter
  use coordinate_grav_r
  use coordinate_grav_phi
  use coordinate_grav_theta
  use weight_midpoint_grav
  use make_array_2d
  use make_array_3d
  use make_array_4d
  use def_metric
  use def_matter
  use def_matter_parameter
  use interface_interpo_fl2gr
  use interface_poisson_solver
!  use interface_sourceterm_HaC_peos
!  use interface_sourceterm_trG_peos
  use interface_source_HaC_CF
  use interface_source_trG_CF
  use interface_source_MoC_CF_gp4th
!*  use interface_sourceterm_MoC_peos
  use interface_compute_shift
  use interface_compute_alps2alph
  use interface_hydrostatic_eq_peos
  use interface_calc_surface
  use interface_update_grfield
  use interface_update_matter
  use interface_update_parameter_peos
  use interface_update_surface
  use interface_error_matter
  use interface_error_matter_type2
  use interface_error_metric
  use interface_error_metric_type0
  use interface_error_metric_type2
  implicit none
  real(long), pointer :: sou(:,:,:), pot(:,:,:), sou2(:,:,:)
  real(long), pointer :: potf(:,:,:), emd_bak(:,:,:)
  real(long), pointer :: potrs(:,:)
  real(long), pointer :: potx(:,:,:), poty(:,:,:), potz(:,:,:)
  real(long), pointer :: potx_bak(:,:,:), poty_bak(:,:,:), potz_bak(:,:,:)
  real(long), pointer :: souvec(:,:,:,:)
  real(long) :: work(0:nnrg,0:nntg,0:nnpg)
  real(long) :: error_emd, count
  real(long) :: error_psi  = 0.0d0, error_alph = 0.0d0, error_tmp = 0.0d0, &
  &             error_bvxd = 0.0d0, error_bvyd = 0.0d0, error_bvzd = 0.0d0
  real(long) :: error_emd_tmp = 1.0d0, error_metric_tmp = 1.0d0
  integer    :: iter_count, flag = 0, hydro_iter = 4
  integer    :: flag_tmp = 0, flag_param = 99, &
  &             flag_psi = 0, flag_alph = 0, &
  &            flag_bvxd = 0, flag_bvyd = 0, flag_bvzd = 0
  integer    :: irf, itf, ipf, irg, itg, ipg, ihy
!
  call alloc_array3d(sou,0,nrg,0,ntg,0,npg)
  call alloc_array3d(sou2,0,nrg,0,ntg,0,npg)
  call alloc_array3d(potx,0,nrg,0,ntg,0,npg)
  call alloc_array3d(poty,0,nrg,0,ntg,0,npg)
  call alloc_array3d(potz,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot,0,nrg,0,ntg,0,npg)
  call alloc_array3d(potf,0,nrf,0,ntf,0,npf)
  call alloc_array3d(emd_bak,0,nrf,0,ntf,0,npf)
  call alloc_array3d(potx_bak,0,nrg,0,ntg,0,npg)
  call alloc_array3d(poty_bak,0,nrg,0,ntg,0,npg)
  call alloc_array3d(potz_bak,0,nrg,0,ntg,0,npg)
  call alloc_array2d(potrs,0,ntf,0,npf)
  call alloc_array4d(souvec,0,nrg,0,ntg,0,npg,1,3)
!
  iter_count = 0
  do
    iter_count = iter_count + 1      
    count = dble(iter_count) 
    conv_gra = dmin1(conv0_gra,conv_ini*count)
    conv_den = dmin1(conv0_den,conv_ini*count)
!
    emdg = 0.0d0
    call calc_vector_x_grav(1)
    call calc_vector_x_matter(1)
    call calc_vector_phi_grav(1)
    call calc_vector_phi_matter(1)
    call interpo_fl2gr(emd, emdg)
    call interpo_gr2fl_metric_CF
    call rotation_law  ! calculate omef and omeg
!*    call excurve
    call excurve_CF('ns')             !   3rd order midpoint from ir0=-2,...
! --
!!    call sourceterm_HaC_peos(sou)
    call source_HaC_CF(sou)
    call poisson_solver(sou,pot)
    pot = pot + 1.0d0
    call update_grfield(pot,psi,conv_gra)
    call update_parameter_peos(conv_den)
! --
!
!!    call sourceterm_trG_peos(sou)
    call source_trG_CF(sou)
    call poisson_solver(sou,pot)
    pot = pot + 1.0d0
    call compute_alps2alph(pot,psi)
    call update_grfield(pot,alph,conv_gra)
    call update_parameter_peos(conv_den)
!    write(6,*) 'psi', psi(0,0,0)
! --
!!    call sourceterm_MoC_peos(souvec,sou)
    call source_MoC_CF_gp4th(souvec)
    work(1:nrg, 1:ntg, 1:npg) = souvec(1:nrg, 1:ntg, 1:npg, 1)
    sou2(1:nrg, 1:ntg, 1:npg) = work(1:nrg, 1:ntg, 1:npg)
    call poisson_solver(sou2,potx)
    work(1:nrg, 1:ntg, 1:npg) = souvec(1:nrg, 1:ntg, 1:npg, 2)
    sou2(1:nrg, 1:ntg, 1:npg) = work(1:nrg, 1:ntg, 1:npg)
    call poisson_solver(sou2,poty)
    work(1:nrg, 1:ntg, 1:npg) = souvec(1:nrg, 1:ntg, 1:npg, 3)
    sou2(1:nrg, 1:ntg, 1:npg) = work(1:nrg, 1:ntg, 1:npg)
    call poisson_solver(sou2,potz)
!!    call poisson_solver(sou,pot)
    work(  0:nrg, 0:ntg, 0:npg)    = potx(0:nrg, 0:ntg, 0:npg)
    souvec(0:nrg, 0:ntg, 0:npg, 1) = work(0:nrg, 0:ntg, 0:npg)
    work(  0:nrg, 0:ntg, 0:npg)    = poty(0:nrg, 0:ntg, 0:npg)
    souvec(0:nrg, 0:ntg, 0:npg, 2) = work(0:nrg, 0:ntg, 0:npg)
    work(  0:nrg, 0:ntg, 0:npg)    = potz(0:nrg, 0:ntg, 0:npg)
    souvec(0:nrg, 0:ntg, 0:npg, 3) = work(0:nrg, 0:ntg, 0:npg)
!!    call compute_shift(potx, poty, potz, souvec, pot)
      potx_bak(0:nrg,0:ntg,0:npg) = bvxd(0:nrg,0:ntg,0:npg)
      poty_bak(0:nrg,0:ntg,0:npg) = bvyd(0:nrg,0:ntg,0:npg)
      potz_bak(0:nrg,0:ntg,0:npg) = bvzd(0:nrg,0:ntg,0:npg)
    call update_grfield(potx,bvxd,conv_gra)
    call update_grfield(poty,bvyd,conv_gra)
    call update_grfield(potz,bvzd,conv_gra)
    call update_parameter_peos(conv_den)
!
    call error_metric_type2(bvxd,potx_bak,error_tmp,flag_tmp,'ns')
     flag_bvxd =  max ( flag_bvxd, flag_tmp)
    error_bvxd = dmax1(error_bvxd,error_tmp)
    call error_metric_type2(bvyd,poty_bak,error_tmp,flag_tmp,'ns')
     flag_bvyd =  max ( flag_bvyd, flag_tmp)
    error_bvyd = dmax1(error_bvyd,error_tmp)
    call error_metric_type2(bvzd,potz_bak,error_tmp,flag_tmp,'ns')
     flag_bvzd =  max ( flag_bvzd, flag_tmp)
    error_bvzd = dmax1(error_bvzd,error_tmp)
    call printout_error_metric(iter_count,error_bvxd)
    call printout_error_metric(iter_count,error_bvyd)
    call printout_error_metric(iter_count,error_bvzd)
!
! -- Hydro equations.
if (error_emd_tmp.le.eps*0.1d0.and.error_metric_tmp.gt.eps*2.0d0) then 
  write(6,*)' ## SKIP HYDRO ##' 
else
  do ihy = 1, hydro_iter
    call interpo_gr2fl_metric_CF
    call rotation_law
    call hydrostatic_eq_peos(potf)
    call calc_surface(potrs, potf)
    emd_bak = emd 
    call update_matter(potf,emd,conv_den)
!!    call calc_surface(potrs, emd)
    call update_surface(potrs,rs,conv_den)
    call reset_fluid
    call update_parameter_peos(conv_den)
    call calc_vector_x_matter(1)
    call calc_vector_phi_matter(1)
! -- calculate error and print it out.
  if (ihy.eq.1) then
    call error_matter_type2(emd,emd_bak,error_emd,flag)
    call printout_error(iter_count,error_emd)
  end if
  end do
end if
!
!!    if ((flag == 0).and.(flag_param==0).and.&
!!    &   (flag_psi==0).and.(flag_alph==0).and. &
!!    &   (flag_bvxd==0).and.(flag_bvyd==0).and.(flag_bvzd==0)) exit
    if (flag == 0) exit
    if (iter_count >= iter_max) exit
!
    error_emd_tmp    = error_emd
    error_metric_tmp = dmax1(error_psi,error_alph, &
    &                        error_bvxd,error_bvyd,error_bvzd)
!
    flag = 0
    flag_psi = 0
    flag_alph = 0
    flag_bvxd = 0
    flag_bvyd = 0
    flag_bvzd = 0
    flag_param= 0
    error_emd  = 0.0d0
    error_psi  = 0.0d0
    error_alph = 0.0d0
    error_bvxd = 0.0d0
    error_bvyd = 0.0d0
    error_bvzd = 0.0d0
!
  end do
!
  deallocate(sou)
  deallocate(sou2)
  deallocate(potx)
  deallocate(poty)
  deallocate(potz)
  deallocate(pot)
  deallocate(potf)
  deallocate(emd_bak)
  deallocate(potx_bak)
  deallocate(poty_bak)
  deallocate(potz_bak)
  deallocate(potrs)
  deallocate(souvec)
end subroutine iteration_peos_gp4th
