module interface_source_HaC_WL
  implicit none
  interface 
    subroutine source_HaC_WL(sou)
      real(8), pointer :: sou(:,:,:)
    end subroutine source_HaC_WL
!
    subroutine source_HaC_WL_COT(sou,cobj)
      real(8), pointer :: sou(:,:,:)
      character(len=2), intent(in) :: cobj
    end subroutine source_HaC_WL_COT
  end interface
end module interface_source_HaC_WL
