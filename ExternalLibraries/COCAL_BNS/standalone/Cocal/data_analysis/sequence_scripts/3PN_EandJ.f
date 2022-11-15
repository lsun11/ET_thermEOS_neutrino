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
      open(2,file='3PN_EandJ_BBH.dat',status='unknown') 
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
     &       +(209323.0d0/4032.0d0 - 205.0d0/96.0d0*pi**2
     &       - 110.0d0/9.0d0*rlambda)*rnu
     &       - 155.0d0/96.0d0*rnu**2
     &       - 35.0d0/5184.0d0*rnu**3
c
      spinE1 =   2.0d0 - 6.0d0*rnu
      spinE2 = - 18.0d0/3.0d0*rnu + 13.0d0*rnu**2
      if (chinput.ne.'y') then
        spinE1 = 0.0
        spinE2 = 0.0
      end if
c
      tonJ =   1.0d0
      fstJ =   3.0d0/2.0d0  + 1.0d0/6.0d0*rnu
      sndJ =   27.0d0/8.0d0 - 19.0d0/8.0d0*rnu + 1.0d0/24.0d0*rnu**2
      trdJ =   135.0d0/16.0d0 
     &     +(- 209323.0d0/5040.0d0 + 41.0d0/24.0d0*pi**2
     &       + 88.0d0/9.0d0*rlambda)*rnu
     &       + 31.0d0/24.0d0*rnu**2
     &       + 7.0d0/1296.0d0*rnu**3
c
      spinJ1 = 2.0d0*(2.0d0 - 6.0d0*rnu)
      spinJ2 = 8.0d0/5.0d0*(- 18.0d0/3.0d0*rnu + 13.0d0*rnu**2)
      if (chinput.ne.'y') then
        spinJ1 = 0.0
        spinJ2 = 0.0
      end if
c
      pton = 2.0d0/3.0d0
      pfst = 4.0d0/3.0d0
      psnd = 6.0d0/3.0d0
      ptrd = 8.0d0/3.0d0
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
     &                      + sndE*omeM**psnd + trdE*omeM**ptrd)
     &           + spinE1*omeM**pspin1
     &           + spinE2*omeM**pspin2
      bindE = bindEovm*totmass
c
      angmomovm2 =  rnu/omeM*(tonJ*omeM**pton + fstJ*omeM**pfst
     &                      + sndJ*omeM**psnd + trdJ*omeM**ptrd)
     &           + spinJ1*omeM**pspin1/omeM
     &           + spinJ2*omeM**pspin2/omeM
      angmom = angmomovm2*totmass**2
c
c      write(2,100) fgw, omeM, bindEovm, bindE, bindE + totmass,
c     & ome**(2.0/3.0), (bindE + totmass)/2.0, angmomovm2, angmom
      write(2,100) omeM, bindEovm, bindE + totmass, angmomovm2, angmom
c
   10 continue
   80 continue
c
  100 format(1p,18e16.8)
c
      end
