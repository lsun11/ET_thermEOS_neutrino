module interface_dadbscalar_type3
  implicit none
  interface 
    subroutine dadbscalar_type3(fnc,d2f,irg,itg,ipg)
      real(8), pointer :: fnc(:,:,:)
      real(8) :: d2f(1:3,1:3)
      integer :: irg, itg, ipg
    end subroutine dadbscalar_type3

    subroutine dadbscalar_type3_bhex(fnc,d2f,irg,itg,ipg)
      real(8), pointer :: fnc(:,:,:)
      real(8) :: d2f(1:3,1:3)
      integer :: irg, itg, ipg
    end subroutine dadbscalar_type3_bhex
  end interface
end module interface_dadbscalar_type3
