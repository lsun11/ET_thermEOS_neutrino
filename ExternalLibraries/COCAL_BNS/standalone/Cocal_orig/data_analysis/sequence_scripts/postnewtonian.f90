program postnewtonian
  implicit none
  real(8), parameter :: g = 6.6726d-8
  real(8), parameter :: pi = 3.14159265358979d+0
  real(8), parameter :: al2 = 0.69314718055994530942d+0
  real(8), parameter :: geu = 0.57721566490153286061d+0

  real(8) :: pi2, rnu, omeM, xx, jpower, rma, rmb, gmovc3, term1, term2
  real(8) :: totmass, redmass, bindEovm, bindE, angmomovm2, angmom
  real(8) :: ea4(5), eb4(5), ja4(5), jb4(5)     !  4PN
  real(8) :: ea4cor(5), ja4cor(5)               !  corotating 3PN
  real(8) :: Ebomcor, Jom2cor
  integer :: i,j,k,ii,nfmax,iact
  real(8) :: dmass, del, sux,suy,suz, sigux,siguy,siguz
  real(8) :: Ebomso, Jom2so, Ebomss, Jom2ss 
  real(8) :: sa(3), sb(3), ux(3), uy(3), uz(3), Stot(3), Sigma(3)              
  real(8) :: chia(3), chib(3), chit(3), chid(3), chit2, chid2, chitd
  real(8) :: chitux, chituy, chituz, chidux, chiduy, chiduz
  real(8) :: chia2, chib2, chiab, chiauz, chibuz
  real(8) :: e32so, e52so, e72so
  real(8) :: jx32so, jx52so, jx72so, jy32so, jy52so, jy72so, jz32so, jz52so, jz72so
  real(8) :: e2ss
  real(8) :: spfit, Slom2

  ea4=0.0d0; eb4=0.0d0; ja4=0.0d0; jb4=0.0d0; ea4cor=0.0d0; ja4cor=0.0d0
  sa=0.0d0; sb=0.0d0; ux=0.0d0; uy=0.0d0; uz=0.0d0; Stot=0.0d0; Sigma=0.0d0
  chia=0.0d0; chib=0.0d0; chit=0.0d0; chid=0.0d0 

  pi2=pi*pi
  gmovc3 = 4.9257d-06
  nfmax = 2000

  ux(1)=1.0d0; ux(2)=0.0d0; ux(3)=0.0d0 
  uy(1)=0.0d0; uy(2)=1.0d0; uy(3)=0.0d0 
  uz(1)=0.0d0; uz(2)=0.0d0; uz(3)=1.0d0 
 
  write(6,*)  "1) Irrotational."
  write(6,*)  "2) Corotating."
  write(6,*)  "3) Spinning (constant)."
  write(6,*)  "4) Spinning (varying)."
  write(6,'(a11)',advance='no') "Choose 1-4:"
  read (*,'(i5)') iact
  if (iact.ne.1 .and. iact.ne.2 .and. iact.ne.3 .and. iact.ne.4)   stop
  if(iact.eq.1) then
    open(2,file='4PN_EandJ_irrot.dat',status='unknown')
  else if(iact.eq.2)  then
    open(2,file='4PN_EandJ_corot.dat',status='unknown')
  else
    open(2,file='4PN_EandJ_spin.dat',status='unknown')
  end if

  write(6,*)' Input mass of 1BH. '
  read(*,*) rma
  write(6,*)' Input mass of 2BH. '
  read(*,*) rmb
  write(6,'(1p,2e23.15)')  rma, rmb

  totmass = rma + rmb
  redmass = rma*rmb/(rma + rmb)
  rnu     = redmass/totmass
  dmass   = rma - rmb                        !******************************************
  del     = dmass/totmass

  if(iact==2) then
    ea4cor(3) = 2.0d0-6.0d0*rnu             ! x**3
    ea4cor(4) = -10.0d0*rnu+25.0d0*rnu**2   ! x**4
  end if

  if(iact==3) then
    write(6,*)' Input spin components S_1, of 1BH separate by space, ex: 1.5 2.0 -1.0 '
    read(*,*) sa(1), sa(2), sa(3)
    write(6,*)' Input spin components S_2, of 2BH separate by space, ex: 1.5 2.0 -1.0 '
    read(*,*) sb(1), sb(2), sb(3)
    write(6,'(a6,1p,3e23.15)')  "Spin1:", sa(1), sa(2), sa(3)
    write(6,'(a6,1p,3e23.15)')  "Spin2:", sb(1), sb(2), sb(3)

    do i=1,3 
      Stot(i)=sa(i)+sb(i)
      Sigma(i)=totmass*(sb(i)/rmb - sa(i)/rma)
      chia(i) = sa(i)/rma/rma
      chib(i) = sb(i)/rmb/rmb
      chit(i) = 0.50d0*(chia(i) + chib(i))
      chid(i) = 0.50d0*(chia(i) - chib(i))
    end do
    sux = (Stot(1)*ux(1)+Stot(2)*ux(2)+Stot(3)*ux(3))/totmass/totmass
    suy = (Stot(1)*uy(1)+Stot(2)*uy(2)+Stot(3)*uy(3))/totmass/totmass
    suz = (Stot(1)*uz(1)+Stot(2)*uz(2)+Stot(3)*uz(3))/totmass/totmass

    sigux = (Sigma(1)*ux(1)+Sigma(2)*ux(2)+Sigma(3)*ux(3))/totmass/totmass
    siguy = (Sigma(1)*uy(1)+Sigma(2)*uy(2)+Sigma(3)*uy(3))/totmass/totmass
    siguz = (Sigma(1)*uz(1)+Sigma(2)*uz(2)+Sigma(3)*uz(3))/totmass/totmass

    chia2 = chia(1)*chia(1)+chia(2)*chia(2)+chia(3)*chia(3)
    chib2 = chib(1)*chib(1)+chib(2)*chib(2)+chib(3)*chib(3)
    chiab = chia(1)*chib(1)+chia(2)*chib(2)+chia(3)*chib(3)
    chiauz= chia(1)*uz(1)+chia(2)*uz(2)+chia(3)*uz(3)
    chibuz= chib(1)*uz(1)+chib(2)*uz(2)+chib(3)*uz(3)

    chit2 = chit(1)*chit(1)+chit(2)*chit(2)+chit(3)*chit(3)
    chid2 = chid(1)*chid(1)+chid(2)*chid(2)+chid(3)*chid(3)
    chitd = chit(1)*chid(1)+chit(2)*chid(2)+chit(3)*chid(3)

    chitux= chit(1)*ux(1)+chit(2)*ux(2)+chit(3)*ux(3)
    chituy= chit(1)*uy(1)+chit(2)*uy(2)+chit(3)*uy(3)
    chituz= chit(1)*uz(1)+chit(2)*uz(2)+chit(3)*uz(3)

    chidux= chid(1)*ux(1)+chid(2)*ux(2)+chid(3)*ux(3)
    chiduy= chid(1)*uy(1)+chid(2)*uy(2)+chid(3)*uy(3)
    chiduz= chid(1)*uz(1)+chid(2)*uz(2)+chid(3)*uz(3)
 
    e32so = 14.0d0*suz/3.0d0 + 2.0d0*del*siguz
    e52so = (11.0d0-61.0d0*rnu/9.0d0)*suz + (3.0d0-10.0d0*rnu/3.0d0)*del*siguz
    e72so = (135.0d0/4.0d0-367.0d0*rnu/4.0d0+29.0d0*rnu**2/12.0d0)*suz   &
     &  + (27.0d0/4.0d0-39.0d0*rnu+5.0d0*rnu**2/4.0d0)*del*siguz

    jz32so= -35.0d0*suz/6.0d0 - 5.0d0/2.0d0*del*siguz
    jz52so= (-77.0d0/8.0d0+427.0d0/72.0d0*rnu)*suz + (-21.0d0/8.0d0+35.0d0/12.0d0*rnu)*del*siguz
    jz72so= (-405.0d0/16.0d0+1101.0d0/16.0d0*rnu-29.0d0/16.0d0*rnu**2)*suz   &
     &  + (-81.0d0/16.0d0+117.0d0/4.0d0*rnu-15.0d0/16.0d0*rnu**2)*del*siguz

    jy32so= -3.0d0*suy - del*siguy
    jy52so= (-7.0d0/2.0d0+3.0d0*rnu)*suy + (-1.0d0/2.0d0+4.0d0/3.0d0*rnu)*del*siguy
    jy72so= (-29.0d0/4.0d0+rnu/12.0d0-4.0d0/3.0d0*rnu**2)*suy   &
     &  + (-1.0d0/2.0d0-79.0d0/24.0d0*rnu-2.0d0/3.0d0*rnu**2)*del*siguy

    jx32so= sux/2.0d0 + del*sigux/2.0d0
    jx52so= (11.0d0/8.0d0-19.0d0*rnu/24.0d0)*sux + (11.0d0/8.0d0-5.0d0*rnu/12.0d0)*del*sigux
    jx72so= (61.0d0/16.0d0-1331.0d0*rnu/48.0d0+11.0d0*rnu**2/48.0d0)*sux   &
     &  + (61.0d0/16.0d0-367.0d0*rnu/24.0d0+5.0d0*rnu**2/48.0d0)*del*sigux

    e2ss = rnu*(chiab-3.0d0*chiauz*chibuz)

!   Not sure about the following
!    e2ss = rnu*(chit2-chid2-3.0d0*chituz**2+3.0d0*chiduz**2)    &
!     &   + (0.5d0-rnu)*(chit2+chid2-3.0d0*chituz**2-3.0d0*chiduz**2) &
!     &   + del*(chitd-3.0d0*chituz*chiduz)
  end if

  ea4(1) =   1.0d0
  ea4(2) = - 3.0d0/4.0d0  - 1.0d0/12.0d0*rnu
  ea4(3) = - 27.0d0/8.0d0 + 19.0d0/8.0d0*rnu - 1.0d0/24.0d0*rnu**2
  ea4(4) = - 675.0d0/64.0d0                                         &   
     &      + (34445.0d0/576.0d0 - 205.0d0/96.0d0*pi**2)*rnu         &
     &      - 155.0d0/96.0d0*rnu**2                                  &
     &      - 35.0d0/5184.0d0*rnu**3
  ea4(5) = - 3969.0d0/128.0d0 + ( -123671.0d0/5760.0d0            &
     &      + 9037.0d0/1536.0d0*pi2                                &
     &      + 1792.0d0/15.0d0*al2                                  &
     &      + 896.0d0/15.0d0*geu )*rnu                             &
     &      + (-498449.0d0/3456.0d0+3157.0d0/576.0d0*pi2)*rnu**2   &
     &      + 301.0d0/1728.0d0*rnu**3                              &
     &      + 77.0d0/31104.0d0*rnu**4

  eb4 = 0.0d0
  eb4(5) = 448.0d0/15.0d0*rnu

  do i=1,5  
    ea4(i) = -0.5d0*rnu*ea4(i)
    eb4(i) = -0.5d0*rnu*eb4(i)
  end do

  do ii = 1,nfmax
    omeM = 0.005d0 + (0.12d0-0.005d0)*dble(ii)/dble(nfmax)
    xx = omeM**(2.0d0/3.0d0)

    bindEovm = 0.0d0;  angmomovm2 = 0.0d0
    Ebomcor = 0.0d0; Jom2cor = 0.0d0
    Ebomso = 0.0d0; Jom2so = 0.0d0
    Ebomss = 0.0d0; Jom2ss = 0.0d0
    do i=1,5
      bindEovm = bindEovm + (ea4(i) + eb4(i)*dlog(xx))*xx**i
      term1 = 2.0d0*dble(i)*ea4(i)/(2.0d0*dble(i)-3.0d0)
      term2 = -6.0d0*eb4(i)/(2.0d0*dble(i)-3.0d0)/(2.0d0*dble(i)-3.0d0)
      ja4(i) = term1+term2
      jb4(i) = 2.0d0*dble(i)*eb4(i)/(2.0d0*dble(i)-3.0d0)
      jpower = dble(i)-3.0d0/2.0d0
      angmomovm2 = angmomovm2 + (ja4(i)+jb4(i)*dlog(xx))*xx**jpower
!
!     additional part due to corotation
      if (iact==2) then
        Ebomcor = Ebomcor + ea4cor(i)*xx**i
        ja4cor(i) = 2.0d0*dble(i)*ea4cor(i)/(2.0d0*dble(i)-3.0d0)
        Jom2cor = Jom2cor + ja4cor(i)*xx**jpower
      end if  
    end do
    if(iact==2) then
      bindEovm = bindEovm + Ebomcor
      angmomovm2 = angmomovm2 + Jom2cor
    end if
    if(iact==3) then
!     additional part due to spin-orbit coupling (for J only aligned spins with L)
      Ebomso = e32so*xx**(3.0d0/2.0d0) + e52so*xx**(5.0d0/2.0d0) + e72so*xx**(7.0d0/2.0d0)
      Ebomso = (-0.5d0*rnu*xx)*Ebomso
      bindEovm = bindEovm + Ebomso

!     Spin kinetic energy    
!      bindEovm = bindEovm + 0.5d0*xx**3

      Jom2so = jz32so*xx**(3.0d0/2.0d0) + jz52so*xx**(5.0d0/2.0d0) + jz72so*xx**(7.0d0/2.0d0) 
      Jom2so = Jom2so*rnu*xx**(-0.5d0)
      angmomovm2 = angmomovm2 + Jom2so

!     Angular momentum due to spin kinetic energy
!      angmomovm2 = angmomovm2 + xx**(3.0d0/2.0d0)
!
!     additional part due to spin-spin coupling: change bindEovm in ~5th decimal
!      Ebomss = e2ss*xx**2
!      Ebomss = (-0.5d0*rnu*xx)*Ebomss       
!      bindEovm = bindEovm + Ebomss
    end if
    if(iact==4) then
!     additional part due to spin-orbit coupling (for J only aligned spins with L)
      spfit = 0.05d0 + 1.8544386d0*(xx**(3/2) - 0.0131515d0)      
      Slom2 = spfit/2.0d0
      e32so = 14.0d0/3.0d0*Slom2
      jz32so = -35.0d0/6.0d0*Slom2

      Ebomso = e32so*xx**(3.0d0/2.0d0)
      Ebomso = (-0.5d0*rnu*xx)*Ebomso
      bindEovm = bindEovm + Ebomso

      Jom2so = jz32so*xx**(3.0d0/2.0d0)
      Jom2so = Jom2so*rnu*xx**(-0.5d0)
      angmomovm2 = angmomovm2 + Jom2so

      bindEovm = bindEovm + 0.5d0*xx**3

      write(1,'(1p,10e23.15)')  omeM, Ebomso, 0.5d0*xx**3, bindEovm
    end if

    bindE = bindEovm*totmass
    angmom = angmomovm2*totmass**2

    write(2,'(1p,10e23.15)') omeM, bindEovm, bindE + totmass, angmomovm2, angmom 
  end do

end program postnewtonian


