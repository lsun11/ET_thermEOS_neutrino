module interface_sourceterm_trG_WL
  implicit none
  interface 
    subroutine sourceterm_trG_WL(sou)
      real(8), pointer :: sou(:,:,:)
    end subroutine sourceterm_trG_WL

    subroutine sourceterm_trG_WL_all(sou)
      real(8), pointer :: sou(:,:,:)
    end subroutine sourceterm_trG_WL_all

    subroutine sourceterm_trG_WL_all_bhex(sou)
      real(8), pointer :: sou(:,:,:)
    end subroutine sourceterm_trG_WL_all_bhex
  end interface
end module interface_sourceterm_trG_WL
