subroutine excurve
  use phys_constant,  only : long
  use make_array_3d
  use grid_parameter, only : nrg, ntg, npg
  use def_metric
  use interface_grgrad_midpoint
  use interface_interpo_linear_type0
  use interface_grgrad_midpoint_r3rd_type0
  use interface_grgrad_midpoint_r4th_type0
  implicit none
  integer :: info
  integer :: ia, ib
  integer :: irg, itg, ipg
  real(long) :: fa23, diver
  real(long) :: alpgc, ainvh, cdivbv
  real(long) :: dbxdx, dbxdy, dbxdz, dbydx, dbydy, dbydz,dbzdx, dbzdy, dbzdz
  real(long),pointer :: dbvxdx(:,:,:), dbvxdy(:,:,:), dbvxdz(:,:,:)
  real(long),pointer :: dbvydx(:,:,:), dbvydy(:,:,:), dbvydz(:,:,:)
  real(long),pointer :: dbvzdx(:,:,:), dbvzdy(:,:,:), dbvzdz(:,:,:)
!
! --- Compute extringic curvature.  
! --- Whose value is assigned on the grid points. 
!
!test
  info = 0
!test
!
  fa23 = 2.0d0/3.0d0
!
  call alloc_array3d(dbvxdx, 0, nrg, 0, ntg, 0, npg)
  call alloc_array3d(dbvxdy, 0, nrg, 0, ntg, 0, npg)
  call alloc_array3d(dbvxdz, 0, nrg, 0, ntg, 0, npg)
  call alloc_array3d(dbvydx, 0, nrg, 0, ntg, 0, npg)
  call alloc_array3d(dbvydy, 0, nrg, 0, ntg, 0, npg)
  call alloc_array3d(dbvydz, 0, nrg, 0, ntg, 0, npg)
  call alloc_array3d(dbvzdx, 0, nrg, 0, ntg, 0, npg)
  call alloc_array3d(dbvzdy, 0, nrg, 0, ntg, 0, npg)
  call alloc_array3d(dbvzdz, 0, nrg, 0, ntg, 0, npg)
!
!  call grgrad_midpoint(bvxd,dbvxdx,dbvxdy,dbvxdz)
!  call grgrad_midpoint(bvyd,dbvydx,dbvydy,dbvydz)
!  call grgrad_midpoint(bvzd,dbvzdx,dbvzdy,dbvzdz)
!
  do ipg = 1, npg
    do itg = 1, ntg
      do irg = 1, nrg
!
        call grgrad_midpoint_r4th_type0(bvxd,dbxdx,dbxdy,dbxdz,irg,itg,ipg,'bh')
        dbvxdx(irg,itg,ipg) = dbxdx
        dbvxdy(irg,itg,ipg) = dbxdy
        dbvxdz(irg,itg,ipg) = dbxdz
        call grgrad_midpoint_r4th_type0(bvyd,dbydx,dbydy,dbydz,irg,itg,ipg,'bh')
        dbvydx(irg,itg,ipg) = dbydx
        dbvydy(irg,itg,ipg) = dbydy
        dbvydz(irg,itg,ipg) = dbydz
        call grgrad_midpoint_r4th_type0(bvzd,dbzdx,dbzdy,dbzdz,irg,itg,ipg,'bh')
        dbvzdx(irg,itg,ipg) = dbzdx
        dbvzdy(irg,itg,ipg) = dbzdy
        dbvzdz(irg,itg,ipg) = dbzdz

        call interpo_linear_type0(alpgc,alph,irg,itg,ipg)
        ainvh = 0.5d0/alpgc    ! 1/2\alpha
        cdivbv = dbvxdx(irg,itg,ipg) + dbvydy(irg,itg,ipg) &
               + dbvzdz(irg,itg,ipg)
        diver = fa23*cdivbv
!
! --  For rotating shift
!      
        tfkij(irg,itg,ipg,1,1) = ainvh*(2.0d0*dbvxdx(irg,itg,ipg) &
        - diver)
        tfkij(irg,itg,ipg,2,2) = ainvh*(2.0d0*dbvydy(irg,itg,ipg) & 
        - diver)
        tfkij(irg,itg,ipg,3,3) = ainvh*(2.0d0*dbvzdz(irg,itg,ipg) & 
        - diver)
        tfkij(irg,itg,ipg,1,2) = ainvh*(dbvydx(irg,itg,ipg) & 
        + dbvxdy(irg,itg,ipg))
        tfkij(irg,itg,ipg,1,3) = ainvh*(dbvzdx(irg,itg,ipg) & 
        + dbvxdz(irg,itg,ipg))
        tfkij(irg,itg,ipg,2,3) = ainvh*(dbvzdy(irg,itg,ipg) & 
        + dbvydz(irg,itg,ipg))
        tfkij(irg,itg,ipg,2,1) = tfkij(irg,itg,ipg,1,2)
        tfkij(irg,itg,ipg,3,1) = tfkij(irg,itg,ipg,1,3)
        tfkij(irg,itg,ipg,3,2) = tfkij(irg,itg,ipg,2,3)
! 
        tfkijkij(irg,itg,ipg) = 0.0d0
        do ib = 1, 3
          do ia = 1, 3
            tfkijkij(irg,itg,ipg) = tfkijkij(irg,itg,ipg) & 
            + tfkij(irg,itg,ipg,ia,ib)*tfkij(irg,itg,ipg,ia,ib)
          end do
        end do
!
        if (tfkijkij(irg,itg,ipg) /= 0.0d0) info = 1
!
      end do
    end do
  end do
!
  if (info /= 1) write(6,*) ' ### Warning K_ij = 0 *** '
  deallocate(dbvxdx)
  deallocate(dbvxdy)
  deallocate(dbvxdz)
  deallocate(dbvydx)
  deallocate(dbvydy)
  deallocate(dbvydz)
  deallocate(dbvzdx)
  deallocate(dbvzdy)
  deallocate(dbvzdz)
!
!!irg = nrg-3; itg = ntg/2; ipg = 2
!!write(6,*) 'shift sample'
!!write(6,*) bvxd(irg,itg,ipg), bvyd(irg,itg,ipg), bvzd(irg,itg,ipg)
!!write(6,*) 'excurve sample'
!!write(6,*) tfkij(irg,itg,ipg,1,1),tfkij(irg,itg,ipg,1,2),tfkij(irg,itg,ipg,1,3)
!!write(6,*) tfkij(irg,itg,ipg,2,1),tfkij(irg,itg,ipg,2,2),tfkij(irg,itg,ipg,2,3)
!!write(6,*) tfkij(irg,itg,ipg,3,1),tfkij(irg,itg,ipg,3,2),tfkij(irg,itg,ipg,3,3)
!!write(6,*) tfkijkij(irg,itg,ipg)
!
end subroutine excurve 
!
!##############################################
!##############################################
