c ==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+=
      program pn
c
      implicit real*8(a-h,o-z), integer (i-n)
c      
      character*1 chinput
      character*3 cheos, chcomp
c
c --- Parameters
c
      g = 6.6726d-8
      pi = 3.14159265358979d+0
      pi2=pi*pi
      al2= 0.69314718055994530942d+0
      geu= 0.57721566490153286061d+0
c
c --- for solar mass unit. 
      gmovc3 = 4.9257d-06    
c
      nfmax = 2000
c
      write(6,*)' Corotation ?  type y for yes. '
      read(5,400) chinput
c
      write(6,*)' Input mass of 1BH. '
      read(5,*) gramas
      write(6,100) gramas
      if(chinput.eq.'y') then
        open(2,file='4PN_EandJ_BBH_corot.dat',status='unknown') 
      else
        open(2,file='4PN_EandJ_BBH_irrot.dat',status='unknown')
      end if
 400  format(a1)
 401  format(a3)
c
c --- coefficient and power of each order.
c
      rma = gramas
      rmb = gramas
      totmass = rma + rmb
      redmass = rma*rmb/(rma + rmb)
      rnu     = redmass/totmass
      rlambda = - 1987.0d0/3080.0d0
c
      tonE =   1.0d0
      fstE = - 3.0d0/4.0d0  - 1.0d0/12.0d0*rnu
      sndE = - 27.0d0/8.0d0 + 19.0d0/8.0d0*rnu - 1.0d0/24.0d0*rnu**2
      trdE = - 675.0d0/64.0d0 
     &       +(34445.0d0/576.0d0 - 205.0d0/96.0d0*pi**2)*rnu
     &       - 155.0d0/96.0d0*rnu**2
     &       - 35.0d0/5184.0d0*rnu**3
      forE = - 3969.0d0/128.0d0 + ( -123671.0d0/5760.0d0
     &       + 9037.0d0/1536.0d0*pi2
     &       + 1792.0d0/15.0d0*al2
     &       + 896.0d0/15.0d0*geu )*rnu 
     &       + (-498449.0d0/3456.0d0+3157.0d0/576.0d0*pi2)*rnu**2
     &       + 301.0d0/1728.0d0*rnu**3
     &       + 77.0d0/31104.0d0*rnu**4
c
      spinE1 =   2.0d0 - 6.0d0*rnu
      spinE2 = -10.0d0*rnu + 25.0d0*rnu**2     ! corrected
!      spinE2 = - 18.0d0/3.0d0*rnu + 13.0d0*rnu**2
      if (chinput.ne.'y') then
        spinE1 = 0.0
        spinE2 = 0.0
      end if
c
      tonJ =   1.0d0
      fstJ =   3.0d0/2.0d0  + 1.0d0/6.0d0*rnu
      sndJ =   27.0d0/8.0d0 - 19.0d0/8.0d0*rnu + 1.0d0/24.0d0*rnu**2
      trdJ =   135.0d0/16.0d0 
     &     +( -6889.0d0/144.0d0 + 41.0d0/24.0d0*pi**2)*rnu
     &     + 31.0d0/24.0d0*rnu**2
     &     + 7.0d0/1296.0d0*rnu**3
      forJ = 2835.0d0/128.0d0 + (98869.0d0/5760.0d0 
     &     - 6455.0d0/1536.0d0*pi2-256.0d0/3.0d0*al2
     &     - 128.0d0/3.0d0*geu)*rnu + (356035.0d0/3456.0d0
     &     - 2255.0d0/576.0d0*pi2)*rnu**2
     &     - 215.0d0/1728.0d0*rnu**3
     &     - 55.0d0/31104.0d0*rnu**4
c
      spinJ1 = 2.0d0*(2.0d0 - 6.0d0*rnu)
      spinJ2 = -16.0d0*rnu + 40.0d0*rnu**2   !  corrected
!      spinJ2 = 8.0d0/5.0d0*(- 18.0d0/3.0d0*rnu + 13.0d0*rnu**2)
      if (chinput.ne.'y') then
        spinJ1 = 0.0
        spinJ2 = 0.0
      end if
c
      pton = 2.0d0/3.0d0
      pfst = 4.0d0/3.0d0
      psnd = 6.0d0/3.0d0
      ptrd = 8.0d0/3.0d0
      pfor = 10.0d0/3.0d0

      pspin1 = 6.0d0/3.0d0
      pspin2 = 8.0d0/3.0d0
c
      do 10 ii = 1, nfmax
c
c      fgw = dble(ii)
c      omeM = 2.0d0*pi*1.35d0*gmovc3*fgw
      omeM = 0.005d0 + (0.12d0-0.005d0)*dble(ii)/dble(nfmax)
c
      bindEovm = - 0.5d0*rnu*(tonE*omeM**pton + fstE*omeM**pfst
     &                      + sndE*omeM**psnd + trdE*omeM**ptrd
     & +(forE + 2.0d0/3.0d0*448.0d0/15.0d0*rnu*dlog(omeM))*omeM**pfor)
     &         + spinE1*omeM**pspin1
     &         + spinE2*omeM**pspin2
      bindE = bindEovm*totmass
c
      angmomovm2 =  rnu/omeM*(tonJ*omeM**pton + fstJ*omeM**pfst
     &                      + sndJ*omeM**psnd + trdJ*omeM**ptrd
     & +(forJ - 2.0d0/3.0d0*64.0d0/3.0d0*rnu*dlog(omeM))*omeM**pfor)
     &           + spinJ1*omeM**pspin1/omeM
     &           + spinJ2*omeM**pspin2/omeM
      angmom = angmomovm2*totmass**2

c      if(ii==nfmax) then
c        write(6,100) rnu*tonJ,rnu*fstJ,rnu*sndJ,rnu*trdJ,rnu*forJ
c      end if
c
c      write(2,100) fgw, omeM, bindEovm, bindE, bindE + totmass,
c     & ome**(2.0/3.0), (bindE + totmass)/2.0, angmomovm2, angmom
      write(2,100) omeM, bindEovm, bindE + totmass, angmomovm2, angmom
c
   10 continue
   80 continue
c
c  100 format(1p,18e16.8)
  100 format(1p,18e23.15)
c
      end
