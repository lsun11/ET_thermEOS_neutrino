subroutine iteration_WL_MHD(iter_count)
  use phys_constant, only :  long, nnrg, nntg, nnpg
  use def_formulation, only : chgra, chope
  use def_metric_hij, only : hxxd, hxyd, hxzd, hyyd, hyzd, hzzd
  use def_emfield, only : va, alva, vaxd, vayd, vazd, jtu,jxu,jyu,jzu
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
  use interface_poisson_solver_Az
!  use interface_sourceterm_HaC_peos
!  use interface_sourceterm_trG_peos
!  use interface_sourceterm_MoC_peos
  use interface_compute_shift
  use interface_compute_alps2alph
  use interface_compute_fnc_multiple
  use interface_compute_fnc_division
  use interface_hydrostatic_eq_WL_MHD
  use interface_calc_surface
  use interface_update_grfield
  use interface_update_matter
  use interface_update_surface
  use interface_error_matter
  use interface_source_HaC_WL_EMF
  use interface_source_MoC_WL_EMF
  use interface_source_trfreeG_WL_EMF
  use interface_source_trG_WL_EMF
  use interface_source_MWtemp_WL
  use interface_source_MWspatial_WL
  use interface_compute_fnc_division
  use interface_compute_fnc_multiple
  use interface_error_metric_type0
  use interface_error_metric_type2_axisym
  use interface_calc_integrability_modify_At
  use interface_calc_integrability_modify_Aphi
  implicit none
  real(long), pointer :: sou(:,:,:), pot(:,:,:)
  real(long), pointer :: sou1(:,:,:), sou2(:,:,:), sou3(:,:,:)
  real(long), pointer :: sou4(:,:,:), sou5(:,:,:), sou6(:,:,:)
  real(long), pointer :: potf(:,:,:), emd_bak(:,:,:), pot_bak(:,:,:)
  real(long), pointer :: pottf(:,:,:), utf_bak(:,:,:)
  real(long), pointer :: potxf(:,:,:), uxf_bak(:,:,:)
  real(long), pointer :: potyf(:,:,:), uyf_bak(:,:,:)
  real(long), pointer :: potzf(:,:,:), uzf_bak(:,:,:)
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
  real(long) :: error_emd, count, error_field
  integer    :: iter_count, flag = 0, hydro_iter = 4, flag_charge = 0
  integer    :: irf, itf, ipf, irg, itg, ipg, ihy
!
  real(long) :: error_all(20)
  integer    :: flag_all(20) = (/0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0/)
  real(long) :: tic1, tic2
!
  call alloc_array3d(sou,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot,0,nrg,0,ntg,0,npg)
  call alloc_array3d(potf,0,nrf,0,ntf,0,npf)
  call alloc_array3d(pottf,0,nrf,0,ntf,0,npf)
  call alloc_array3d(potxf,0,nrf,0,ntf,0,npf)
  call alloc_array3d(potyf,0,nrf,0,ntf,0,npf)
  call alloc_array3d(potzf,0,nrf,0,ntf,0,npf)
  call alloc_array3d(emd_bak,0,nrf,0,ntf,0,npf)
  call alloc_array3d(utf_bak,0,nrf,0,ntf,0,npf)
  call alloc_array3d(uxf_bak,0,nrf,0,ntf,0,npf)
  call alloc_array3d(uyf_bak,0,nrf,0,ntf,0,npf)
  call alloc_array3d(uzf_bak,0,nrf,0,ntf,0,npf)
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
    conv_gra = dmin1(conv0_gra,conv_ini*count)
    conv_den = dmin1(conv0_den,conv_ini*count)
!
call cpu_time(tic1)
    call calc_vector_x_grav(1)
    call calc_vector_x_matter(1)
    call calc_vector_phi_grav(1)
    call calc_vector_phi_matter(1)
    call calc_shift_down2up
    call calc_shift2rotshift
!
!testtest
!testtest    call test_current
!testtest
!==============================================
    if (chgra == 'i') call cleargeometry
    if (chgra /= 'i') then 
      call cristoffel_midpoint
      call cristoffel_gridpoint
!call cpu_time(tic1)
      call riccitensor_midpoint
!call cpu_time(tic2)
!write(6,*)'time riccitensor_midpoint', tic2-tic1 ; tic1=tic2
    end if
    if (chgra == 'h'.or.chgra == 'c'.or.chgra == 'C' &
        &.or.chgra == 'H'.or.chgra == 'W') then 
      call liegmab_midpoint
      call liegmab_gridpoint
    end if
!
    call excurve_WL_midpoint
    call excurve_WL_gridpoint
    call compute_fnc_multiple(alph,psi,alps)
    call compute_fnc_multiple(alph,va,alva)
    call derivatives_EM1form
    call faraday
    call faraday_gridpoint
    call faraday_raise_WL
    call faraday_raise_gridpoint_WL
    call SEM_tensor_EMF
    call SEM_and_current_on_SFC
call cpu_time(tic2)
write(6,*)'time SEM_and_current_on_SFC', tic2-tic1 ; tic1=tic2
!
!
!==============================================
!$omp parallel sections num_threads(2)
!$omp section
! -- psi
!    call SEM_and_current_on_SFC
    call source_HaC_WL_EMF(sou1)
    call poisson_solver(sou1,pot1)
    pot1 = pot1 + 1.0d0
!$omp section
! -- alps
!    call SEM_and_current_on_SFC
    call source_trG_WL_EMF(sou2)
    call poisson_solver(sou2,pot2)
    pot2 = pot2 + 1.0d0
!$omp end parallel sections
!
! -- psi update
    pot_bak = psi
    call update_grfield(pot1,psi,conv_gra)
!WIND    call update_parameter_WL_MHD(conv_den)
    call update_parameter_WL_MHD_GS(conv_den)
!    call error_metric_type0(psi,pot_bak,error_all(1),flag_all(1),'ns')
    call error_metric_type2_axisym(psi,pot_bak,error_all(1),flag_all(1),'ns')
!
!!! -- alps
!!!!!    call SEM_and_current_on_SFC
!!!    call source_trG_WL_EMF(sou2)
!!!    call poisson_solver(sou2,pot2)
!!!    pot2 = pot2 + 1.0d0
!
! -- alph update
    call compute_alps2alph(pot2,psi)
    pot_bak = alph
    call update_grfield(pot2,alph,conv_gra)
!WIND    call update_parameter_WL_MHD(conv_den)
    call update_parameter_WL_MHD_GS(conv_den)
!    call error_metric_type0(alph,pot_bak,error_all(2),flag_all(2),'ns')
    call error_metric_type2_axisym(alph,pot_bak,error_all(2),flag_all(2),'ns')
! --
    call printout_error_metric_combined_2(iter_count,error_all(1),error_all(2))
!
call cpu_time(tic2)
write(6,*)'time psi alpha', tic2-tic1 ; tic1=tic2
! -- shift
!    call SEM_and_current_on_SFC
    call source_MoC_WL_EMF(souvec)
!$omp parallel sections num_threads(3)
!$omp section
    sou1(1:nrg, 1:ntg, 1:npg) = souvec(1:nrg, 1:ntg, 1:npg, 1)
    call poisson_solver(sou1,potx)
!$omp section
    sou2(1:nrg, 1:ntg, 1:npg) = souvec(1:nrg, 1:ntg, 1:npg, 2)
    call poisson_solver(sou2,poty)
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
!WIND    call update_parameter_WL_MHD(conv_den)
    call update_parameter_WL_MHD_GS(conv_den)
    call error_metric_type2_axisym(bvxd,potx_bak,error_all(3),flag_all(3),'ns')
    call error_metric_type2_axisym(bvyd,poty_bak,error_all(4),flag_all(4),'ns')
    call error_metric_type2_axisym(bvzd,potz_bak,error_all(5),flag_all(5),'ns')
    call printout_error_metric_combined_3(iter_count,error_all(3), &
    &                                   error_all(4),error_all(5))
!
call cpu_time(tic2)
write(6,*)'time shift', tic2-tic1 ; tic1=tic2
!==============================================
!
! --  For hij
!
!testtest  if (chgra == 'i') go to 9000
!
!    call SEM_and_current_on_SFC
    call source_trfreeG_WL_EMF(souten)
!
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
!    call gauge
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
!
    call invhij
    call compute_fnc_multiple(alph,psi,alps)
!
!WIND    call update_parameter_WL_MHD(conv_den)
    call update_parameter_WL_MHD_GS(conv_den)
    call error_metric_type2_axisym(hxxd,bk1,error_all(6),flag_all(6),'ns')
    call error_metric_type2_axisym(hxyd,bk2,error_all(7),flag_all(7),'ns')
    call error_metric_type2_axisym(hxzd,bk3,error_all(8),flag_all(8),'ns')
    call error_metric_type2_axisym(hyyd,bk4,error_all(9),flag_all(9),'ns')
    call error_metric_type2_axisym(hyzd,bk5,error_all(10),flag_all(10),'ns')
    call error_metric_type2_axisym(hzzd,bk6,error_all(11),flag_all(11),'ns')
    call printout_error_metric_combined_3(iter_count,error_all(6), &
    &                                   error_all(7),error_all(8))
    call printout_error_metric_combined_3(iter_count,error_all(9), &
    &                                   error_all(10),error_all(11))
!
call cpu_time(tic2)
write(6,*)'time hij', tic2-tic1 ; tic1=tic2
! --  IWM formalism
!
 9000 continue
!
! --  Maxwell equation component normal to hypersuface
!
!    call SEM_and_current_on_SFC
    call source_MWtemp_WL(sou)
    call poisson_solver(sou,pot)
    call compute_fnc_division(pot,alph,work)
! Replace A_t inside of NS
!    call calc_integrability_modify_At(va,'ns')
!    call calc_integrability_modify_At(work,'ns')
! Replace A_t end
    pot_bak = va
    call update_grfield(work,va,conv_gra)
!WIND    call update_parameter_WL_MHD(conv_den)
    call update_parameter_WL_MHD_GS(conv_den)
    call compute_fnc_multiple(alph,va,alva)
    call error_metric_type2_axisym(va,pot_bak,error_all(12),flag_all(12),'ns')
    call printout_error_metric(iter_count,error_all(12))
!
call cpu_time(tic2)
write(6,*)'time At', tic2-tic1 ; tic1=tic2
! --  Maxwell equation components in hypersuface
!
!    call SEM_and_current_on_SFC
    call source_MWspatial_WL(souvec)
!
!$omp parallel sections num_threads(3)
!$omp section
    sou1(1:nrg, 1:ntg, 1:npg) = souvec(1:nrg, 1:ntg, 1:npg, 1)
    call poisson_solver(sou1,potx)
!$omp section
    sou2(1:nrg, 1:ntg, 1:npg) = souvec(1:nrg, 1:ntg, 1:npg, 2)
    call poisson_solver(sou2,poty)
!$omp section
    sou3(1:nrg, 1:ntg, 1:npg) = souvec(1:nrg, 1:ntg, 1:npg, 3)
    call poisson_solver(sou3,potz)
!    call poisson_solver_Az(sou2,potz)
!$omp end parallel sections
!
    bk1(0:nrg,0:ntg,0:npg) = vaxd(0:nrg,0:ntg,0:npg)
    bk2(0:nrg,0:ntg,0:npg) = vayd(0:nrg,0:ntg,0:npg)
    bk3(0:nrg,0:ntg,0:npg) = vazd(0:nrg,0:ntg,0:npg)
    vaxd(0:nrg,0:ntg,0:npg) = potx(0:nrg,0:ntg,0:npg)
    vayd(0:nrg,0:ntg,0:npg) = poty(0:nrg,0:ntg,0:npg)
    vazd(0:nrg,0:ntg,0:npg) = potz(0:nrg,0:ntg,0:npg)
!                                                                              
    call gauge_Coulomb
!
!   improve by iteration
    potx(0:nrg,0:ntg,0:npg) = vaxd(0:nrg,0:ntg,0:npg)
    poty(0:nrg,0:ntg,0:npg) = vayd(0:nrg,0:ntg,0:npg)
    potz(0:nrg,0:ntg,0:npg) = vazd(0:nrg,0:ntg,0:npg)
    vaxd(0:nrg,0:ntg,0:npg) = bk1(0:nrg,0:ntg,0:npg)
    vayd(0:nrg,0:ntg,0:npg) = bk2(0:nrg,0:ntg,0:npg)
    vazd(0:nrg,0:ntg,0:npg) = bk3(0:nrg,0:ntg,0:npg)
!
    call update_grfield(potx,vaxd,conv_gra)
    call update_grfield(poty,vayd,conv_gra)
    call update_grfield(potz,vazd,conv_gra)
!WIND    call update_parameter_WL_MHD(conv_den)
    call update_parameter_WL_MHD_GS(conv_den)
    call error_metric_type2_axisym(vaxd,bk1,error_all(13),flag_all(13),'ns')
    call error_metric_type2_axisym(vayd,bk2,error_all(14),flag_all(14),'ns')
    call error_metric_type2_axisym(vazd,bk3,error_all(15),flag_all(15),'ns')
    call printout_error_metric_combined_3(iter_count,error_all(13), &
    &                                  error_all(14),error_all(15))
!
    call calc_Aphi_max
  if (mod(iter_count,30).eq.0) then
!    call adjust_charge(flag_charge)
  end if
call cpu_time(tic2)
write(6,*)'time Ai', tic2-tic1 ; tic1=tic2
!    call adjust_charge_bisection(flag_charge)
!!    call calc_MHDpar_charge
! Replace A_t inside of NS
!call cpu_time(tic1)
!    call calc_integrability_modify_Aphi(vaxd,vayd,'ns')
!!!
!!!    impose At(Aphi) function 
!!!    call calc_integrability_modify_At(va,'ns')
!!!
!call cpu_time(tic2)
!write(6,*)'time calc_integrability_modify_At', tic2-tic1 ; tic1=tic2
! Replace A_t end
!
!!      itg = ntgeq; ipg = npgxzp
      itg = ntgeq-2; ipg = 2
!!      itg = 73; ipg = 16
      open(15,file='test_vec',status='unknown')
        do irg = 0, nrg
          write(15,'(1p,9e20.12)')  rg(irg),  va(irg,itg,ipg)  &
              &                                , vaxd(irg,itg,ipg) &
              &                                , vayd(irg,itg,ipg) &
              &                                , vazd(irg,itg,ipg) &
              &                                , jtu(irg,itg,ipg) &
              &                                , jxu(irg,itg,ipg) &
              &                                , jyu(irg,itg,ipg) &
              &                                , jzu(irg,itg,ipg)
        end do
      close(15)
!
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
!==============================================
!
! -- MHD equations.
!testtest
! skip hydro equations
!goto 9400
!testtest
do ihy = 1, hydro_iter
  if (ihy.eq.1) then 
    emd_bak = emd
    utf_bak = utf ; uxf_bak = uxf ; uyf_bak = uyf ; uzf_bak = uzf
  end if
    potf = emd 
    pottf = utf ; potxf = uxf ; potyf = uyf ; potzf = uzf
!    call SEM_and_current_on_SFC
    call hydrostatic_eq_WL_MHD(potf,pottf,potxf,potyf,potzf)
    call calc_surface(potrs, potf)
    call update_matter(potf,emd,conv_den)
    call update_matter(pottf,utf,conv_den)
    call update_matter(potxf,uxf,conv_den)
    call update_matter(potyf,uyf,conv_den)
    call update_matter(potzf,uzf,conv_den)
    call update_surface(potrs,rs,conv_den)
    call reset_fluid
!WIND    call update_parameter_WL_MHD(conv_den)
    call update_parameter_WL_MHD_GS(conv_den)
    call calc_vector_x_matter(1)
    call calc_vector_phi_matter(1)
! -- calculate error and print it out.
if (ihy.eq.hydro_iter) then
    call error_matter(emd,emd_bak,error_all(16),flag_all(16))
    call error_matter(utf,utf_bak,error_all(17),flag_all(17))
    call error_matter(uxf,uxf_bak,error_all(18),flag_all(18))
    call error_matter(uyf,uyf_bak,error_all(19),flag_all(19))
    call error_matter(uzf,uzf_bak,error_all(20),flag_all(20))
end if
end do
! --
    call printout_error(iter_count,error_all(16))
    call printout_error(iter_count,error_all(17))
    call printout_error(iter_count,error_all(18))
    call printout_error(iter_count,error_all(19))
    call printout_error(iter_count,error_all(20))
!
call cpu_time(tic2)
write(6,*)'time hydro', tic2-tic1 ; tic1=tic2
!testtest
!9400 continue
!testtest
!
! ---
!
    if (flag_all(1)==0.and.flag_all(2)==0.and.flag_all(3)==0.and.&
    &   flag_all(4)==0.and.flag_all(5)==0.and.flag_all(6)==0.and.&
    &   flag_all(7)==0.and.flag_all(8)==0.and.flag_all(9)==0.and.&
    &   flag_all(10)==0.and.flag_all(11)==0.and.flag_all(12)==0.and.&
    &   flag_all(13)==0.and.flag_all(14)==0.and.flag_all(15)==0.and.&
    &   flag_all(16)==0.and.flag_all(17)==0.and.flag_all(18)==0.and.&
    &   flag_all(19)==0.and.flag_all(20)==0) exit
    if (iter_count >= iter_max) exit
!
    flag = 0
    flag_all(1:20) = 0
!
  end do
!
  deallocate(sou)
  deallocate(pot)
  deallocate(sou2)
  deallocate(potf)
  deallocate(pottf)
  deallocate(potxf)
  deallocate(potyf)
  deallocate(potzf)
  deallocate(emd_bak)
  deallocate(utf_bak)
  deallocate(uxf_bak)
  deallocate(uyf_bak)
  deallocate(uzf_bak)
  deallocate(potrs)
  deallocate(potx)
  deallocate(poty)
  deallocate(potz)
  deallocate(souvec)
  deallocate(souten)
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
end subroutine iteration_WL_MHD
