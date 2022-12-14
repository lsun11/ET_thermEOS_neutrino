subroutine peos2teos(nlines)
!
  use phys_constant        !g,c,solmas,nnpeos
  use def_peos_parameter   !abc,abi,rhoi,qi,hi,nphase,rhoini_cgs,emdini_gcm1
  implicit none
!
  integer, intent(in) :: nlines
  real(8) :: rho_0, pre_0, facrho, facpre, fac2, gg, cc, ss, mb
  integer :: ii, iphase
  real(8) :: dlogrho, rhoteos, preteos, qteos, hh, pre, rho, ene
!
  mb = 1.66d-24

  open(850,file='peos_parameter.dat',status='old')
!
  read(850,'(8x,1i5,es13.5)') nphase, rhoini_cgs
  read(850,'(2es13.5)') rho_0, pre_0
  do ii = nphase, 0, -1
    read(850,'(2es13.5)') rhocgs(ii), abi(ii)
  end do
!
  close(850)
!
! --  cgs to g = c = msol = 1 unit.
! --  assume pre = pre_0 dyn/cm^2 at rho = rho_0 gr/cm^3.
! --  typically pre_0 = 1.0d+37 dyn/cm^2 
! --  and       rho_0 = 1.0d+16  gr/cm^3.
! --  rescale interface values
!
  facrho = (g/c**2)**3*solmas**2
  facpre = g**3*solmas**2/c**8
!
  do ii = 0, nphase
    rhoi(ii) = facrho*rhocgs(ii)
  end do
!
  call peos_lookup(rho_0,rhocgs,iphase)
!    
  abc(iphase) = pre_0/rho_0**abi(iphase)
  abc(iphase) = facpre/facrho**abi(iphase)*abc(iphase)
  abccgs(iphase) = pre_0/(rho_0**abi(iphase))
!
  if (iphase.gt.0) then
    do ii = iphase-1, 0, -1
      abc(   ii) = rhoi(  ii)**(abi(ii+1)-abi(ii))*abc(   ii+1)
      abccgs(ii) = rhocgs(ii)**(abi(ii+1)-abi(ii))*abccgs(ii+1)
    end do
  end if
  if (iphase.lt.nphase) then
    do ii = iphase+1, nphase
      abc(   ii) = rhoi(  ii-1)**(abi(ii-1)-abi(ii))*abc(   ii-1)
      abccgs(ii) = rhocgs(ii-1)**(abi(ii-1)-abi(ii))*abccgs(ii-1)
    end do
  end if
!
  do ii = 0, nphase
    qi(ii) = abc(ii)*rhoi(ii)**(abi(ii)-1.0d0)
  end do
!
  hi(0) = 1.0d0
  do ii = 1, nphase
    fac2 = abi(ii)/(abi(ii) - 1.0d0)
    hi(ii) = hi(ii-1) + fac2*(qi(ii) - qi(ii-1))
  end do
!
  open(860,file='peos_parameter_output.dat',status='unknown')
  write(860,'(a1,8x,i5)')'#', nphase
  do ii = 0, nphase
    write(860,'(i5,10es13.5)') ii, abc(ii), abi(ii), rhoi(ii), &
    &                           qi(ii), hi(ii), abccgs(ii), rhocgs(ii), &
    &                           abccgs(ii)*rhocgs(ii)**abi(ii)
  end do
  close(860)
!
  rhoini_gcm1 = facrho*rhoini_cgs
  call peos_lookup(rhoini_gcm1,rhoi,iphase)
  emdini_gcm1 = abc(iphase)*rhoini_gcm1**(abi(iphase)-1.0d0)
!
!
! Check for a certain baryon number density 
!
!  rhoteos = mb*3.469614697607567d+40
!  call peos_lookup(rhoteos,rhocgs,iphase)
!  preteos = abccgs(iphase)*rhoteos**abi(iphase)
!  qteos   = preteos/rhoteos/(c**2)
!  call peos_q2hprho(qteos, hh, pre, rho, ene)
!  ene = ene/facrho
!  rho = rho/facrho
!  pre = pre/facpre
!  write(6,'(1p,7e23.15)')  ene, pre, dlog(hh)*c**2, rho/mb
!stop
!
!  write(6,*) "rhocgs(nphase)=", rhocgs(nphase), "     nlines=", nlines
  dlogrho = dlog10(rhocgs(nphase))/dble(nlines)
!  write(6,*)  "dlogrho=", dlogrho
  open(850,file='teos_parameter.dat',status='unknown')
  do ii=0,nlines-1
    rhoteos = (10.0d0)**(dble(ii)*dlogrho)
    call peos_lookup(rhoteos,rhocgs,iphase)
    preteos = abccgs(iphase)*rhoteos**abi(iphase)
    qteos   = preteos/rhoteos/(c**2)
    call peos_q2hprho(qteos, hh, pre, rho, ene)
    ene = ene/facrho   
    rho = rho/facrho   
    pre = pre/facpre   

    write(850,'(7e23.15)')  ene, pre, hh, rho
!    rhoi(ii) = rhocgs(ii)*facrho
!    prei(ii) = precgs(ii)*facpre
!    qi(ii)   = prei(ii)/rhoi(ii)
  end do
  close(850)

end subroutine peos2teos
