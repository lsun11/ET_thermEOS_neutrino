subroutine iteration_irbns_WL(iter_count)
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
  use interface_source_HaC_WL
  use interface_source_MoC_WL
  use interface_source_trfreeG_WL
  use interface_source_trG_WL
  implicit none
  real(long), pointer :: sou(:,:,:), pot(:,:,:), sou2(:,:,:)
  real(long), pointer :: potf(:,:,:), emd_bak(:,:,:)
  real(long), pointer :: potrs(:,:)
  real(long), pointer :: potx(:,:,:), poty(:,:,:), potz(:,:,:)
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
  call alloc_array3d(sou,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot,0,nrg,0,ntg,0,npg)
  call alloc_array3d(sou2,0,nrg,0,ntg,0,npg)
  call alloc_array3d(potf,0,nrf,0,ntf,0,npf)
  call alloc_array3d(emd_bak,0,nrf,0,ntf,0,npf)
  call alloc_array2d(potrs,0,ntf,0,npf)
  call alloc_array3d(potx,0,nrg,0,ntg,0,npg)
  call alloc_array3d(poty,0,nrg,0,ntg,0,npg)
  call alloc_array3d(potz,0,nrg,0,ntg,0,npg)
  call alloc_array4d(souvec,0,nrg,0,ntg,0,npg,1,3)
  call alloc_array4d(souten,0,nrg,0,ntg,0,npg,1,6)
  call alloc_array3d(pot1,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot2,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot3,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot4,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot5,0,nrg,0,ntg,0,npg)
  call alloc_array3d(pot6,0,nrg,0,ntg,0,npg)
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
    emdg = 0.0d0
    call interpo_fl2gr(emd, emdg)
!
    call calc_vector_x_grav(1)
    call calc_vector_x_matter(1)
    call calc_vector_phi_grav(1)
    call calc_vector_phi_matter(1)
    call calc_shift_down2up
    call calc_shift2rotshift
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
! --
    call source_HaC_WL(sou)
!
    call poisson_solver(sou,pot)
    pot = pot + 1.0d0
    call update_grfield(pot,psi,conv_gra)
    call update_parameter_WL_peos(conv_den)
! --
!
    call source_trG_WL(sou)
    call poisson_solver(sou,pot)
    pot = pot + 1.0d0
    call compute_alps2alph(pot,psi)
    call update_grfield(pot,alph,conv_gra)
    call update_parameter_WL_peos(conv_den)
! --
    call source_MoC_WL(souvec,sou)
    work(1:nrg, 1:ntg, 1:npg) = souvec(1:nrg, 1:ntg, 1:npg, 1)
    sou2(1:nrg, 1:ntg, 1:npg) = work(1:nrg, 1:ntg, 1:npg)
    call poisson_solver(sou2,potx)
    work(1:nrg, 1:ntg, 1:npg) = souvec(1:nrg, 1:ntg, 1:npg, 2)
    sou2(1:nrg, 1:ntg, 1:npg) = work(1:nrg, 1:ntg, 1:npg)
    call poisson_solver(sou2,poty)
    work(1:nrg, 1:ntg, 1:npg) = souvec(1:nrg, 1:ntg, 1:npg, 3)
    sou2(1:nrg, 1:ntg, 1:npg) = work(1:nrg, 1:ntg, 1:npg)
    call poisson_solver(sou2,potz)
    call poisson_solver(sou,pot)
    work(  0:nrg, 0:ntg, 0:npg)    = potx(0:nrg, 0:ntg, 0:npg)
    souvec(0:nrg, 0:ntg, 0:npg, 1) = work(0:nrg, 0:ntg, 0:npg)
    work(  0:nrg, 0:ntg, 0:npg)    = poty(0:nrg, 0:ntg, 0:npg)
    souvec(0:nrg, 0:ntg, 0:npg, 2) = work(0:nrg, 0:ntg, 0:npg)
    work(  0:nrg, 0:ntg, 0:npg)    = potz(0:nrg, 0:ntg, 0:npg)
    souvec(0:nrg, 0:ntg, 0:npg, 3) = work(0:nrg, 0:ntg, 0:npg)
    call compute_shift(potx, poty, potz, souvec, pot)
    call update_grfield(potx,bvxd,conv_gra)
    call update_grfield(poty,bvyd,conv_gra)
    call update_grfield(potz,bvzd,conv_gra)
    call update_parameter_WL_peos(conv_den)
!
!==============================================
!
!      write(6,"(a6,1p,3e11.3)") 'step 7', ome, ber, radi
!
! --  For hij
!
    if (chgra == 'i') go to 9000
!
!do irg=0,nrg
!write(6,*) souten(irg,ntg/2,1,1), hxxd(irg,ntg/2,1)
!end do
    call source_trfreeG_WL(souten)
!  call surfhijsource(ssouten,dssouten,iter,chgra,chope)
!
!  if (chope == 'H') then
!    call hrhafn(ome)
!  end if
!
!do irg=0,nrg
!write(6,*) souten(irg,ntg/2,1,1), hxxd(irg,ntg/2,1)
!end do  
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
      sou(0:nrg,0:ntg,0:npg) = souten(0:nrg,0:ntg,0:npg,1)
      call poisson_solver(sou,pot1)
      sou(0:nrg,0:ntg,0:npg) = souten(0:nrg,0:ntg,0:npg,2)
      call poisson_solver(sou,pot2)
      sou(0:nrg,0:ntg,0:npg) = souten(0:nrg,0:ntg,0:npg,3)
      call poisson_solver(sou,pot3)
      sou(0:nrg,0:ntg,0:npg) = souten(0:nrg,0:ntg,0:npg,4)
      call poisson_solver(sou,pot4)
      sou(0:nrg,0:ntg,0:npg) = souten(0:nrg,0:ntg,0:npg,5)
      call poisson_solver(sou,pot5)
      sou(0:nrg,0:ntg,0:npg) = souten(0:nrg,0:ntg,0:npg,6)
      call poisson_solver(sou,pot6)
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
    call gauge
    call adjusthij
!
! --  improve by iteration
!
    pot1(0:nrg,0:ntg,0:npg) = hxxd(0:nrg,0:ntg,0:npg)
    pot2(0:nrg,0:ntg,0:npg) = hxyd(0:nrg,0:ntg,0:npg)
    pot3(0:nrg,0:ntg,0:npg) = hxzd(0:nrg,0:ntg,0:npg)
    pot4(0:nrg,0:ntg,0:npg) = hyyd(0:nrg,0:ntg,0:npg)
    pot5(0:nrg,0:ntg,0:npg) = hyzd(0:nrg,0:ntg,0:npg)
    pot6(0:nrg,0:ntg,0:npg) = hzzd(0:nrg,0:ntg,0:npg)
!
    hxxd(0:nrg,0:ntg,0:npg) = bk1(0:nrg,0:ntg,0:npg)
    hxyd(0:nrg,0:ntg,0:npg) = bk2(0:nrg,0:ntg,0:npg)
    hxzd(0:nrg,0:ntg,0:npg) = bk3(0:nrg,0:ntg,0:npg)
    hyyd(0:nrg,0:ntg,0:npg) = bk4(0:nrg,0:ntg,0:npg)
    hyzd(0:nrg,0:ntg,0:npg) = bk5(0:nrg,0:ntg,0:npg)
    hzzd(0:nrg,0:ntg,0:npg) = bk6(0:nrg,0:ntg,0:npg)
!
    call update_grfield(pot1,hxxd,conv_gra)
    call update_grfield(pot2,hxyd,conv_gra)
    call update_grfield(pot3,hxzd,conv_gra)
    call update_grfield(pot4,hyyd,conv_gra)
    call update_grfield(pot5,hyzd,conv_gra)
    call update_grfield(pot6,hzzd,conv_gra)
!
    call invhij
!
    call update_parameter_WL_peos(conv_den)
!
!      write(6,"(a6,1p,3e11.3)") 'step 9', ome, ber, radi
!
! --  IWM formalism
!
 9000 continue
!
!==============================================
!
! -- Hydro equations.
!
    call interpo_gr2fl_metric_WL
    do ihy = 1, hydro_iter
      if (ihy.eq.1) emd_bak = emd 
      call hydro_irbns_1stint_WL_peos(potf)
      call calc_surface(potrs, potf)
      call update_matter(potf,emd,conv_den)
      call update_surface(potrs,rs,conv_den)
      call reset_fluid
      call update_parameter_WL_peos(conv_den)
      call calc_vector_x_matter(1)
      call calc_vector_phi_matter(1)
!
      call hydro_irbns_vep_WL_peos(potf)
      call update_matter(potf,vep,conv_vep)
      call reset_fluid_vep
      call update_parameter_WL_peos(conv_den)
! -- calculate error and print it out.
      if (ihy.eq.hydro_iter) then
        call error_matter(emd,emd_bak,error_emd,flag)
        call printout_error(iter_count,error_emd)
      end if
    end do
!
    if (flag == 0) exit
    if (iter_count >= iter_max) exit
    flag = 0
!
  end do
!
  deallocate(sou)
  deallocate(pot)
  deallocate(sou2)
  deallocate(potf)
  deallocate(emd_bak)
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
  deallocate(bk1)
  deallocate(bk2)
  deallocate(bk3)
  deallocate(bk4)
  deallocate(bk5)
  deallocate(bk6)
  deallocate(work)
end subroutine iteration_irbns_WL
