module interface_sourceterm_trfreeG_WL
  implicit none
  interface 
    subroutine sourceterm_trfreeG_WL(souten)
      real(8), pointer :: souten(:,:,:,:)
    end subroutine sourceterm_trfreeG_WL

    subroutine sourceterm_trfreeG_WL_bhex(souten,soubi)
      real(8), pointer :: souten(:,:,:,:), soubi(:,:,:,:)
    end subroutine sourceterm_trfreeG_WL_bhex

  end interface
end module interface_sourceterm_trfreeG_WL
