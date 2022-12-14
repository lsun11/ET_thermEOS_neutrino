subroutine riccitensor_midpoint
  use grid_parameter, only : nrg, ntg, npg
  use def_metric_hij, only : hxxd, hxyd, hxzd, hyyd, hyzd, hzzd, &
  &                          hxxu, hxyu, hxzu, hyyu, hyzu, hzzu
  use def_cristoffel, only : cri
  use def_ricci_tensor, only : rab, rabnl
  use interface_interpo_linear_type0
  use interface_grgrad1g_midpoint
  use interface_dadbscalar_type0
  use interface_dadbscalar_type3
  implicit none
!
  real(8) :: delhab(6), &
     &       r5(5),  th5(5), phi5(5), &
     &       fr5(5),  ft5(5),  fp5(5), fr5x(5), ft5x(5), fp5x(5), &
     &       fr5y(5), ft5y(5), fp5y(5), fr5z(5), ft5z(5), fp5z(5), &
     &       xi(4),  yi1(4),  yi2(4),  yi3(4),  yi4(4), &
     &       yi5(4),  yi6(4),  yi7(4),  yi8(4),  yi9(4), &
     &       grad1(3), grad1x(3), grad1y(3),  grad1z(3), &
     &       dckkx(3),  dckky(3),  dckkz(3), dhudhd(3,3), dhdh(6), &
     &       r6(6), th6(6), phi6(6), &
     &       fr6xx(6), ft6xx(6), fp6xx(6), fr5xx(5), ft5xx(5), &
     &       fr6xy(6), ft6xy(6), fp6xy(6), fr5xy(5), ft5xy(5), &
     &       fr6xz(6), ft6xz(6), fp6xz(6), fr5xz(5), ft5xz(5), &
     &       fr6yy(6), ft6yy(6), fp6yy(6), fr5yy(5), ft5yy(5), &
     &       fr6yz(6), ft6yz(6), fp6yz(6), fr5yz(5), ft5yz(5), &
     &       fr6zz(6), ft6zz(6), fp6zz(6), fr5zz(5), ft5zz(5)
  real(8) :: dhd(3,3,3), dhu(3,3,3),  gamu(3,3)
  real(8) :: d2hxx(3,3), d2hxy(3,3), d2hxz(3,3), &
     &       d2hyy(3,3), d2hyz(3,3), d2hzz(3,3)
  real(8) :: hd2h(6)
  real(8) :: c11, c12, c13, c14, c15, c16, &
  &          c21, c22, c23, c24, c25, c26, &
  &          c31, c32, c33, c34, c35, c36, &
  &          ckkx, ckky, ckkz, &
  &          ckxlclxk, ckxlclyk, ckxlclzk, &
  &          ckylclyk, ckylclzk, ckzlclzk, &
  &          clxxckkl, clxyckkl, clxzckkl, &
  &          clyyckkl, clyzckkl, clzzckkl, &
  &          hhxxu, hhxyu, hhxzu, hhyxu, hhyyu, hhyzu, &
  &          hhzxu, hhzyu, hhzzu
  integer :: ipg, itg, irg, ia, ib, ic, id
!
! --- Compute Ricci tensor & R_ab(nonlinar)   
!     whose value is assigned on the grid points. 
!     Gauge condition D_b h^ab =0 and \tgamma = 0 has been imposed,  
! --- hence, R_ab = -1/2 Lap h_ab + R_ab(nonlinear).
!
  do ipg = 1, npg
    do itg = 1, ntg
      do irg = 1, nrg
!
! --- R_nonlinear
!
        call interpo_linear_type0(hhxxu,hxxu,irg,itg,ipg)
        call interpo_linear_type0(hhxyu,hxyu,irg,itg,ipg)
        call interpo_linear_type0(hhxzu,hxzu,irg,itg,ipg)
        call interpo_linear_type0(hhyyu,hyyu,irg,itg,ipg)
        call interpo_linear_type0(hhyzu,hyzu,irg,itg,ipg)
        call interpo_linear_type0(hhzzu,hzzu,irg,itg,ipg)
        hhyxu = hhxyu
        hhzxu = hhxzu
        hhzyu = hhyzu
        gamu(1,1) = hhxxu + 1.0d0
        gamu(1,2) = hhxyu
        gamu(1,3) = hhxzu
        gamu(2,2) = hhyyu + 1.0d0
        gamu(2,3) = hhyzu
        gamu(3,3) = hhzzu + 1.0d0
        gamu(2,1) = gamu(1,2)
        gamu(3,1) = gamu(1,3)
        gamu(3,2) = gamu(2,3)
!
        c11 = cri(irg,itg,ipg,1,1)
        c12 = cri(irg,itg,ipg,1,2)
        c13 = cri(irg,itg,ipg,1,3)
        c14 = cri(irg,itg,ipg,1,4)
        c15 = cri(irg,itg,ipg,1,5)
        c16 = cri(irg,itg,ipg,1,6)
        c21 = cri(irg,itg,ipg,2,1)
        c22 = cri(irg,itg,ipg,2,2)
        c23 = cri(irg,itg,ipg,2,3)
        c24 = cri(irg,itg,ipg,2,4)
        c25 = cri(irg,itg,ipg,2,5)
        c26 = cri(irg,itg,ipg,2,6)
        c31 = cri(irg,itg,ipg,3,1)
        c32 = cri(irg,itg,ipg,3,2)
        c33 = cri(irg,itg,ipg,3,3)
        c34 = cri(irg,itg,ipg,3,4)
        c35 = cri(irg,itg,ipg,3,5)
        c36 = cri(irg,itg,ipg,3,6)
!
!gauge      ckkx = c11 + c22 + c33      
!gauge      ckky = c12 + c24 + c35      
!gauge      ckkz = c13 + c25 + c36
        ckkx = 0.0d0
        ckky = 0.0d0
        ckkz = 0.0d0
!
        ckxlclxk = c11**2 + 2.0d0*c12*c21 + c22**2 + &
           &       2.0d0*c13*c31 + 2.0d0*c23*c32 + c33**2
        ckxlclyk = c11*c12 + c14*c21 + c12*c22 + c22*c24 + &
           &       c15*c31 + c13*c32 + c25*c32 + c23*c34 + c33*c35
        ckxlclzk = c11*c13 + c15*c21 + c12*c23 + c22*c25 + &
           &       c16*c31 + c26*c32 + c13*c33 + c23*c35 + c33*c36
        ckylclyk = c12**2 + 2.0d0*c14*c22 + c24**2 + &
           &       2.0d0*c15*c32 + 2.0d0*c25*c34 + c35**2
        ckylclzk = c12*c13 + c15*c22 + c14*c23 + c24*c25 + &
           &       c16*c32 + c15*c33 + c26*c34 + c25*c35 + c35*c36
        ckzlclzk = c13**2 + 2.0d0*c15*c23 + c25**2 + &
           &       2.0d0*c16*c33 + 2.0d0*c26*c35 + c36**2
!
!gauge      clxxckkl = c11*ckkx + c21*ckky + c31*ckkz
!gauge      clxyckkl = c12*ckkx + c22*ckky + c32*ckkz
!gauge      clxzckkl = c13*ckkx + c23*ckky + c33*ckkz
!gauge      clyyckkl = c14*ckkx + c24*ckky + c34*ckkz
!gauge      clyzckkl = c15*ckkx + c25*ckky + c35*ckkz
!gauge      clzzckkl = c16*ckkx + c26*ckky + c36*ckkz
        clxxckkl = 0.0d0
        clxyckkl = 0.0d0
        clxzckkl = 0.0d0
        clyyckkl = 0.0d0
        clyzckkl = 0.0d0
        clzzckkl = 0.0d0
!
! --- gradient of cristoffel = 0 for gauge condition.
!
!gauge      ir0 = min0(max0(irg-2,0),nrg-4)
!gauge      it0 = min0(max0(itg-2,0),ntg-4)
!gauge      ip0 = min0(max0(ipg-2,0),npg-4)
!
!gauge      do 7 ic = 1, 3
!
!gauge      ic1 = 1*(ic-2)*(ic-3)/2 - 2*(ic-1)*(ic-3) + 3*(ic-1)*(ic-2)/2
!gauge      ic2 = 2*(ic-2)*(ic-3)/2 - 4*(ic-1)*(ic-3) + 5*(ic-1)*(ic-2)/2
!gauge      ic3 = 3*(ic-2)*(ic-3)/2 - 5*(ic-1)*(ic-3) + 6*(ic-1)*(ic-2)/2
!
!gauge      do 8 ii = 1, 5
!gauge      irg0 = ir0 + ii - 1
!gauge      itg0 = it0 + ii - 1
!gauge      ipg0 = ip0 + ii - 1
!gauge      r5(ii) = rg(irg0)
!gauge      th5(ii) = thg(itg0)
!gauge      phi5(ii) = phig(ipg0)
!
!gauge      if (irg == 0) then
!gauge      fr5(ii) = cri(irg0,ntg,npgxz,1,ic1) + cri(irg0,ntg,npgxz,2,ic2)
!gauge     &        + cri(irg0,ntg,npgxz,3,ic3)
!gauge      ft5(ii) = cri(irg0,ntg,npgyz,1,ic1) + cri(irg0,ntg,npgyz,2,ic2)
!gauge     &        + cri(irg0,ntg,npgyz,3,ic3)
!gauge      fp5(ii) = cri(irg0,0,0,1,ic1) + cri(irg0,0,0,2,ic2)
!gauge     &        + cri(irg0,0,0,3,ic3)
!gauge      else if (irg /= 0.and.itg == 0) then
!gauge      fr5(ii) = cri(irg,itg0,npgxz,1,ic1) + cri(irg,itg0,npgxz,2,ic2)
!gauge     &        + cri(irg,itg0,npgxz,3,ic3)
!gauge      ft5(ii) = cri(irg,itg0,npgyz,1,ic1) + cri(irg,itg0,npgyz,2,ic2)
!gauge     &        + cri(irg,itg0,npgyz,3,ic3)
!gauge      fp5(ii) = cri(irg0,0,0,1,ic1) + cri(irg0,0,0,2,ic2)
!gauge     &        + cri(irg0,0,0,3,ic3)
!gauge      else
!gauge      fr5(ii) = cri(irg0,itg,ipg,1,ic1) + cri(irg0,itg,ipg,2,ic2)
!gauge     &        + cri(irg0,itg,ipg,3,ic3)
!gauge      ft5(ii) = cri(irg,itg0,ipg,1,ic1) + cri(irg,itg0,ipg,2,ic2)
!gauge     &        + cri(irg,itg0,ipg,3,ic3)
!gauge      fp5(ii) = cri(irg,itg,ipg0,1,ic1) + cri(irg,itg,ipg0,2,ic2)
!gauge     &        + cri(irg,itg,ipg0,3,ic3)
!gauge      end if
!gauge    8 continue
!
! --- To cartesian component.  
!
!gauge      rv = rg(irg)
!gauge      tv = thg(itg)
!gauge      pv = phig(ipg)
!gauge      rrgginv = rginv(irg)
!
!gauge      if (irg == 0) then
!gauge      grad1(1) = dfncdx(r5,fr5,rv)
!gauge      grad1(2) = dfncdx(r5,ft5,rv) 
!gauge      grad1(3) = dfncdx(r5,fp5,rv)
!gauge      else if (irg /= 0.and.itg == 0) then
!gauge      grad1(1) = dfncdx(th5,fr5,tv)*rrgginv
!gauge      grad1(2) = dfncdx(th5,ft5,tv)*rrgginv
!gauge      grad1(3) = dfncdx(r5,fp5,rv)
!gauge      else
!gauge      gr1 = dfncdx(r5,fr5,rv)
!gauge      gr2 = dfncdx(th5,ft5,tv)*rrgginv
!gauge      gr3 = dfncdx(phi5,fp5,pv)*rrgginv*cosecthg(itg)
!gauge      grad1(1) = gr1*sinthg(itg)*cosphig(ipg)
!gauge     &         + gr2*costhg(itg)*cosphig(ipg)  
!gauge     &         - gr3*sinphig(ipg) 
!gauge      grad1(2) = gr1*sinthg(itg)*sinphig(ipg)
!gauge     &         + gr2*costhg(itg)*sinphig(ipg)
!gauge     &         + gr3*cosphig(ipg) 
!gauge      grad1(3) = gr1*costhg(itg)
!gauge     &         - gr2*sinthg(itg)
!
!gauge      end if
!
!gauge      if (ic == 1) then 
!gauge      dckkx(1) = grad1(1)
!gauge      dckkx(2) = grad1(2)
!gauge      dckkx(3) = grad1(3)
!gauge      end if
!gauge      if (ic == 2) then 
!gauge      dckky(1) = grad1(1)
!gauge      dckky(2) = grad1(2)
!gauge      dckky(3) = grad1(3)
!gauge      end if
!gauge      if (ic == 3) then 
!gauge      dckkz(1) = grad1(1)
!gauge      dckkz(2) = grad1(2)
!gauge      dckkz(3) = grad1(3)
!gauge      end if
!
!gauge    7 continue
!
        dckkx(1:3) = 0.0D0
        dckky(1:3) = 0.0D0
        dckkz(1:3) = 0.0D0
!
! --- Derivatives of h_ab.
!
        call grgrad1g_midpoint(hxxd,grad1,irg,itg,ipg)
        dhd(1,1,1:3) = grad1(1:3)
        call grgrad1g_midpoint(hxyd,grad1,irg,itg,ipg)
        dhd(1,2,1:3) = grad1(1:3)
        dhd(2,1,1:3) = grad1(1:3)
        call grgrad1g_midpoint(hxzd,grad1,irg,itg,ipg)
        dhd(1,3,1:3) = grad1(1:3)
        dhd(3,1,1:3) = grad1(1:3)
        call grgrad1g_midpoint(hyyd,grad1,irg,itg,ipg)
        dhd(2,2,1:3) = grad1(1:3)
        call grgrad1g_midpoint(hyzd,grad1,irg,itg,ipg)
        dhd(2,3,1:3) = grad1(1:3)
        dhd(3,2,1:3) = grad1(1:3)
        call grgrad1g_midpoint(hzzd,grad1,irg,itg,ipg)
        dhd(3,3,1:3) = grad1(1:3)
!
        call grgrad1g_midpoint(hxxu,grad1,irg,itg,ipg)
        dhu(1,1,1:3) = grad1(1:3)
        call grgrad1g_midpoint(hxyu,grad1,irg,itg,ipg)
        dhu(1,2,1:3) = grad1(1:3)
        dhu(2,1,1:3) = grad1(1:3)
        call grgrad1g_midpoint(hxzu,grad1,irg,itg,ipg)
        dhu(1,3,1:3) = grad1(1:3)
        dhu(3,1,1:3) = grad1(1:3)
        call grgrad1g_midpoint(hyyu,grad1,irg,itg,ipg)
        dhu(2,2,1:3) = grad1(1:3)
        call grgrad1g_midpoint(hyzu,grad1,irg,itg,ipg)
        dhu(2,3,1:3) = grad1(1:3)
        dhu(3,2,1:3) = grad1(1:3)
        call grgrad1g_midpoint(hzzu,grad1,irg,itg,ipg)
        dhu(3,3,1:3) = grad1(1:3)
!
! --- Impose Dirac gauge.
!
!test      dhu(1,1,1) = - dhu(1,2,2) - dhu(1,3,3)
!test      dhu(2,2,2) = - dhu(2,1,1) - dhu(2,3,3)
!test      dhu(3,3,3) = - dhu(3,1,1) - dhu(3,2,2)
!dirac      dhu(1,3,3) = - dhu(1,1,1) - dhu(1,2,2)
!dirac      dhu(2,3,3) = - dhu(2,1,1) - dhu(2,2,2)
!dirac      dhu(3,3,3) = - dhu(3,1,1) - dhu(3,2,2)
!dirac      dhu(3,1,3) = dhu(1,3,3)
!dirac      dhu(3,2,3) = dhu(2,3,3)
!test3      dhu(1,1,1) = - dhu(1,2,2) - dhu(1,3,3)
!test3      dhu(2,1,1) = - dhu(2,2,2) - dhu(2,3,3)
!test3      dhu(3,1,1) = - dhu(3,2,2) - dhu(3,3,3)
!test3      dhu(1,2,1) = dhu(2,1,1)
!test3      dhu(1,3,1) = dhu(3,1,1)
!test4      dhu(1,2,2) = - dhu(1,1,1) - dhu(1,3,3)
!test4      dhu(2,2,2) = - dhu(2,1,1) - dhu(2,3,3)
!test4      dhu(3,2,2) = - dhu(3,1,1) - dhu(3,3,3)
!test4      dhu(2,1,2) = dhu(1,2,2)
!test4      dhu(2,3,2) = dhu(3,2,2)
!
!dirac      dhx=gamu(1,1)*dhd(1,1,1)+gamu(1,2)*dhd(1,1,2)+gamu(1,3)*dhd(1,1,3)
!dirac     &   +gamu(2,1)*dhd(2,1,1)+gamu(2,2)*dhd(2,1,2)+gamu(2,3)*dhd(2,1,3)
!dirac     &   +gamu(3,1)*dhd(3,1,1)+gamu(3,2)*dhd(3,1,2)+gamu(3,3)*dhd(3,1,3)
!dirac      dhy=gamu(1,1)*dhd(1,2,1)+gamu(1,2)*dhd(1,2,2)+gamu(1,3)*dhd(1,2,3)
!dirac     &   +gamu(2,1)*dhd(2,2,1)+gamu(2,2)*dhd(2,2,2)+gamu(2,3)*dhd(2,2,3)
!dirac     &   +gamu(3,1)*dhd(3,2,1)+gamu(3,2)*dhd(3,2,2)+gamu(3,3)*dhd(3,2,3)
!dirac      dhz=gamu(1,1)*dhd(1,3,1)+gamu(1,2)*dhd(1,3,2)+gamu(1,3)*dhd(1,3,3)
!dirac     &   +gamu(2,1)*dhd(2,3,1)+gamu(2,2)*dhd(2,3,2)+gamu(2,3)*dhd(2,3,3)
!dirac     &   +gamu(3,1)*dhd(3,3,1)+gamu(3,2)*dhd(3,3,2)+gamu(3,3)*dhd(3,3,3)
!dirac      gzzinv = 1.0d0/gamu(3,3)
!dirac      dhd(1,3,3) = - gzzinv*dhx + dhd(1,3,3)
!dirac      dhd(2,3,3) = - gzzinv*dhy + dhd(2,3,3)
!dirac      dhd(3,3,3) = - gzzinv*dhz + dhd(3,3,3)
!dirac      dhd(3,1,3) = dhd(1,3,3)
!dirac      dhd(3,2,3) = dhd(2,3,3)
!
! --- end
!
        do ia = 1, 3
          do ib = 1, 3
            dhudhd(ia,ib) = 0.0d0
            do ic = 1, 3
              do id = 1, 3
                dhudhd(ia,ib) = dhudhd(ia,ib) + dhu(ic,id,ia)*dhd(ib,id,ic)
              end do
            end do
          end do
        end do
!        dhdh(1) = dhudhd(1,1) + dhudhd(1,1)
!        dhdh(2) = dhudhd(1,2) + dhudhd(2,1)
!        dhdh(3) = dhudhd(1,3) + dhudhd(3,1)
        dhdh(1:3) = dhudhd(1,1:3) + dhudhd(1:3,1)
        dhdh(4) = dhudhd(2,2) + dhudhd(2,2)
        dhdh(5) = dhudhd(2,3) + dhudhd(3,2)
        dhdh(6) = dhudhd(3,3) + dhudhd(3,3)
!
!        call dadbscalar_type0(hxxd,d2hxx,irg,itg,ipg)
!        call dadbscalar_type0(hxyd,d2hxy,irg,itg,ipg)
!        call dadbscalar_type0(hxzd,d2hxz,irg,itg,ipg)
!        call dadbscalar_type0(hyyd,d2hyy,irg,itg,ipg)
!        call dadbscalar_type0(hyzd,d2hyz,irg,itg,ipg)
!        call dadbscalar_type0(hzzd,d2hzz,irg,itg,ipg)
!
        call dadbscalar_type3(hxxd,d2hxx,irg,itg,ipg)
        call dadbscalar_type3(hxyd,d2hxy,irg,itg,ipg)
        call dadbscalar_type3(hxzd,d2hxz,irg,itg,ipg)
        call dadbscalar_type3(hyyd,d2hyy,irg,itg,ipg)
        call dadbscalar_type3(hyzd,d2hyz,irg,itg,ipg)
        call dadbscalar_type3(hzzd,d2hzz,irg,itg,ipg)
!
        hd2h(1) = hhxxu*d2hxx(1,1) + hhxyu*d2hxx(1,2) + hhxzu*d2hxx(1,3) &
       &        + hhyxu*d2hxx(2,1) + hhyyu*d2hxx(2,2) + hhyzu*d2hxx(2,3) &
       &        + hhzxu*d2hxx(3,1) + hhzyu*d2hxx(3,2) + hhzzu*d2hxx(3,3)
        hd2h(2) = hhxxu*d2hxy(1,1) + hhxyu*d2hxy(1,2) + hhxzu*d2hxy(1,3) &
       &        + hhyxu*d2hxy(2,1) + hhyyu*d2hxy(2,2) + hhyzu*d2hxy(2,3) &
       &        + hhzxu*d2hxy(3,1) + hhzyu*d2hxy(3,2) + hhzzu*d2hxy(3,3)
        hd2h(3) = hhxxu*d2hxz(1,1) + hhxyu*d2hxz(1,2) + hhxzu*d2hxz(1,3) &
       &        + hhyxu*d2hxz(2,1) + hhyyu*d2hxz(2,2) + hhyzu*d2hxz(2,3) &
       &        + hhzxu*d2hxz(3,1) + hhzyu*d2hxz(3,2) + hhzzu*d2hxz(3,3)
        hd2h(4) = hhxxu*d2hyy(1,1) + hhxyu*d2hyy(1,2) + hhxzu*d2hyy(1,3) &
       &        + hhyxu*d2hyy(2,1) + hhyyu*d2hyy(2,2) + hhyzu*d2hyy(2,3) &
       &        + hhzxu*d2hyy(3,1) + hhzyu*d2hyy(3,2) + hhzzu*d2hyy(3,3)
        hd2h(5) = hhxxu*d2hyz(1,1) + hhxyu*d2hyz(1,2) + hhxzu*d2hyz(1,3) &
       &        + hhyxu*d2hyz(2,1) + hhyyu*d2hyz(2,2) + hhyzu*d2hyz(2,3) &
       &        + hhzxu*d2hyz(3,1) + hhzyu*d2hyz(3,2) + hhzzu*d2hyz(3,3)
        hd2h(6) = hhxxu*d2hzz(1,1) + hhxyu*d2hzz(1,2) + hhxzu*d2hzz(1,3) &
       &        + hhyxu*d2hzz(2,1) + hhyyu*d2hzz(2,2) + hhyzu*d2hzz(2,3) &
       &        + hhzxu*d2hzz(3,1) + hhzyu*d2hzz(3,2) + hhzzu*d2hzz(3,3)
!
! --- -1/2 Laplacian(h_ab)
!
        delhab(1) = d2hxx(1,1) + d2hxx(2,2) + d2hxx(3,3)
        delhab(2) = d2hxy(1,1) + d2hxy(2,2) + d2hxy(3,3)
        delhab(3) = d2hxz(1,1) + d2hxz(2,2) + d2hxz(3,3)
        delhab(4) = d2hyy(1,1) + d2hyy(2,2) + d2hyy(3,3)
        delhab(5) = d2hyz(1,1) + d2hyz(2,2) + d2hyz(3,3)
        delhab(6) = d2hzz(1,1) + d2hzz(2,2) + d2hzz(3,3)
!
! --- Ricci tensor R_ab and RNL_ab.
!
        rabnl(irg,itg,ipg,1) = -0.5d0*(dhdh(1) + hd2h(1)) &
           &                     - dckkx(1) + clxxckkl - ckxlclxk
        rabnl(irg,itg,ipg,2) = -0.5d0*(dhdh(2) + hd2h(2)) &
           &                     - dckky(1) + clxyckkl - ckxlclyk
        rabnl(irg,itg,ipg,3) = -0.5d0*(dhdh(3) + hd2h(3)) &
           &                     - dckkz(1) + clxzckkl - ckxlclzk
        rabnl(irg,itg,ipg,4) = -0.5d0*(dhdh(4) + hd2h(4)) &
           &                     - dckky(2) + clyyckkl - ckylclyk
        rabnl(irg,itg,ipg,5) = -0.5d0*(dhdh(5) + hd2h(5)) &
           &                     - dckkz(2) + clyzckkl - ckylclzk
        rabnl(irg,itg,ipg,6) = -0.5d0*(dhdh(6) + hd2h(6)) &
           &                     - dckkz(3) + clzzckkl - ckzlclzk
        rab(irg,itg,ipg,1:6) = -0.5d0*delhab(1:6) + rabnl(irg,itg,ipg,1:6)
!
      end do
    end do
  end do
!
end subroutine riccitensor_midpoint
