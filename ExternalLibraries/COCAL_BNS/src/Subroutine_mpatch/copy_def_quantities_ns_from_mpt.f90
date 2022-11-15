subroutine copy_def_quantities_ns_from_mpt(impt)
  use def_quantities_ns
  use def_quantities_ns_mpt
  implicit none
  integer :: i, impt
!
  i=0
  i=i+1; AHarea = def_quantities_ns_(i,impt)
  i=i+1; AHmass = def_quantities_ns_(i,impt)
  i=i+1; AHspin = def_quantities_ns_(i,impt)
!
end subroutine copy_def_quantities_ns_from_mpt
