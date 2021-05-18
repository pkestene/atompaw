# --- abi check

if(NOT abi_ok)
  message(CHECK_START "checking that C and Fortran compilers can link")
  try_compile(abi_ok ${CMAKE_CURRENT_BINARY_DIR}/abi_check ${CMAKE_CURRENT_LIST_DIR}/abi_check abi_check)
  if(abi_ok)
    message(CHECK_PASS "OK")
  else()
    message(FATAL ERROR "C compiler {CMAKE_C_COMPILER_ID} {CMAKE_C_COMPILER_VERSION} and Fortran compiler ${CMAKE_Fortran_COMPILER_ID} ${CMAKE_Fortran_COMPILER_VERSION} are ABI-incompatible.")
  endif()
endif()

# --- compiler check

if(CMAKE_Fortran_COMPILER_ID STREQUAL Intel)
  if(WIN32)
    string(APPEND CMAKE_Fortran_FLAGS " /QxHost /warn /heap-arrays")
  else()
    string(APPEND CMAKE_Fortran_FLAGS " -xHost -warn -heap-arrays")
  endif()
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
  string(APPEND CMAKE_Fortran_FLAGS " -mtune=native ")
endif()
