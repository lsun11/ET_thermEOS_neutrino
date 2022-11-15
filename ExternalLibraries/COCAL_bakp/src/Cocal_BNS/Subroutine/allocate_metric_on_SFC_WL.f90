subroutine allocate_metric_on_SFC_WL
  use grid_parameter, only : nrf, ntf, npf
  use def_metric_on_SFC_CF
  use def_metric_on_SFC_WL
  use make_array_3d
  implicit none
!
  call alloc_array3d(psif, 0, nrf, 0, ntf, 0, npf)
  call alloc_array3d(alphf, 0, nrf, 0, ntf, 0, npf)
  call alloc_array3d(bvxdf, 0, nrf, 0, ntf, 0, npf)
  call alloc_array3d(bvydf, 0, nrf, 0, ntf, 0, npf)
  call alloc_array3d(bvzdf, 0, nrf, 0, ntf, 0, npf)
  call alloc_array3d(bvxuf, 0, nrf, 0, ntf, 0, npf)
  call alloc_array3d(bvyuf, 0, nrf, 0, ntf, 0, npf)
  call alloc_array3d(bvzuf, 0, nrf, 0, ntf, 0, npf)
  call alloc_array3d(hxxdf, 0, nrf, 0, ntf, 0, npf)
  call alloc_array3d(hxydf, 0, nrf, 0, ntf, 0, npf)
  call alloc_array3d(hxzdf, 0, nrf, 0, ntf, 0, npf)
  call alloc_array3d(hyydf, 0, nrf, 0, ntf, 0, npf)
  call alloc_array3d(hyzdf, 0, nrf, 0, ntf, 0, npf)
  call alloc_array3d(hzzdf, 0, nrf, 0, ntf, 0, npf)
  call alloc_array3d(hxxuf, 0, nrf, 0, ntf, 0, npf)
  call alloc_array3d(hxyuf, 0, nrf, 0, ntf, 0, npf)
  call alloc_array3d(hxzuf, 0, nrf, 0, ntf, 0, npf)
  call alloc_array3d(hyyuf, 0, nrf, 0, ntf, 0, npf)
  call alloc_array3d(hyzuf, 0, nrf, 0, ntf, 0, npf)
  call alloc_array3d(hzzuf, 0, nrf, 0, ntf, 0, npf)
!
end subroutine allocate_metric_on_SFC_WL
