program check_iso_c_binding

use iso_c_binding
implicit none
integer(c_int) :: ii
logical :: lbool
type(c_ptr) :: ptr
ptr = c_null_ptr
lbool = c_associated(ptr)

end program
