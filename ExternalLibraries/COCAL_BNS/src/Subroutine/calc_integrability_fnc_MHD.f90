subroutine calc_integrability_fnc_MHD(Aphi)
  use phys_constant, only : long
  use grid_parameter, only : nrf, ntf
  use def_matter_parameter, only : ome, ber
  use def_metric,  only : alph, bvxu, bvyu, bvzu
  use def_emfield, only : va  , vaxd, vayd, vazd
  use def_vector_phi, only : vec_phif
  use integrability_fnc_MHD
  use interface_interpo_gr2fl_type0
  implicit none
  real(long) :: Aphi, Aphi_max, Aphi_tmp, Ay, Aphi_max_NS, At0
  real(long) :: x, a, b, c, r, width, point
  real(long) :: stepfn, stepfn_int
  integer    :: irf, itf, ipf
!
  Aphi_max    = Aphi_max_surf
  Aphi_max_NS = Aphi_max_vol
!
! -- Stream fn sqrt(-g)Psi
  MHDfnc_PSI  = 0.0d0 ; MHDfnc_dPSI = 0.0d0 ; MHDfnc_d2PSI= 0.0d0
  if ((Aphi-Aphi_max).gt.0.0d0) then
    MHDfnc_PSI  = MHDpar_apsi*(Aphi-Aphi_max)**(MHDidx_p+1.0d0) &
    &                                         /(MHDidx_p+1.0d0)
    MHDfnc_dPSI = MHDpar_apsi*(Aphi-Aphi_max)** MHDidx_p
    MHDfnc_d2PSI= MHDpar_apsi*(Aphi-Aphi_max)**(MHDidx_p-1.0d0)*MHDidx_p
!
! -- Lambda_phi
  MHDfnc_Lambda_phi = 0.0d0 ; MHDfnc_dLambda_phi= 0.0d0
!!##    MHDfnc_Lambda_phi = MHDpar_a*(Aphi-Aphi_max)**(MHDidx_k+1.0d0) &
!!##    &                                            /(MHDidx_k+1.0d0)
!!##    MHDfnc_dLambda_phi= MHDpar_a*(Aphi-Aphi_max)** MHDidx_k
!!    width = 50.0d0 ; point = 0.1d0
    width = 10.0d0 ; point = 0.5d0
    b = width/(Aphi_max_NS - Aphi_max)
    c = point*(Aphi_max_NS - Aphi_max)
    stepfn     = 0.5d0*(    tanh(b*(Aphi - Aphi_max - c))  + 1.0d0)
    stepfn_int = 0.5d0*(log(cosh(b*(Aphi - Aphi_max - c))) + Aphi)
!
    MHDfnc_Lambda_phi = MHDpar_a*stepfn_int
    MHDfnc_dLambda_phi= MHDpar_a*stepfn
!
!
!!    x = Aphi; a = Aphi_max*0.1d0; b = Aphi_max*1.1; c = Aphi_max*1.3; r = 0.5
!    x = Aphi; a = Aphi_max*0.1d0; b = Aphi_max*1.2; c = Aphi_max*1.2; r = 0.5
!!    x = Aphi; a = Aphi_max*0.1d0; b = Aphi_max*2.5; c = Aphi_max*2.5; r = 0.5
!    MHDfnc_Lambda_phi = MHDpar_a &
!    &  *(0.5*x - r*b - (1.0-r)*c &
!    &  + 0.5*a*r*log(cosh((x-b)/a)) + 0.5*a*(1.0-r)*log(cosh((x-c)/a)))
!    MHDfnc_dLambda_phi= MHDpar_a &
!    &  *(0.5 + 0.5*r*tanh((x-b)/a) + 0.5*(1.0-r)*tanh((x-c)/a))
  end if
!
! -- At
  MHDfnc_At  = 0.0d0
  MHDfnc_dAt = 0.0d0
  MHDfnc_d2At= 0.0d0
!
  MHDfnc_At  = - ome*Aphi**(MHDidx_q+1.0d0)/(MHDidx_q+1.0d0) + MHDpar_charge
  if (MHDidx_q.eq.0.0d0) MHDfnc_dAt = - ome
  if (Aphi.ne.0.0d0) then 
    MHDfnc_dAt = - ome*Aphi** MHDidx_q
    MHDfnc_d2At= - ome*Aphi**(MHDidx_q-1.0d0)*MHDidx_q
  end if
!
! -- Lambda
  MHDfnc_Lambda  = - MHDpar_Lc*Aphi - ber
  MHDfnc_dLambda = - MHDpar_Lc
  if (MHDidx_s.eq.2.0d0) then
    MHDfnc_Lambda  = - MHDpar_Lc*Aphi**MHDidx_s - ber
    MHDfnc_dLambda = - MHDpar_Lc*Aphi *MHDidx_s
  end if
!
! -- Lambda without const
  MHDfnc_Lambda_GS  = - MHDpar_Lc*Aphi
  MHDfnc_dLambda_GS = - MHDpar_Lc
  if (MHDidx_s.eq.2.0d0) then
    MHDfnc_Lambda_GS  = - MHDpar_Lc*Aphi**MHDidx_s
    MHDfnc_dLambda_GS = - MHDpar_Lc*Aphi *MHDidx_s
  end if
!
! -- Lambda_t
  MHDfnc_Lambda_t =  0.0d0  ! not used
!
end subroutine calc_integrability_fnc_MHD
