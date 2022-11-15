subroutine calc_omega_drot_bisection(vphiy,alphw,psiw,bvydw,hyydw,omega)
  use phys_constant, only  : long
  use coordinate_grav_r, only : rg
  use def_matter_parameter
!  use def_vector_phi, only : vec_phi
  implicit none
  real(long), intent(in):: vphiy, alphw, psiw, bvydw, hyydw
  real(long), intent(inout):: omega
! -- Jome: functional of Omega (specific angular momentum in Newtonian)
! -- Jome_int: integration of Jome w.r.t. omega
!
  real(long) :: Jome, omega0, omega1, omegam
  real(long) :: sgg0, sgg1, sggm, sgg0m, sgg1m
  real(long) :: p4a2, ovyu, ov2, ovphi, term1, term2, term3
  real(long) :: ddomega
  real(long) :: error, small, smallome = 1.0d-30
  integer    :: i, numero
!-------------------------------------------------------------
! Assyme axisymmetry.  
!
  if (ome.eq.0.0d0) ome = 0.01d0 ! For 1D initial
  small = ome*0.001
  p4a2 = psiw**4/alphw**2
  numero = 1
!
  if (vphiy.lt.0.001d0*rg(1)) then
    omega = ome
  else
  omega0 = smallome
  omega1 = ome
  do 
    omegam = (omega0 + omega1)*0.5d0
    do i = 0, 2
      if (i.eq.0) omega = omega0
      if (i.eq.1) omega = omega1
      if (i.eq.2) omega = omegam
!      Jome = A2DR*omega*((ome/(omega+small))**index_DR - 1.0d0)
      Jome = A2DR*omega*((ome/omega)**index_DR - 1.0d0)
      ovyu = bvydw + omega*vphiy
! This is in fact only the \omega^y component.
!      ov2 = ovyu**2+ovxu**2+ovzu**2
      ov2   = ovyu**2*(1.0d0 + hyydw)
      ovphi = ovyu*vphiy*(1.0d0 + hyydw)
      term1 = 1.0d0 - p4a2*ov2
      term2 = p4a2*ovphi
!
      if (i.eq.0) sgg0 = Jome*term1  - term2
      if (i.eq.1) sgg1 = Jome*term1  - term2
      if (i.eq.2) sggm = Jome*term1  - term2
    end do
    sgg0m = sgg0*sggm
    sgg1m = sgg1*sggm
!
    ddomega = omega1 - omega0
    omega = omegam
    if (sggm.eq.0.0d0) then 
      ddomega = 0.0d0
    else if (sgg0m.gt.0.0d0.and.sgg1m.lt.0.0d0) then
      omega0 = omegam
    else if (sgg0m.lt.0.0d0.and.sgg1m.gt.0.0d0) then
      omega1 = omegam
    else
write(6,*) omega0, omegam, omega1
write(6,*) sgg0, sggm, sgg1
      stop 'rotation law'
    end if
!
    if (omega.gt.ome) omega = ome
    if (omega.le.0.0d0) omega = small
!!    error = dabs(ddomega/ome)
    error = dabs(ddomega/omega)
    numero = numero + 1
    if (numero>1000) then
write(6,*) omega0, omegam, omega1
write(6,*) vphiy, ome, ddomega
write(6,*) ome, p4a2, bvydw
write(6,*) Jome, ovyu, omega
      write(6,*)' numero = ', numero, '   error =',error
    end if
!      if (iter<10.and.numero>10) exit
    if (numero>1010) stop 'rotation law'
    if (dabs(error)<1.0d-14) exit
!write(6,*) Jome, ovyu, omega
!!write(6,*) Jome1, dJome1do
!!write(6,*) Jome2, dJome2do
!write(6,*) omega,ddomega,sgg
!!pause
  end do
  end if
!!  end if
!
end subroutine calc_omega_drot_bisection
