module interface_hydro_spbns_vep_CF_peos
  implicit none
  interface 
    subroutine hydro_spbns_vep_CF_peos(vpot,iter,impt,ihy)
      real(8), pointer :: vpot(:,:,:)
      integer :: iter,impt,ihy
    end subroutine hydro_spbns_vep_CF_peos
  end interface
end module interface_hydro_spbns_vep_CF_peos
