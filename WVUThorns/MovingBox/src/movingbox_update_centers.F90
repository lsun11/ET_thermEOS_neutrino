#include "cctk.h"
#include "cctk_Arguments.h"
#include "cctk_Functions.h"
#include "cctk_Parameters.h"
!#include "Symmetry.h"
!
!----------------------------------------------------------------------------------
! Update center of a moving box.  Useful for moving NS grid box in BHNS simulation
!----------------------------------------------------------------------------------
subroutine movingbox_update_centers(CCTK_ARGUMENTS)
  implicit none

  DECLARE_CCTK_ARGUMENTS
  DECLARE_CCTK_PARAMETERS
  DECLARE_CCTK_FUNCTIONS

  integer :: i,j
  real*8  :: r_ns,theta_ns,phi_ns,x_ns,y_ns,z_ns

  integer :: LARGE_BOX_AROUND_NS_WHEN_NS_GETS_CLOSE_TO_BH
  parameter(LARGE_BOX_AROUND_NS_WHEN_NS_GETS_CLOSE_TO_BH=1)

  integer :: DESTROY_NS_BOXES_WHEN_NS_GETS_CLOSE_TO_BH
  parameter(DESTROY_NS_BOXES_WHEN_NS_GETS_CLOSE_TO_BH=2)

  integer :: NO_SYMM, EQUATORIAL, OCTANT, PI_SYMM, AXISYM
  parameter(NO_SYMM = 0, EQUATORIAL = 1, OCTANT = 2, PI_SYMM = 3, AXISYM = 4)

  if(track_bhns.eq.0) then

     if(mod(cctk_iteration,regrid_every)==0 .and. CCTK_ITERATION.ge.0) then
!        if(Symmetry=="equatorial" .or. Symmetry=="none") then
!        if (CCTK_EQUALS(Symmetry,"none") .or. CCTK_EQUALS(Symmetry,"equatorial")) then
           !Set position in CarpetRegrid2
           position_x(2) = Box1X_VolInt/Box1denom_VolInt
           position_y(2) = Box1Y_VolInt/Box1denom_VolInt
           position_z(2) = 0.D0

        if(avoid_large_drift_in_ns_box==1) then
           if(sqrt((position_x(2)-position_x(1))**2 + (position_y(2)-position_y(1))**2 + (position_z(2)-position_z(1))**2) .gt. (4.D0*radius(2,1)+radius(1,1)) ) then
              x_ns = position_x(2)
              y_ns = position_y(2)
              z_ns = position_z(2)

              r_ns = sqrt(x_ns**2 + y_ns**2 + z_ns**2)
              phi_ns = atan2(y_ns,x_ns)

              !FIXME: We assume z_ns = 0.D0 here
              position_x(2) = (4.D0*radius(2,1)+radius(1,1)) * cos(phi_ns)
              position_y(2) = (4.D0*radius(2,1)+radius(1,1)) * sin(phi_ns)
              position_z(2) = 0.D0
           end if
        end if

        if(moving_box_type==DESTROY_NS_BOXES_WHEN_NS_GETS_CLOSE_TO_BH) then
           position_x(3) = position_x(2)
           position_y(3) = position_y(2)
           position_z(3) = position_z(2)

           position_x(4) = position_x(1)
           position_y(4) = position_y(1)
           position_z(4) = position_z(1)

           ! The BH box center is located at position_xyz(1).  The NS box center needs to be at position_xyz(2).
           if(sqrt((position_x(2)-position_x(1))**2 + (position_y(2)-position_y(1))**2 + (position_z(2)-position_z(1))**2) .le. (2.D0*radius(2,1)+radius(1,1)) .or. BOXES_IN_FINAL_CONFIGURATION==1) then
              BOXES_IN_FINAL_CONFIGURATION=1

              !active(3) = .false.
              !active(4) = .false.
           end if
        end if

        if(moving_box_type==LARGE_BOX_AROUND_NS_WHEN_NS_GETS_CLOSE_TO_BH) then
           ! The BH box center is located at position_xyz(1).  The NS box center needs to be at position_xyz(2).
           if(sqrt((position_x(2)-position_x(1))**2 + (position_y(2)-position_y(1))**2 + (position_z(2)-position_z(1))**2) .gt. (2.D0*radius(2,1)+radius(1,1)) ) then
              do i=3,10
                 position_x(i) = position_x(2)
                 position_y(i) = position_y(2)
                 position_z(i) = position_z(2)
              end do
           else
              !Set position in CarpetRegrid2
              position_x(3) = position_x(2)+2.0*radius(2,1)
              position_y(3) = position_y(2)
              position_z(3) = 0.D0

              !Set position in CarpetRegrid2
              position_x(4) = position_x(2)+2.0*radius(2,1)
              position_y(4) = position_y(2)+2.0*radius(2,1)
              position_z(4) = 0.D0

              !Set position in CarpetRegrid2
              position_x(5) = position_x(2)
              position_y(5) = position_y(2)+2.0*radius(2,1)
              position_z(5) = 0.D0

              !           Box2X_VolInt = position_x(3)
              !           Box2Y_VolInt = position_y(3)
              !           Box3X_VolInt = position_x(4)
              !           Box3Y_VolInt = position_y(4)
              !           Box4X_VolInt = position_x(5)
              !           Box4Y_VolInt = position_y(5)
              !           Box2denom_VolInt = 1.D0
              !           Box3denom_VolInt = 1.D0
              !           Box4denom_VolInt = 1.D0

              !Set position in CarpetRegrid2
              position_x(6) = position_x(2)-2.0*radius(2,1)
              position_y(6) = position_y(2)+2.0*radius(2,1)
              position_z(6) = 0.D0

              !Set position in CarpetRegrid2
              position_x(7) = position_x(2)-2.0*radius(2,1)
              position_y(7) = position_y(2)
              position_z(7) = 0.D0

              !Set position in CarpetRegrid2
              position_x(8) = position_x(2)-2.0*radius(2,1)
              position_y(8) = position_y(2)-2.0*radius(2,1)
              position_z(8) = 0.D0

              !Set position in CarpetRegrid2
              position_x(9) = position_x(2)
              position_y(9) = position_y(2)-2.0*radius(2,1)
              position_z(9) = 0.D0

              !Set position in CarpetRegrid2
              position_x(10) = position_x(2)+2.0*radius(2,1)
              position_y(10) = position_y(2)-2.0*radius(2,1)
              position_z(10) = 0.D0

           end if
        end if
        write(*,*) "UPDATING CENTER OF NS MOVING BOX TO:",position_x(2),position_y(2),position_z(2)
        if(moving_box_type==LARGE_BOX_AROUND_NS_WHEN_NS_GETS_CLOSE_TO_BH) then
           write(*,*) "UPDATING CENTER OF 2nd MOVING BOX TO:",position_x(3),position_y(3),position_z(3)
           write(*,*) "UPDATING CENTER OF 3rd MOVING BOX TO:",position_x(4),position_y(4),position_z(4)
           write(*,*) "UPDATING CENTER OF 4th MOVING BOX TO:",position_x(5),position_y(5),position_z(5)
        end if
        write(*,*) "RADIUS OF MOVING BOX1:",radius(1,1)
        write(*,*) "RADIUS OF MOVING BOX2:",radius(2,1)
        write(*,*) "MOVING BOX1: ACTIVE (BH)?",active(1)
        write(*,*) "MOVING BOX2: ACTIVE (NS)?",active(2)
        if(moving_box_type==LARGE_BOX_AROUND_NS_WHEN_NS_GETS_CLOSE_TO_BH) then
           write(*,*) "MOVING BOX3: ACTIVE?",active(3)
           write(*,*) "MOVING BOX4: ACTIVE?",active(4)
           write(*,*) "MOVING BOX5: ACTIVE?",active(5)
        end if
     else
     !   write(*,*) "ERROR, UNSUPPORTED: Symmetry=",Symmetry
     !end if
  end if
  
else if (track_bhns.eq.1) then

  if(mod(cctk_iteration,regrid_every)==0 .and. cctk_iteration.gt.1) then
     !if(Symmetry=="equatorial") then           
           !Set position in CarpetRegrid2
           position_x(1) = Box1X_VolInt1/Box1denom_VolInt1
           position_y(1) = Box1Y_VolInt1/Box1denom_VolInt1
           position_z(1) = 0.D0
           
           !Set position in CarpetRegrid2
           position_x(2) = Box1X_VolInt2/Box1denom_VolInt2
           position_y(2) = Box1Y_VolInt2/Box1denom_VolInt2
           position_z(2) = 0.D0
           
           
           print *, "CENTER 1 x, y, r = ", position_x(1), position_y(1), radius_star1
           print *, "CENTER 2 x, y, r = ", position_x(2), position_y(2), radius_star2
           print *,  "VolInts: Mass star 1,2=", 2.d0*Box1denom_VolInt1,2.d0*Box1denom_VolInt2

           mass_star1=Box1denom_VolInt1
           mass_star2=Box1denom_VolInt2

           write(*,*) "UPDATING CENTER OF STAR 1 MOVING BOX TO:",position_x(1),position_y(1),position_z(1)
           write(*,*) "UPDATING CENTER OF STAR 2 MOVING BOX TO:",position_x(2),position_y(2),position_z(2)
        !end if
     end if
  end if
end subroutine movingbox_update_centers
