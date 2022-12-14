module interface_sourceterm_MoC_WL
  implicit none
  interface 
    subroutine sourceterm_MoC_WL(souvec)
      real(8), pointer :: souvec(:,:,:,:)
    end subroutine sourceterm_MoC_WL

    subroutine sourceterm_MoC_WL_all(souvec)
      real(8), pointer :: souvec(:,:,:,:)
    end subroutine sourceterm_MoC_WL_all

    subroutine sourceterm_MoC_WL_all_bhex(souvec)
      real(8), pointer :: souvec(:,:,:,:)
    end subroutine sourceterm_MoC_WL_all_bhex
  end interface
end module interface_sourceterm_MoC_WL
