module interface_source_angmom_asympto
  implicit none
  interface 
    subroutine source_angmom_asympto(sousf,irg)
      real(8), pointer :: sousf(:,:)
      integer          :: irg
    end subroutine source_angmom_asympto

    subroutine source_angmom_asympto_3d(sousf,irg)
      real(8), pointer :: sousf(:,:,:)
      integer          :: irg
    end subroutine source_angmom_asympto_3d
  end interface
end module interface_source_angmom_asympto
