subroutine update_parameter_BNS_peos(convf)
  use phys_constant, only  : long
  use grid_parameter, only : nrg, ntg, npg, nrf_deform, nrf, ntgxy, npgxzm
  use def_metric, only : psi, alph, bvxd, bvyd, bvzd, tfkij, tfkijkij
  use def_matter_parameter
  use coordinate_grav_r, only : rg
  use trigonometry_grav_theta, only : sinthg, costhg
  use trigonometry_grav_phi, only   : sinphig, cosphig
  use def_vector_phi, only : vec_phig
  use interface_minv
  implicit none
  real(long), intent(in) :: convf
  real(long)     ::    sgg(1:4), gg(1:4,1:4)
  real(long)     ::    bin, bmid, bout
! "bin" is beta(in) and so on.
  real(long)     ::    ain, amid, aout
! ain is log(\alpha^((1/R_i)^2)) (in). R_in is in fact the previous R.
  real(long)     ::    pain, pamid, paout
! pain = (\phi^2/\alpha)^((1/R_i)^2) (in).
  real(long)     ::    ovin, ovmid, ovout
! ovin is \omega(in). \omega = \beta + \Omega \phi.
  real(long)     ::    ov2in, ov2mid, ov2out
! "ov2in" is f_{ab} \omega^a \omega^b.
  real(long)     ::    termin, termmid, termout
  real(long)     ::    dtermdoin, dtermdomid, dtermdoout
  real(long)     ::    dtermdrin, dtermdrmid, dtermdrout
  real(long)     ::    vphiyin, vphiymid, vphiyout
  real(long)     ::    loghc
  real(long)     ::    radiold, berold, omeold
  real(long)     ::    ddradi, ddber, ddome
  real(long)     ::    facfac, numero, error, hc, pre, rho, ene
  integer        ::    nin
  integer        ::    irin, itin, ipin, irmid, itmid, ipmid, irout, itout, ipout
!##############################################
  real(long)     ::    ut, hh, emdtest
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
!  vphiyin  = vec_phig(nin,0,0,2)
!  vphiymid = vec_phig(0,0,0,2)
!  vphiyout = vec_phig(nrf,ntgxy,0,2)

  vphiyin  = vec_phig(irin,  itin,  ipin,  2)
  vphiymid = vec_phig(irmid, itmid, ipmid, 2)
  vphiyout = vec_phig(irout, itout, ipout, 2)

  omeold = ome
  berold = ber
  radiold = radi

!  write(6,'(1p,6e12.4)') ome, ber, radi, vphiyin, vphiymid, vphiyout

  numero = 1
! ################################################################
  ain  = dlog(alph(irin,itin,ipin)**(1.d0/radi**2))
  pain = (psi(irin,itin,ipin)**2/alph(irin,itin,ipin))**(1.d0/radi**2)
  bin  = bvyd(irin,itin,ipin)
!
  amid = dlog(alph(irmid,itmid,ipmid)**(1.d0/radi**2))
  pamid= (psi(irmid,itmid,ipmid)**2/alph(irmid,itmid,ipmid))**(1.d0/radi**2)
  bmid = bvyd(irmid,itmid,ipmid)
!
  aout = dlog(alph(irout,itout,ipout)**(1.d0/radi**2))
  paout= (psi(irout,itout,ipout)**2/alph(irout,itout,ipout))**(1.d0/radi**2)
  bout = bvyd(irout,itout,ipout)

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
    ovin  = bin  + ome*vphiyin
    ovmid = bmid + ome*vphiymid
    ovout = bout + ome*vphiyout
! This is in fact only the \omega^y component.
! Since only \phi^y is not 0. (We are at x axis.)
! This is also the reason why I have those bvxd down there.
!      ov2in  = ovin**2 +bvxd(nin,0,0)**2+bvzd(nin,0,0)**2
!      ov2mid = ovmid**2+bvxd(0,0,0)**2  +bvzd(0,0,0)**2
!      ov2out = ovout**2+bvxd(nrf,ntgxy,0)**2+bvzd(nrf,ntgxy,0)**2
    ov2in  = ovin**2
    ov2mid = ovmid**2
    ov2out = ovout**2
    termin  = 1.0d0 - pain**( 2.d0*radi**2)*ov2in
    termmid = 1.0d0 - pamid**(2.d0*radi**2)*ov2mid
    termout = 1.0d0 - paout**(2.d0*radi**2)*ov2out
! termin is 1-(\phi^4/\alpha^2)^((R_0/R_i)^2) \omega^2
    dtermdoin = - pain**(2.d0*radi**2)*2.0d0*ovin*vphiyin
    dtermdomid= - pamid**(2.d0*radi**2)*2.0d0*ovmid*vphiymid
    dtermdoout= - paout**(2.d0*radi**2)*2.0d0*ovout*vphiyout
    dtermdrin =-dlog(pain)*4.d0*radi*pain**(2.d0*radi**2)*ov2in
    dtermdrmid=-dlog(pamid)*4.d0*radi*pamid**(2.d0*radi**2)*ov2mid
    dtermdrout=-dlog(paout)*4.d0*radi*paout**(2.d0*radi**2)*ov2out
!
    if(termin<0 .or. termmid<0 .or. termout<0) then
      write(6,*)  "Quantities inside log negative. Exiting..."
      stop
    else
      sgg(1) = -(radi**2*ain  + 0.5d0*dlog(termin)  - dlog(ber))
      sgg(2) = -(radi**2*aout + 0.5d0*dlog(termout) - dlog(ber))
      sgg(3) = -(radi**2*amid + 0.5d0*dlog(termmid) - dlog(ber) + loghc)
    end if
!
!  ain is ln(\alpha)
    gg(1,1) =   0.5d0*dtermdoin/termin
    gg(1,2) = - 1.0d0/ber
    gg(1,3) = 2.0d0*radi*ain + 0.5d0*dtermdrin/termin
!
    gg(2,1) =   0.5d0*dtermdoout/termout
    gg(2,2) = - 1.0d0/ber
    gg(2,3) = 2.0d0*radi*aout + 0.5d0*dtermdrout/termout
!
    gg(3,1) =   0.5d0*dtermdomid/termmid
    gg(3,2) = - 1.0d0/ber
    gg(3,3) = 2.0d0*radi*amid + 0.5d0*dtermdrmid/termmid
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

! write(6,*) "--------------------------------------------------------"
! write (6,'(1p,4f20.12)') gg(1,1), gg(1,2), gg(1,3), sgg(1)
! write (6,'(1p,4f20.12)') gg(2,1), gg(2,2), gg(2,3), sgg(2)
! write (6,'(1p,4f20.12)') gg(3,1), gg(3,2), gg(3,3), sgg(3)
! write(6,*) "--------------------------------------------------------"

!    write (6,'(1p,4e12.4)') numero, sgg(1), sgg(2), sgg(3)
!    write(6,*) "Old:", ome, ber, radi


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
    if (dabs(error)<1.0d-12) exit
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
  ut = 1/sqrt(alph(nrf,ntgxy,0)**2 &
     -psi(nrf,ntgxy,0)**4*ov2out)
  hh = ber*ut
  emdtest = 1.0d0/(pinx+1.0d0)*(hh-1.0d0)
!!write (6,*) "h  = ", hh
!
!  stop
end subroutine update_parameter_BNS_peos

