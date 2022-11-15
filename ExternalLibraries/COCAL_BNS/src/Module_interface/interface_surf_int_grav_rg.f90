module interface_surf_int_grav_rg
  implicit none
  interface 
    subroutine surf_int_grav_rg(sousf,surf,irg)
      real(8), pointer     :: sousf(:,:)
      real(8), intent(out) :: surf
      integer, intent(in)  :: irg
    end subroutine surf_int_grav_rg

    subroutine surf_int_grav_rg_3d(sousf,surfx,surfy,surfz,irg)
      real(8), pointer     :: sousf(:,:,:)
      real(8), intent(out) :: surfx,surfy,surfz
      integer, intent(in)  :: irg
    end subroutine surf_int_grav_rg_3d

    subroutine surf_int_grav_rg_noweights(sousf,surf)
      real(8), pointer     :: sousf(:,:)
      real(8), intent(out) :: surf
    end subroutine surf_int_grav_rg_noweights
  end interface
end module interface_surf_int_grav_rg
