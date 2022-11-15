module interface_source_ang_mom_WL_EMF
  implicit none
  interface 
    subroutine source_ang_mom_WL_EMF(soug)
      real(8), pointer     :: soug(:,:,:)
    end subroutine source_ang_mom_WL_EMF
  end interface
end module interface_source_ang_mom_WL_EMF
