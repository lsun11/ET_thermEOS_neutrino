module interface_source_MWspatial_WL
  implicit none
  interface 
    subroutine source_MWspatial_WL(souvec)
      real(8), pointer :: souvec(:,:,:,:)
    end subroutine source_MWspatial_WL
  end interface
end module interface_source_MWspatial_WL
