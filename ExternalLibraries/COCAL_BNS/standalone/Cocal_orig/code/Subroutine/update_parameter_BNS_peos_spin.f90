subroutine update_parameter_BNS_peos_spin(convf)
  use phys_constant, only  : long
  use grid_parameter, only : nrg, ntg, npg, nrf_deform, nrf, ntgxy, npgxzm
  use def_metric, only : psi, alph, bvxd, bvyd, bvzd, tfkij, tfkijkij
  use def_matter_parameter
  use def_velocity_rot
  use def_velocity_potential
  use def_matter
  use coordinate_grav_r, only : rg
  use trigonometry_grav_theta, only : sinthg, costhg
  use trigonometry_grav_phi, only   : sinphig, cosphig
  use def_vector_phi, only : vec_phig
  use interface_minv
  use interface_flgrad_4th_gridpoint
  implicit none
  real(long), intent(in) :: convf
  real(long) ::    sgg(1:4), gg(1:4,1:4)
  real(long) ::    ain, amid, aout, pin, pmid, pout
! ain is log(\alpha^((1/R_i)^2)) (in). R_in is in fact the previous R.
  real(long) :: a2ppin,  a2p4pin,  pm4in,  ppin,  p4pin,  bxin,  byin,  bzin
  real(long) :: a2ppmid, a2p4pmid, pm4mid, ppmid, p4pmid, bxmid, bymid, bzmid  
  real(long) :: a2ppout, a2p4pout, pm4out, ppout, p4pout, bxout, byout, bzout 
  real(long) :: dxvepin,  dyvepin,  dzvepin,  wxin,  wyin,  wzin
  real(long) :: dxvepmid, dyvepmid, dzvepmid, wxmid, wymid, wzmid
  real(long) :: dxvepout, dyvepout, dzvepout, wxout, wyout, wzout
  real(long) :: ovin, ovmid, ovout, lamin, lammid, lamout, lam2in, lam2mid, lam2out
  real(long) :: vphidvepin, vphidvepmid, vphidvepout
  real(long) :: dvep2in,  wdvepin,  w2in,  term1in,  term2in,  term3in,  term4in,  term5in,  term6in
  real(long) :: dvep2mid, wdvepmid, w2mid, term1mid, term2mid, term3mid, term4mid, term5mid, term6mid
  real(long) :: dvep2out, wdvepout, w2out, term1out, term2out, term3out, term4out, term5out, term6out
  real(long) :: vphiyin, vphiymid, vphiyout
  real(long) :: loghc
  real(long) :: radiold, berold, omeold
  real(long) :: ddradi, ddber, ddome
  real(long) :: facfac, numero, error, hc, pre, rho, ene
  integer    :: nin
  integer    :: irin, itin, ipin, irmid, itmid, ipmid, irout, itout, ipout
!##############################################
  real(long) ::    ut, hh, emdtest
!##############################################
  nin = nrf_deform
!
  sgg = 0.0d0
  gg  = 0.0d0
!
  irin = nrf;   itin = ntgxy;   ipin = 0;
  irmid= 0  ;   itmid= 0    ;   ipmid= 0;
  irout= nrf;   itout= ntgxy;   ipout= npgxzm;

  call peos_q2hprho(emdc, hc, pre, rho, ene)
  loghc = dlog(hc)

  vphiyin  = vec_phig(irin,  itin,  ipin,  2)
  vphiymid = vec_phig(irmid, itmid, ipmid, 2)
  vphiyout = vec_phig(irout, itout, ipout, 2)

  omeold = ome
  berold = ber
  radiold = radi

!  write(6,'(1p,6e12.4)') ome, ber, radi, vphiyin, vphiymid, vphiyout

  numero = 1
! ################################################################
  ain     = dlog(alph(irin,itin,ipin)**(1.d0/radi**2))
  pin     = dlog( psi(irin,itin,ipin)**(1.d0/radi**2))
  a2ppin  = ( alph(irin,itin,ipin)**2 * psi(irin,itin,ipin)**(confpow)               )**(1.d0/radi**2)
  a2p4pin = ( alph(irin,itin,ipin)**2 * psi(irin,itin,ipin)**(4.0d0 + 2.0d0*confpow) )**(1.d0/radi**2)
  pm4in   = ( psi(irin,itin,ipin)**(-4)                                              )**(1.d0/radi**2)
  ppin    = ( psi(irin,itin,ipin)**(confpow)                                         )**(1.d0/radi**2)
  p4pin   = ( psi(irin,itin,ipin)**(4.0d0 + 2.0d0*confpow)                           )**(1.d0/radi**2)
  bxin    = bvxd(irin,itin,ipin)
  byin    = bvyd(irin,itin,ipin)
  bzin    = bvzd(irin,itin,ipin)
!
!  write(6,*)  ain, pin, confpow, a2ppin

  amid     = dlog(alph(irmid,itmid,ipmid)**(1.d0/radi**2))
  pmid     = dlog( psi(irmid,itmid,ipmid)**(1.d0/radi**2))
  a2ppmid  = ( alph(irmid,itmid,ipmid)**2 * psi(irmid,itmid,ipmid)**(confpow)               )**(1.d0/radi**2)
  a2p4pmid = ( alph(irmid,itmid,ipmid)**2 * psi(irmid,itmid,ipmid)**(4.0d0 + 2.0d0*confpow) )**(1.d0/radi**2)
  pm4mid   = ( psi(irmid,itmid,ipmid)**(-4)                                                 )**(1.d0/radi**2)
  ppmid    = ( psi(irmid,itmid,ipmid)**(confpow)                                            )**(1.d0/radi**2)
  p4pmid   = ( psi(irmid,itmid,ipmid)**(4.0d0 + 2.0d0*confpow)                              )**(1.d0/radi**2)
  bxmid    = bvxd(irmid,itmid,ipmid)
  bymid    = bvyd(irmid,itmid,ipmid)
  bzmid    = bvzd(irmid,itmid,ipmid)
!
  aout     = dlog(alph(irout,itout,ipout)**(1.d0/radi**2))
  pout     = dlog( psi(irout,itout,ipout)**(1.d0/radi**2))
  a2ppout  = ( alph(irout,itout,ipout)**2 * psi(irout,itout,ipout)**(confpow)               )**(1.d0/radi**2)
  a2p4pout = ( alph(irout,itout,ipout)**2 * psi(irout,itout,ipout)**(4.0d0 + 2.0d0*confpow) )**(1.d0/radi**2)
  pm4out   = ( psi(irout,itout,ipout)**(-4)                                                 )**(1.d0/radi**2)
  ppout    = ( psi(irout,itout,ipout)**(confpow)                                            )**(1.d0/radi**2)
  p4pout   = ( psi(irout,itout,ipout)**(4.0d0 + 2.0d0*confpow)                              )**(1.d0/radi**2)
  bxout    = bvxd(irout,itout,ipout)
  byout    = bvyd(irout,itout,ipout)
  bzout    = bvzd(irout,itout,ipout)

! write (6,*) "test values"
! write (6,'(1p,3e12.4)') ome, ber, radi
! write (6,'(1p,3e12.4)') psi(irin,itin,ipin) ,psi(irmid,itmid,ipmid) ,psi(irout,itout,ipout)
! write (6,'(1p,3e12.4)') alph(irin,itin,ipin),alph(irmid,itmid,ipmid),alph(irout,itout,ipout)
! write (6,'(1p,3e12.4)') error
! write (6,'(1p,3e12.4)') pain, pamid, paout
!  write(6,'(a14,f10.7,a19,f10.7,a12,f10.7,a7,f10.7,a6)') &
!  &   "ff=-Log[ber]+(",ain,")*R*R+0.5*Log[1.0-(",pain,")^(2*R*R)*((",bin,")+ome*(",vphiyin,"))^2];"
!  write(6,'(a3,f10.7,a11,f10.7,a19,f10.7,a12,f10.7,a7,f10.7,a6)') "gg=",loghc,    &
!  &   "-Log[ber]+(",amid,")*R*R+0.5*Log[1.0-(",pamid,")^(2*R*R)*((",bmid,")+ome*(",vphiymid,"))^2];"
!  write(6,'(a14,f10.7,a19,f10.7,a12,f10.7,a7,f10.7,a6)') &
!  &   "hh=-Log[ber]+(",aout,")*R*R+0.5*Log[1.0-(",paout,")^(2*R*R)*((",bout,")+ome*(",vphiyout,"))^2];"
!  write(6,'(a7,f10.7,a7,f10.7,a5,f10.7,a2)') ",{{ome,",ome,"},{ber,",ber,"},{R,",radi,"}}"
! ################################################################
  do
    dxvepin = vepxf(irin,itin,ipin)
    dyvepin = vepyf(irin,itin,ipin)
    dzvepin = vepzf(irin,itin,ipin)
   
    wxin    = wxspf(irin,itin,ipin)
    wyin    = wyspf(irin,itin,ipin)
    wzin    = wzspf(irin,itin,ipin)

    dxvepmid = vepxf(irmid,itmid,ipmid)
    dyvepmid = vepyf(irmid,itmid,ipmid)
    dzvepmid = vepzf(irmid,itmid,ipmid)

    wxmid    = wxspf(irmid,itmid,ipmid)
    wymid    = wyspf(irmid,itmid,ipmid)
    wzmid    = wzspf(irmid,itmid,ipmid)

    dxvepout = vepxf(irout,itout,ipout)
    dyvepout = vepyf(irout,itout,ipout)
    dzvepout = vepzf(irout,itout,ipout)

    wxout    = wxspf(irout,itout,ipout)
    wyout    = wyspf(irout,itout,ipout)
    wzout    = wzspf(irout,itout,ipout)

    ovin  = byin  + ome*vphiyin
    ovmid = bymid + ome*vphiymid
    ovout = byout + ome*vphiyout

!    lamin  = ber + (bxin +0)*dxvepin  +  ovin*dyvepin  + (bzin +0)*dzvepin
!    lammid = ber + (bxmid+0)*dxvepmid + ovmid*dyvepmid + (bzmid+0)*dzvepmid
!    lamout = ber + (bxout+0)*dxvepout + ovout*dyvepout + (bzout+0)*dzvepout

    lamin  = ber + ovin*dyvepin 
    lammid = ber + ovmid*dyvepmid 
    lamout = ber + ovout*dyvepout

    lam2in  = lamin*lamin
    lam2mid = lammid*lammid
    lam2out = lamout*lamout
 
    vphidvepin  =  vphiyin*dyvepin
    vphidvepmid = vphiymid*dyvepmid
    vphidvepout = vphiyout*dyvepout

!    write(6,*)  vphiyin, dxvepin, dyvepin, dzvepin

    dvep2in = (dxvepin**2 + dyvepin**2 + dzvepin**2)*pm4in**(radi**2)

    wdvepin = (wxin*dxvepin + wyin*dyvepin + wzin*dzvepin)*ppin**(radi**2)

    w2in    = (wxin*wxin + wyin*wyin + wzin*wzin)*p4pin**(radi**2)

    term1in = (wxin*dxvepin + wyin*dyvepin + wzin*dzvepin) * a2ppin**(radi**2) + &
            & (wxin*wxin + wyin*wyin + wzin*wzin) * a2p4pin**(radi**2)

    term2in = dvep2in + 2.0d0*wdvepin + w2in

    term3in = 0.25d0 + term1in/lam2in

    term4in = 1.0d0 + term2in/1.0d0

    dvep2mid = (dxvepmid**2 + dyvepmid**2 + dzvepmid**2)*pm4mid**(radi**2)

    wdvepmid = (wxmid*dxvepmid + wymid*dyvepmid + wzmid*dzvepmid)*ppmid**(radi**2)

    w2mid    = (wxmid*wxmid + wymid*wymid + wzmid*wzmid)*p4pmid**(radi**2)

    term1mid = (wxmid*dxvepmid + wymid*dyvepmid + wzmid*dzvepmid) * a2ppmid**(radi**2) + &
            & (wxmid*wxmid + wymid*wymid + wzmid*wzmid) * a2p4pmid**(radi**2)

    term2mid = dvep2mid + 2.0d0*wdvepmid + w2mid

    term3mid = 0.25d0 + term1mid/lam2mid

    term4mid = 1.0d0 + term2mid/hc/hc

    dvep2out = (dxvepout**2 + dyvepout**2 + dzvepout**2)*pm4out**(radi**2)

    wdvepout = (wxout*dxvepout + wyout*dyvepout + wzout*dzvepout)*ppout**(radi**2)

    w2out    = (wxout*wxout + wyout*wyout + wzout*wzout)*p4pout**(radi**2)

    term1out = (wxout*dxvepout + wyout*dyvepout + wzout*dzvepout) * a2ppout**(radi**2) + &
            & (wxout*wxout + wyout*wyout + wzout*wzout) * a2p4pout**(radi**2)

    term2out = dvep2out + 2.0d0*wdvepout + w2out

    term3out = 0.25d0 + term1out/lam2out

    term4out = 1.0d0 + term2out/1.0d0
!
    if(lamin<0 .or. lamout<0 .or. lammid<0) then
      write(6,*)  "Quantities lam inside log negative. Exiting..."
      stop
    end if
    if(term3in<0 .or. term3out<0 .or. term3mid<0) then
      write(6,*)  "Quantities inside sqrt negative. Exiting..."
      stop
    end if
    if(term4in<0 .or. term4out<0 .or. term4mid<0) then
      write(6,*)  "Quantities inside log negative. Exiting..."
      stop
    else
      sgg(1) = -( -dlog(lamin)  + radi**2*ain  - dlog(0.5d0+sqrt(term3in))  + &
             &     0.5d0*dlog(term4in))

      sgg(2) = -( -dlog(lamout) + radi**2*aout - dlog(0.5d0+sqrt(term3out)) + &
             &     0.5d0*dlog(term4out))

      sgg(3) = -( -dlog(lammid) + radi**2*amid - dlog(0.5d0+sqrt(term3mid)) + &
                   0.5d0*dlog(term4mid) + loghc)
    end if
!
    term5in  =  a2ppin**(radi**2)*2.0d0*radi*dlog(a2ppin) *         &
             &  (wxin*dxvepin + wyin*dyvepin + wzin*dzvepin) +      &
             &  a2p4pin**(radi**2)*2.0d0*radi*dlog(a2p4pin)*        &
             &  (wxin*wxin + wyin*wyin + wzin*wzin)

    term6in  = dvep2in*2.0d0*radi*dlog(pm4in) + 2.0d0*wdvepin*2.0d0*radi*dlog(ppin) + &
             & w2in*2.0d0*radi*dlog(p4pin)

    term5mid =  a2ppmid**(radi**2)*2.0d0*radi*dlog(a2ppmid) *             &
             &  (wxmid*dxvepmid + wymid*dyvepmid + wzmid*dzvepmid) +      &
             &  a2p4pmid**(radi**2)*2.0d0*radi*dlog(a2p4pmid)*             &
             &  (wxmid*wxmid + wymid*wymid + wzmid*wzmid)

    term6mid = dvep2mid*2.0d0*radi*dlog(pm4mid) + 2.0d0*wdvepmid*2.0d0*radi*dlog(ppmid) + &
             & w2mid*2.0d0*radi*dlog(p4pmid)

    term5out =  a2ppout**(radi**2)*2.0d0*radi*dlog(a2ppout) *               &
             &  (wxout*dxvepout + wyout*dyvepout + wzout*dzvepout) +         &
             &  a2p4pout**(radi**2)*2.0d0*radi*dlog(a2p4pout)*               &
                (wxout*wxout + wyout*wyout + wzout*wzout)

    term6out = dvep2out*2.0d0*radi*dlog(pm4out) + 2.0d0*wdvepout*2.0d0*radi*dlog(ppout) + &
             & w2out*2.0d0*radi*dlog(p4pout)

!  ain is ln(\alpha)
    gg(1,1) = vphidvepin*(-1.0d0 +      &
            & term1in/(0.5d0+sqrt(term3in))/sqrt(term3in)/lam2in )/lamin

    gg(1,2) = (-1.0d0 + term1in/(0.5d0+sqrt(term3in))/sqrt(term3in)/lam2in)/lamin

    gg(1,3) = 2.0d0*radi*ain - term5in/(0.5d0+sqrt(term3in))/sqrt(term3in)/(2.0d0*lam2in) + &
            & term6in/term4in/(2.0d0*1.0d0)

    gg(2,1) = vphidvepout*(-1.0d0 +     &
            & term1out/(0.5d0+sqrt(term3out))/sqrt(term3out)/lam2out )/lamout

    gg(2,2) = (-1.0d0 + term1out/(0.5d0+sqrt(term3out))/sqrt(term3out)/lam2out)/lamout

    gg(2,3) = 2.0d0*radi*aout - term5out/(0.5d0+sqrt(term3out))/sqrt(term3out)/(2.0d0*lam2out) + &
            & term6out/term4out/(2.0d0*1.0d0)

    gg(3,1) = vphidvepmid*(-1.0d0 +    &
            & term1mid/(0.5d0+sqrt(term3mid))/sqrt(term3mid)/lam2mid )/lammid

    gg(3,2) = (-1.0d0 + term1mid/(0.5d0+sqrt(term3mid))/sqrt(term3mid)/lam2mid)/lammid

    gg(3,3) = 2.0d0*radi*amid - term5mid/(0.5d0+sqrt(term3mid))/sqrt(term3mid)/(2.0d0*lam2mid) + &
            & term6mid/term4mid/(2.0d0*hc*hc)
!
!    test
!if (numero.le.20) then
! write (6,'(1p,8e12.4)') sgg(1), sgg(2), sgg(3), pamid, radi, ov2mid, termmid
! write(6,*) "--------------------------------------------------------"
! write (6,'(1p,4f20.12)') gg(1,1), gg(1,2), gg(1,3), sgg(1)
! write (6,'(1p,4f20.12)') gg(2,1), gg(2,2), gg(2,3), sgg(2)
! write (6,'(1p,4f20.12)') gg(3,1), gg(3,2), gg(3,3), sgg(3)
! write(6,*) "--------------------------------------------------------"
!end if
!stop
!!pause
!    test
    call minv(gg,sgg,3,4)

!    write (6,'(1p,4e12.4)') numero, sgg(1), sgg(2), sgg(3)
!    write(6,*) "Old:", numero, ome, ber, radi

    ddome = sgg(1)
    ddber = sgg(2)
    ddradi = sgg(3)
    facfac = dmin1(dble(numero)/5.0d0,1.0d0)
    ome = ome + ddome*facfac
    ber = ber + ddber*facfac
    radi = radi + ddradi*facfac

!    write(6,*) "New:", ome, ber, radi
    error = dmax1(dabs(ddome/ome),dabs(ddber/ber),dabs(ddradi/radi))
!    numero = numero + 1
!    if (numero<1000) then
!      write(6,*)' numero = ', numero, '   error =',error
!    end if
!      if (iter<10.and.numero>10) exit
    if (numero>1010) exit
!    if (dabs(error)<1.0d-08) exit
    if (dabs(error)<1.0d-12) then
!      write(6,*) "New:", numero, ome, ber, radi
      exit
    end if
    numero = numero + 1
  end do
!    test
! write (6,*) "test values"
! write (6,*) sgg(1), sgg(2), sgg(3)
! write (6,*) ome
!    test
!      write(6,*)' numero = ', numero, '  error = ',error
!
  if (radi < 0.d0) write(6,*) ' ### radi minus ###'
  if (radi < 0.d0) radi = - radi
  if (ome < 0.d0) write(6,*) ' ### ome minus ###'
  if (ome < 0.d0) ome = - ome
  if (ber < 0.d0) write(6,*) ' ### ber minus ###'
  if (ber < 0.d0) ber = - ber
  ome = convf*ome + (1.d0-convf)*omeold
  ber = convf*ber + (1.d0-convf)*berold
  radi = convf*radi + (1.d0-convf)*radiold
!
!
! --  Improving alpha and psi.
!
  alph = alph**((radi/radiold)**2)
  psi = psi**((radi/radiold)**2)
!##############################################
!
!  stop
end subroutine update_parameter_BNS_peos_spin

