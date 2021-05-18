set (MY_PACKAGE_NAME_PREFIX "")

include(CheckIncludeFile)
include(CheckIncludeFiles)

CHECK_INCLUDE_FILE(dlfcn.h ${MY_PACKAGE_NAME_PREFIX}HAVE_DLFCN_H)
CHECK_INCLUDE_FILE(inttypes.h ${MY_PACKAGE_NAME_PREFIX}HAVE_INTTYPES_H)
CHECK_INCLUDE_FILE(memory.h ${MY_PACKAGE_NAME_PREFIX}HAVE_MEMORY_H)
CHECK_INCLUDE_FILE(stdint.h ${MY_PACKAGE_NAME_PREFIX}HAVE_STDINT_H)
#CHECK_INCLUDE_FILE_CXX(cstdint ${MY_PACKAGE_NAME_PREFIX}HAVE_CSTDINT)
CHECK_INCLUDE_FILE(stdlib.h ${MY_PACKAGE_NAME_PREFIX}HAVE_STDLIB_H)
CHECK_INCLUDE_FILE(strings.h ${MY_PACKAGE_NAME_PREFIX}HAVE_STRINGS_H)
CHECK_INCLUDE_FILE(string.h ${MY_PACKAGE_NAME_PREFIX}HAVE_STRING_H)
CHECK_INCLUDE_FILE(sys/stat.h ${MY_PACKAGE_NAME_PREFIX}HAVE_SYS_STAT_H)
CHECK_INCLUDE_FILE(sys/types.h ${MY_PACKAGE_NAME_PREFIX}HAVE_SYS_TYPES_H)
CHECK_INCLUDE_FILE(unistd.h ${MY_PACKAGE_NAME_PREFIX}HAVE_UNISTD_H)

#/* Define to 1 if you have the ANSI C header files. */
check_include_files("stdlib.h;stdarg.h;string.h;float.h" ${MY_PACKAGE_NAME_PREFIX}_STDC_HEADERS)

# ??
if(CMAKE_Fortran_COMPILER_ID STREQUAL Absoft)
  set(FC_ABSOFT 1)
endif()

# ??
if(CMAKE_Fortran_COMPILER_ID STREQUAL Cray)
  set(FC_CRAY 1)
endif()

# flang
if(CMAKE_Fortran_COMPILER_ID STREQUAL Flang)
  set(FC_FLANG 1)
endif()

# g95
if(CMAKE_Fortran_COMPILER_ID STREQUAL G95)
  set(FC_G95 1)
endif()

# gfortran
if(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
  set(FC_GNU 1)
endif()

# ifc
if(CMAKE_Fortran_COMPILER_ID STREQUAL Intel)
  set(FC_INTEL 1)
endif()

# ??
if(CMAKE_Fortran_COMPILER_ID STREQUAL IntelLLVM)
  set(FC_INTEL_LLVM 1)
endif()

# nvfortran
if(CMAKE_Fortran_COMPILER_ID STREQUAL NVHPC)
  set(FC_NVHPC 1)
endif()

# pgfortran
if(CMAKE_Fortran_COMPILER_ID STREQUAL PGI)
  set(FC_PGI 1)
endif()

# ?? does-it still exist ?
if(CMAKE_Fortran_COMPILER_ID STREQUAL PathScale)
  set(FC_PATHSCALE 1)
endif()

# xfc
if(CMAKE_Fortran_COMPILER_ID STREQUAL XL)
  set(FC_XL 1)
  set(FC_IBM 1)
endif()

# ??
if(CMAKE_Fortran_COMPILER_ID STREQUAL XLClang)
  set(FC_XL_CLANG 1)
endif()

# exchange-correlation library found ?
if(Libxc_FOUND)
  set(HAVE_LIBXC 1)
endif()

# check for iso_c_binding support
try_compile(
  HAVE_FC_ISO_C_BINDING
  "${CMAKE_CURRENT_BINARY_DIR}/try_compile"
  "${CMAKE_SOURCE_DIR}/cmake/iso_c_binding/check.f90")

message(" Generating config.h ...")
configure_file(config.h.cmake config.h @ONLY)
