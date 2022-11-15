module interface_source_proper_mass_peos
  implicit none
  interface 
    subroutine source_proper_mass_peos(souf)
      real(8), pointer     :: souf(:,:,:)
    end subroutine source_proper_mass_peos
    subroutine source_proper_mass_peos_BHT(soug)
      real(8), pointer     :: soug(:,:,:)
    end subroutine source_proper_mass_peos_BHT
  end interface
end module interface_source_proper_mass_peos
