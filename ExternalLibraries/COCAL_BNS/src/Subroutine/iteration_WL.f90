subroutine iteration_WL(iter_count)
  use phys_constant, only :  long, nnrg, nntg, nnpg
  use def_formulation, only : chgra, chope
  use def_metric_hij, only : hxxd, hxyd, hxzd, hyyd, hyzd, hzzd
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
  use interface_interpo_fl2gr
  use interface_poisson_solver
!  use interface_sourceterm_HaC_peos
!  use interface_sourceterm_trG_peos
!  use interface_sourceterm_MoC_peos
  use interface_compute_shift
  use interface_compute_alps2alph
  use interface_hydrostatic_eq_WL_peos
  use interface_calc_surface
  use interface_update_grfield
  use interface_update_matter
  use interface_update_parameter_WL_peos
  use interface_update_surface
  use interface_error_matter
  use interface_error_matter_type3
  use interface_source_HaC_WL
  use interface_source_MoC_WL
  use interface_source_trfreeG_WL
  use interface_source_trG_WL
  use interface_compute_fnc_multiple
  use interface_error_metric_type0
  use interface_error_metric_type2
  use interface_error_metric_type3
  implicit none
  real(long), pointer :: sou(:,:,:), pot(:,:,:)
  real(long), pointer :: sou1(:,:,:), sou2(:,:,:), sou3(:,:,:)
  real(long), pointer :: sou4(:,:,:), sou5(:,:,:), sou6(:,:,:)
  real(long), pointer :: potf(:,:,:), emd_bak(:,:,:), pot_bak(:,:,:)
  real(long), pointer :: potrs(:,:)
  real(long), pointer :: potx(:,:,:), poty(:,:,:), potz(:,:,:)
  real(long), pointer :: potx_bak(:,:,:), poty_bak(:,:,:), potz_bak(:,:,:)
  real(long), pointer :: souvec(:,:,:,:), souten(:,:,:,:)
  real(long), pointer :: pot1(:,:,:), pot2(:,:,:), pot3(:,:,:)
  real(long), pointer :: pot4(:,:,:), pot5(:,:,:), pot6(:,:,:)
  real(long), pointer :: bk1(:,:,:), bk2(:,:,:), bk3(:,:,:)
  real(long), pointer :: bk4(:,:,:), bk5(:,:,:), bk6(:,:,:)
  real(long), pointer :: work(:,:,:)
!  real(long) :: work(0:nnrg,0:nntg,0:nnpg)
  real(long) :: error_emd, count
  integer    :: iter_count, flag = 0, hydro_iter = 4
  integer    :: irf, itf, ipf, irg, itg, ipg, ihy
!
  real(long) :: error_all(20)
  integer    :: flag_all(20) = (/0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0/)
!
  call alloc_array3d(sou,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot,0,nrg,0,ntg,0,npg)
  call alloc_array3d(potf,0,nrf,0,ntf,0,npf)
  call alloc_array3d(emd_bak,0,nrf,0,ntf,0,npf)
  call alloc_array2d(potrs,0,ntf,0,npf)
  call alloc_array3d(potx,0,nrg,0,ntg,0,npg)
  call alloc_array3d(poty,0,nrg,0,ntg,0,npg)
  call alloc_array3d(potz,0,nrg,0,ntg,0,npg)
  call alloc_array4d(souvec,0,nrg,0,ntg,0,npg,1,3)
  call alloc_array4d(souten,0,nrg,0,ntg,0,npg,1,6)
  call alloc_array3d(sou1,0,nrg,0,ntg,0,npg)
  call alloc_array3d(sou2,0,nrg,0,ntg,0,npg)
  call alloc_array3d(sou3,0,nrg,0,ntg,0,npg)
  call alloc_array3d(sou4,0,nrg,0,ntg,0,npg)
  call alloc_array3d(sou5,0,nrg,0,ntg,0,npg)
  call alloc_array3d(sou6,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot1,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot2,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot3,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot4,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot5,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot6,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot_bak,0,nrg,0,ntg,0,npg)
  call alloc_array3d(potx_bak,0,nrg,0,ntg,0,npg)
  call alloc_array3d(poty_bak,0,nrg,0,ntg,0,npg)
  call alloc_array3d(potz_bak,0,nrg,0,ntg,0,npg)
  call alloc_array3d(bk1,0,nrg,0,ntg,0,npg)
  call alloc_array3d(bk2,0,nrg,0,ntg,0,npg)
  call alloc_array3d(bk3,0,nrg,0,ntg,0,npg)
  call alloc_array3d(bk4,0,nrg,0,ntg,0,npg)
  call alloc_array3d(bk5,0,nrg,0,ntg,0,npg)
  call alloc_array3d(bk6,0,nrg,0,ntg,0,npg)
  call alloc_array3d(work,0,nrg,0,ntg,0,npg)
!
  iter_count = 0
  do
    iter_count = iter_count + 1      
    count = dble(iter_count) 
    write(6,'(a54,i4,a54)')   "------------------------------------------- Iteration ", iter_count, &
                         &    " : Errors --------------------------------------------"
 
    conv_gra = dmin1(conv0_gra,conv_ini*count)
    conv_den = dmin1(conv0_den,conv_ini*count)
!
    emdg = 0.0d0
    call calc_vector_x_grav(1)
    call calc_vector_x_matter(1)
    call calc_vector_phi_grav(1)
    call calc_vector_phi_matter(1)
    call interpo_fl2gr(emd, emdg)
    call calc_shift_down2up
    call interpo_gr2fl_metric_WL
    call rotation_law_WL  ! calculate omef and omeg
    call calc_shift2rotshift
    call SEM_tensor
!
!==============================================
    if (chgra == 'i') call cleargeometry
    if (chgra /= 'i') then 
      call cristoffel_midpoint
      call cristoffel_gridpoint
      call riccitensor_midpoint
    end if
    if (chgra == 'h'.or.chgra == 'c'.or.chgra == 'C' &
        &.or.chgra == 'H'.or.chgra == 'W') then 
      call liegmab_midpoint
      call liegmab_gridpoint
    end if
!
    call excurve_WL_midpoint
    call excurve_WL_gridpoint
    call ap2alps
!==============================================
!pa -- psi
!pa    call source_HaC_WL(sou)
!pa    call poisson_solver(sou,pot)
!pa    pot(0:nrg,0:ntg,0:npg) = pot(0:nrg,0:ntg,0:npg) + 1.0d0
!pa    pot_bak(0:nrg,0:ntg,0:npg) = psi(0:nrg,0:ntg,0:npg)
!pa    call update_grfield(pot,psi,conv_gra)
!pa    call update_parameter_WL_peos(conv_den)
!pa    call error_metric_type0(psi,pot_bak,error_all(1),flag_all(1),'ns')
!pa
!pa -- apls
!pa    call source_trG_WL(sou)
!pa    call poisson_solver(sou,pot2)
!pa    pot(0:nrg,0:ntg,0:npg) = pot(0:nrg,0:ntg,0:npg) + 1.0d0
!pa    pot_bak(0:nrg,0:ntg,0:npg) = alph(0:nrg,0:ntg,0:npg)
!pa    call compute_alps2alph(pot,psi)
!pa    call update_grfield(pot,alph,conv_gra)
!pa    call update_parameter_WL_peos(conv_den)
!pa    call error_metric_type0(alph,pot_bak,error_all(2),flag_all(2),'ns')
! --
!
!$omp parallel sections num_threads(2)
! -- psi
!$omp section
    call source_HaC_WL(sou1)
    call poisson_solver(sou1,pot1)
    pot1(0:nrg,0:ntg,0:npg) = pot1(0:nrg,0:ntg,0:npg) + 1.0d0
! -- apls
!$omp section
    call source_trG_WL(sou2)
    call poisson_solver(sou2,pot2)
    pot2(0:nrg,0:ntg,0:npg) = pot2(0:nrg,0:ntg,0:npg) + 1.0d0
!$omp end parallel sections
! -- psi  update
    pot_bak(0:nrg,0:ntg,0:npg) = psi(0:nrg,0:ntg,0:npg)
    call update_grfield(pot1,psi,conv_gra)
    call update_parameter_WL_peos(conv_den)
!    call error_metric_type0(psi,pot_bak,error_all(1),flag_all(1),'ns')
    call error_metric_type3(psi,pot_bak,error_all(1),flag_all(1),'ns', ' psi')
! -- alph update
    pot_bak(0:nrg,0:ntg,0:npg) = alph(0:nrg,0:ntg,0:npg)
    call compute_alps2alph(pot2,psi)
    call update_grfield(pot2,alph,conv_gra)
    call update_parameter_WL_peos(conv_den)
!    call error_metric_type0(alph,pot_bak,error_all(2),flag_all(2),'ns')
    call error_metric_type3(alph,pot_bak,error_all(2),flag_all(2),'ns','alph')
! --
!
!    call printout_error_metric_combined_2(iter_count,error_all(1),error_all(2))
!
! -- shift
    call source_MoC_WL(souvec)
!$omp parallel sections num_threads(3)
!    work(1:nrg, 1:ntg, 1:npg) = souvec(1:nrg, 1:ntg, 1:npg, 1)
!    sou1(1:nrg, 1:ntg, 1:npg) = work(1:nrg, 1:ntg, 1:npg)
!$omp section
    sou1(1:nrg, 1:ntg, 1:npg) = souvec(1:nrg, 1:ntg, 1:npg, 1)
    call poisson_solver(sou1,potx)
!    work(1:nrg, 1:ntg, 1:npg) = souvec(1:nrg, 1:ntg, 1:npg, 2)
!    sou2(1:nrg, 1:ntg, 1:npg) = work(1:nrg, 1:ntg, 1:npg)
!$omp section
    sou2(1:nrg, 1:ntg, 1:npg) = souvec(1:nrg, 1:ntg, 1:npg, 2)
    call poisson_solver(sou2,poty)
!    work(1:nrg, 1:ntg, 1:npg) = souvec(1:nrg, 1:ntg, 1:npg, 3)
!    sou3(1:nrg, 1:ntg, 1:npg) = work(1:nrg, 1:ntg, 1:npg)
!$omp section
    sou3(1:nrg, 1:ntg, 1:npg) = souvec(1:nrg, 1:ntg, 1:npg, 3)
    call poisson_solver(sou3,potz)
!$omp end parallel sections
!
!!    call poisson_solver(sou,pot)
!!    work(  0:nrg, 0:ntg, 0:npg)    = potx(0:nrg, 0:ntg, 0:npg)
!!    souvec(0:nrg, 0:ntg, 0:npg, 1) = work(0:nrg, 0:ntg, 0:npg)
!!    work(  0:nrg, 0:ntg, 0:npg)    = poty(0:nrg, 0:ntg, 0:npg)
!!    souvec(0:nrg, 0:ntg, 0:npg, 2) = work(0:nrg, 0:ntg, 0:npg)
!!    work(  0:nrg, 0:ntg, 0:npg)    = potz(0:nrg, 0:ntg, 0:npg)
!!    souvec(0:nrg, 0:ntg, 0:npg, 3) = work(0:nrg, 0:ntg, 0:npg)
!!    call compute_shift(potx, poty, potz, souvec, pot)
!
    potx_bak(0:nrg,0:ntg,0:npg) = bvxd(0:nrg,0:ntg,0:npg)
    poty_bak(0:nrg,0:ntg,0:npg) = bvyd(0:nrg,0:ntg,0:npg)
    potz_bak(0:nrg,0:ntg,0:npg) = bvzd(0:nrg,0:ntg,0:npg)
    call update_grfield(potx,bvxd,conv_gra)
    call update_grfield(poty,bvyd,conv_gra)
    call update_grfield(potz,bvzd,conv_gra)
    call update_parameter_WL_peos(conv_den)
!    call error_metric_type2(bvxd,potx_bak,error_all(3),flag_all(3),'ns')
!    call error_metric_type2(bvyd,poty_bak,error_all(4),flag_all(4),'ns')
!    call error_metric_type2(bvzd,potz_bak,error_all(5),flag_all(5),'ns')
    call error_metric_type3(bvxd,potx_bak,error_all(3),flag_all(3),'ns','bvxd')
    call error_metric_type3(bvyd,poty_bak,error_all(4),flag_all(4),'ns','bvyd')
    call error_metric_type3(bvzd,potz_bak,error_all(5),flag_all(5),'ns','bvzd')
!    call printout_error_metric_combined_3(iter_count,error_all(3), &
!    &                                   error_all(4),error_all(5))
!
!==============================================
!
!      write(6,"(a6,1p,3e11.3)") 'step 7', ome, ber, radi
!
! --  For hij
!
!  if (chgra == 'i') go to 9000
!
!do irg=0,nrg
!write(6,*) souten(irg,ntg/2,1,1), hxxd(irg,ntg/2,1)
!end do
    call source_trfreeG_WL(souten)
!  caallll surfhijsource(ssouten,dssouten,iter,chgra,chope)
!
!do irg=0,nrg
!write(6,*) souten(irg,ntg/2,1,1), hxxd(irg,ntg/2,1)
!end do
    pot_bak(0:nrg,0:ntg,0:npg) = psi(0:nrg,0:ntg,0:npg)
    bk1(0:nrg,0:ntg,0:npg) = hxxd(0:nrg,0:ntg,0:npg)
    bk2(0:nrg,0:ntg,0:npg) = hxyd(0:nrg,0:ntg,0:npg)
    bk3(0:nrg,0:ntg,0:npg) = hxzd(0:nrg,0:ntg,0:npg)
    bk4(0:nrg,0:ntg,0:npg) = hyyd(0:nrg,0:ntg,0:npg)
    bk5(0:nrg,0:ntg,0:npg) = hyzd(0:nrg,0:ntg,0:npg)
    bk6(0:nrg,0:ntg,0:npg) = hzzd(0:nrg,0:ntg,0:npg)
    hxxd(0:nrg,0:ntg,0:npg) = 0.0d0
    hxyd(0:nrg,0:ntg,0:npg) = 0.0d0
    hxzd(0:nrg,0:ntg,0:npg) = 0.0d0
    hyyd(0:nrg,0:ntg,0:npg) = 0.0d0
    hyzd(0:nrg,0:ntg,0:npg) = 0.0d0
    hzzd(0:nrg,0:ntg,0:npg) = 0.0d0
!
! --  Poisson solver.  
!
    if (chope == 'L') then
!
      sou1(0:nrg,0:ntg,0:npg) = souten(0:nrg,0:ntg,0:npg,1)
      sou2(0:nrg,0:ntg,0:npg) = souten(0:nrg,0:ntg,0:npg,2)
      sou3(0:nrg,0:ntg,0:npg) = souten(0:nrg,0:ntg,0:npg,3)
      sou4(0:nrg,0:ntg,0:npg) = souten(0:nrg,0:ntg,0:npg,4)
      sou5(0:nrg,0:ntg,0:npg) = souten(0:nrg,0:ntg,0:npg,5)
      sou6(0:nrg,0:ntg,0:npg) = souten(0:nrg,0:ntg,0:npg,6)
!$omp parallel sections num_threads(6)
!$omp section
      call poisson_solver(sou1,pot1)
!$omp section
      call poisson_solver(sou2,pot2)
!$omp section
      call poisson_solver(sou3,pot3)
!$omp section
      call poisson_solver(sou4,pot4)
!$omp section
      call poisson_solver(sou5,pot5)
!$omp section
      call poisson_solver(sou6,pot6)
!$omp end parallel sections
!
    end if
!
!do irg=0,nrg
!write(6,*) souten(irg,ntg/2,1,1)
!end do
! --  Helmholtz solver.  
!
!  if (chope == 'H') then
!    if (ii == 1) then
!      call hegr4(sou,pot,cosmpg,cosmpg,pnag,0,0,0,4)
!      call hegr4sfout(ome,ssou,dssou,spot,cosmpg,cosmpg,pnag,0,0,0,4)
!    end if
!  end if
!
    hxxd(0:nrg,0:ntg,0:npg) = pot1(0:nrg,0:ntg,0:npg)
    hxyd(0:nrg,0:ntg,0:npg) = pot2(0:nrg,0:ntg,0:npg)
    hxzd(0:nrg,0:ntg,0:npg) = pot3(0:nrg,0:ntg,0:npg)
    hyyd(0:nrg,0:ntg,0:npg) = pot4(0:nrg,0:ntg,0:npg)
    hyzd(0:nrg,0:ntg,0:npg) = pot5(0:nrg,0:ntg,0:npg)
    hzzd(0:nrg,0:ntg,0:npg) = pot6(0:nrg,0:ntg,0:npg)
!
! --  Set det(gamma_{ab}) = psi^12 and Dirac gauge for new variable.
!
!do irg=0,nrg
!write(6,*) souten(irg,ntg/2,1,1), hxxd(irg,ntg/2,1)
!end do
!  call gauge
    call invhij
    call gauge_hiju(conv_gra)
    call invhij_up2down
    call adjusthij
!
! --  improve by iteration
!
    pot(0:nrg,0:ntg,0:npg)  = psi(0:nrg,0:ntg,0:npg)
    pot1(0:nrg,0:ntg,0:npg) = hxxd(0:nrg,0:ntg,0:npg)
    pot2(0:nrg,0:ntg,0:npg) = hxyd(0:nrg,0:ntg,0:npg)
    pot3(0:nrg,0:ntg,0:npg) = hxzd(0:nrg,0:ntg,0:npg)
    pot4(0:nrg,0:ntg,0:npg) = hyyd(0:nrg,0:ntg,0:npg)
    pot5(0:nrg,0:ntg,0:npg) = hyzd(0:nrg,0:ntg,0:npg)
    pot6(0:nrg,0:ntg,0:npg) = hzzd(0:nrg,0:ntg,0:npg)
!
    psi(0:nrg,0:ntg,0:npg)  = pot_bak(0:nrg,0:ntg,0:npg)
    hxxd(0:nrg,0:ntg,0:npg) = bk1(0:nrg,0:ntg,0:npg)
    hxyd(0:nrg,0:ntg,0:npg) = bk2(0:nrg,0:ntg,0:npg)
    hxzd(0:nrg,0:ntg,0:npg) = bk3(0:nrg,0:ntg,0:npg)
    hyyd(0:nrg,0:ntg,0:npg) = bk4(0:nrg,0:ntg,0:npg)
    hyzd(0:nrg,0:ntg,0:npg) = bk5(0:nrg,0:ntg,0:npg)
    hzzd(0:nrg,0:ntg,0:npg) = bk6(0:nrg,0:ntg,0:npg)
!
    call update_grfield(pot_bak,psi,conv_gra)
    call update_grfield(pot1,hxxd,conv_gra)
    call update_grfield(pot2,hxyd,conv_gra)
    call update_grfield(pot3,hxzd,conv_gra)
    call update_grfield(pot4,hyyd,conv_gra)
    call update_grfield(pot5,hyzd,conv_gra)
    call update_grfield(pot6,hzzd,conv_gra)
!!    call update_grfield(pot1,hxxd,conv_gra*0.6d0)
!!    call update_grfield(pot2,hxyd,conv_gra*0.6d0)
!!    call update_grfield(pot3,hxzd,conv_gra*0.6d0)
!!    call update_grfield(pot4,hyyd,conv_gra*0.6d0)
!!    call update_grfield(pot5,hyzd,conv_gra*0.6d0)
!!    call update_grfield(pot6,hzzd,conv_gra*0.6d0)
!
    call invhij
    call compute_fnc_multiple(alph,psi,alps)
!
    call update_parameter_WL_peos(conv_den)
!    call error_metric_type2(hxxd,bk1,error_all(6),flag_all(6),'ns')
!    call error_metric_type2(hxyd,bk2,error_all(7),flag_all(7),'ns')
!    call error_metric_type2(hxzd,bk3,error_all(8),flag_all(8),'ns')
!    call error_metric_type2(hyyd,bk4,error_all(9),flag_all(9),'ns')
!    call error_metric_type2(hyzd,bk5,error_all(10),flag_all(10),'ns')
!    call error_metric_type2(hzzd,bk6,error_all(11),flag_all(11),'ns')
    call error_metric_type3(hxxd,bk1,error_all(6), flag_all(6), 'ns','hxxd')
    call error_metric_type3(hxyd,bk2,error_all(7), flag_all(7), 'ns','hxyd')
    call error_metric_type3(hxzd,bk3,error_all(8), flag_all(8), 'ns','hxzd')
    call error_metric_type3(hyyd,bk4,error_all(9), flag_all(9), 'ns','hyyd')
    call error_metric_type3(hyzd,bk5,error_all(10),flag_all(10),'ns','hyzd')
    call error_metric_type3(hzzd,bk6,error_all(11),flag_all(11),'ns','hzzd')
!    call printout_error_metric_combined_3(iter_count,error_all(6), &
!    &                                   error_all(7),error_all(8))
!    call printout_error_metric_combined_3(iter_count,error_all(9), &
!    &                                   error_all(10),error_all(11))
!
!      write(6,"(a6,1p,3e11.3)") 'step 9', ome, ber, radi
!
    itg = ntg/2-2; ipg = npg/2-2
    open(16,file='test_vec2',status='unknown')
      do irg = 0, nrg
        write(16,'(1p,12e20.12)') rg(irg),  psi(irg,itg,ipg)  &
            &                            , alph(irg,itg,ipg) &
            &                            , bvxd(irg,itg,ipg) &
            &                            , bvyd(irg,itg,ipg) &
            &                            , bvzd(irg,itg,ipg) &
            &                            , hxxd(irg,itg,ipg) &
            &                            , hxyd(irg,itg,ipg) &
            &                            , hxzd(irg,itg,ipg) &
            &                            , hyyd(irg,itg,ipg) &
            &                            , hyzd(irg,itg,ipg) &
            &                            , hzzd(irg,itg,ipg)
      end do
    close(16)
!
! --  IWM formalism
!
! 9000 continue
!
!==============================================
!
! --Hydro equations.
    do ihy = 1, hydro_iter
      if (ihy.eq.1) emd_bak = emd 
      call interpo_gr2fl_metric_WL
      call rotation_law_WL
      call hydrostatic_eq_WL_peos(potf)
      call calc_surface(potrs, potf)
      call update_matter(potf,emd,conv_den)
      call update_surface(potrs,rs,conv_den)
      call reset_fluid
      call update_parameter_WL_peos(conv_den)
      call calc_vector_x_matter(1)
      call calc_vector_phi_matter(1)
! -- calculate error and print it out.
      if (ihy.eq.hydro_iter) then
!       call error_matter(emd,emd_bak,error_all(12),flag_all(12))
        call error_matter_type3(emd,emd_bak,error_all(12),flag_all(12),' emd')
!        call printout_error(iter_count,error_all(12))
      end if
    end do
!
!all    if (flag_all(1)==0.and.flag_all(2)==0.and.flag_all(3)==0.and.&
!all    &   flag_all(4)==0.and.flag_all(5)==0.and.flag_all(6)==0.and.&
!all    &   flag_all(7)==0.and.flag_all(8)==0.and.flag_all(9)==0.and.&
!all    &   flag_all(10)==0.and.flag_all(11)==0.and.flag_all(12)==0.and.&
!all    &   flag_all(13)==0.and.flag_all(14)==0.and.flag_all(15)==0.and.&
!all    &   flag_all(16)==0.and.flag_all(17)==0.and.flag_all(18)==0.and.&
!all    &   flag_all(19)==0.and.flag_all(20)==0) exit
    if (flag_all(12)==0) then
      write(6,*) '------ all flags=0 ------ exit iteration -----'
      exit
    end if

    if (iter_count >= iter_max) exit
    flag = 0
    flag_all(1:20) = 0
!
  end do
!
  deallocate(sou)
  deallocate(pot)
  deallocate(potf)
  deallocate(emd_bak)
  deallocate(potrs)
  deallocate(potx)
  deallocate(poty)
  deallocate(potz)
  deallocate(souvec)
  deallocate(souten)
  deallocate(sou1)
  deallocate(sou2)
  deallocate(sou3)
  deallocate(sou4)
  deallocate(sou5)
  deallocate(sou6)
  deallocate(pot1)
  deallocate(pot2)
  deallocate(pot3)
  deallocate(pot4)
  deallocate(pot5)
  deallocate(pot6)
  deallocate(pot_bak)
  deallocate(potx_bak)
  deallocate(poty_bak)
  deallocate(potz_bak)
  deallocate(bk1)
  deallocate(bk2)
  deallocate(bk3)
  deallocate(bk4)
  deallocate(bk5)
  deallocate(bk6)
  deallocate(work)
end subroutine iteration_WL
