subroutine write_parameter_integrability_fnc_MHD
  use integrability_fnc_MHD, only : MHDpar_apsi,   MHDidx_p, &
  &                                 MHDpar_a,      MHDidx_k, &
  &                                 MHDpar_charge, MHDidx_q, & 
  &                                 MHDpar_Lc
  implicit none
  character(len=28) dum
  character(len=100) char_100(4)
  open(1,file='rnspar_MHDfnc.dat',status='old')
  read(1,'(a28,a100)') dum, char_100(1)  ! For flow fnc Psi
  read(1,'(a28,a100)') dum, char_100(2)  ! For Lambda_phi
  read(1,'(a28,a100)') dum, char_100(3)  ! For At 
  read(1,'(a28,a100)') dum, char_100(4)  ! For Lambda
  close(1)
!
  open(1,file='rnspar_MHDfnc.dat.las',status='unknown')
  write(1,'(1p,2e14.6,a100)') MHDpar_apsi,   MHDidx_p, char_100(1)
  write(1,'(1p,2e14.6,a100)') MHDpar_a,      MHDidx_k, char_100(2)
  write(1,'(1p,2e14.6,a100)') MHDpar_charge, MHDidx_q, char_100(3)
  write(1,'(1p,1e14.6,14x,a100)') MHDpar_Lc              , char_100(4)
  close(1)
end subroutine write_parameter_integrability_fnc_MHD
