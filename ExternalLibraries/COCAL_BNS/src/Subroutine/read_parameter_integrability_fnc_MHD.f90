subroutine read_parameter_integrability_fnc_MHD
  use integrability_fnc_MHD, only : MHDpar_apsi,   MHDidx_p, &
  &                                 MHDpar_a,      MHDidx_k, &
  &                                 MHDpar_charge, MHDidx_q, & 
  &                                 MHDpar_Lc
  implicit none
  open(1,file='rnspar_MHDfnc.dat',status='old')
  read(1,'(1p,2e14.6)') MHDpar_apsi,   MHDidx_p  ! For flow fnc Psi
  read(1,'(1p,2e14.6)') MHDpar_a,      MHDidx_k  ! For Lambda_phi
  read(1,'(1p,2e14.6)') MHDpar_charge, MHDidx_q  ! For At 
  read(1,'(1p,2e14.6)') MHDpar_Lc                ! For Lambda
  close(1)
end subroutine read_parameter_integrability_fnc_MHD
