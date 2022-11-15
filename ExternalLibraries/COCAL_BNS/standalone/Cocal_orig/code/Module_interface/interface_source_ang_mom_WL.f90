module interface_source_ang_mom_WL
  implicit none
  interface 
    subroutine source_ang_mom_WL(soug,souf)
      real(8), pointer     :: soug(:,:,:), souf(:,:,:)
    end subroutine source_ang_mom_WL
    subroutine source_ang_mom_WL_BHT(soug,sougtor)
      real(8), pointer     :: soug(:,:,:), sougtor(:,:,:)
    end subroutine source_ang_mom_WL_BHT
  end interface
end module interface_source_ang_mom_WL
