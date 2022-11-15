subroutine neos_initialize
!
  use phys_constant        !g,c,solmas,nnpeos
  use def_neos_parameter   !abc,abi,rhoi,qi,hi,nphase,rhoini_cgs,emdini_gcm1
  implicit none
!
  real(8) :: rho_0, pre_0, facrho, facpre, fac2, gg, cc, ss
  integer :: ii, iphase, iofile
!
! --  cgs to g = c = msol = 1 unit.
! --  assume pre = pre_0 dyn/cm^2 at rho = rho_0 gr/cm^3.
! --  typically pre_0 = 1.0d+37 dyn/cm^2
! --  and       rho_0 = 1.0d+16  gr/cm^3.
!
  facrho = (g/c**2)**3*solmas**2
  facpre = g**3*solmas**2/c**8

  open(850,file='neos_parameter.dat',status='old')
  nphase=0
  do
   read(850,*,iostat=iofile)  rho_0
   if (iofile > 0)  then
     write(6,*) "Problem reading file neos_parameter.dat...exiting"
     stop
   else if (iofile < 0) THEN
!    nphase is the total number of phases. The total number of points is nphase+1
     nphase = nphase - 1
     write(6,*) "Total number of lines is =", nphase+1
     exit
   else
     nphase = nphase + 1
   end if
  end do
  close(850)

  open(850,file='neos_parameter.dat',status='old')
  do ii=0,nphase
    read(850,*) rhocgs(ii), precgs(ii)
    rhoi(ii) = rhocgs(ii)*facrho
    prei(ii) = precgs(ii)*facpre
    qi(ii)   = prei(ii)/rhoi(ii) 
  end do
  close(850)
!
!
  open(860,file='neos_parameter_output.dat',status='unknown')
  write(860,'(i10)')  nphase
  do ii = 0, nphase
    write(860,'(i10,10es14.6)') ii, rhocgs(ii), precgs(ii), enecgs(ii), &
      &   rhoi(ii), prei(ii), enei(ii), qi(ii), hi(ii)
  end do
  close(860)
!
!  rhoini_gcm1 = facrho*rhoini_cgs
!  emdini_gcm1 = abc(iphase)*rhoini_gcm1**(abi(iphase)-1.0d0)
!
end subroutine neos_initialize
