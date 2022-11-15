module interface_source_mass_asympto
  implicit none
  interface 
    subroutine source_mass_asympto(fnc,sousf,irg)
      real(8), pointer :: fnc(:,:,:), sousf(:,:)
      integer          :: irg
    end subroutine source_mass_asympto
!
    subroutine source_mass_asympto_gauge(sousf1,irg)
      real(8), pointer :: sousf1(:,:)
      integer          :: irg
    end subroutine source_mass_asympto_gauge
  end interface
end module interface_source_mass_asympto
