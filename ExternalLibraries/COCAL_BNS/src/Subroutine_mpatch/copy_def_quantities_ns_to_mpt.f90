subroutine copy_def_quantities_ns_to_mpt(impt)
  use def_quantities_ns
  use def_quantities_ns_mpt
  implicit none
  integer :: i, impt
!
  i=0
  i=i+1; def_quantities_ns_(i,impt) = AHarea
  i=i+1; def_quantities_ns_(i,impt) = AHmass
  i=i+1; def_quantities_ns_(i,impt) = AHspin
!
end subroutine copy_def_quantities_ns_to_mpt
