module interface_source_trfreeG_WL
  implicit none
  interface
    subroutine source_trfreeG_WL(souten)
      real(8), pointer :: souten(:,:,:,:)
    end subroutine source_trfreeG_WL

    subroutine source_trfreeG_WL_bhex(souten,soubi)
      real(8), pointer :: souten(:,:,:,:), soubi(:,:,:,:)
    end subroutine source_trfreeG_WL_bhex
  end interface
end module interface_source_trfreeG_WL
