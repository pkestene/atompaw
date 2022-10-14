# actually prefer using 3.18 to have nice lapack imported target
cmake_minimum_required(VERSION 3.13)

project(ATOMPAW
  LANGUAGES C Fortran
  VERSION 4.2.0.1
  HOMEPAGE_URL https://github.com/atompaw/atompaw
  DESCRIPTION "Electronic structure calculations (Density-Functional Theory) based on the Projector Augmented-Wave (PAW) method")

# export compiles commands to json (for LSP)
set(CMAKE_EXPORT_COMPILE_COMMANDS on)

# subdirectory cmake contains useful macros
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

# setup build type (Release / Debug)
include(set_default_build_type)
set_default_build_type()

# prevent build in place
include(prevent_build_in_place)

# gnu compatibility,
# see https://cmake.org/cmake/help/latest/module/GNUInstallDirs.html
include(GNUInstallDirs)

# see https://cmake.org/cmake/help/latest/command/find_package.html
find_package(PkgConfig REQUIRED)

# external dependencies
find_package(LAPACK REQUIRED)

#
# Libxc
# 1. use cmake find_package
# 2. use pkg-config
#
find_package(Libxc)
if (Libxc_FOUND)
  message("Libxc found via cmake target")
  set(Libxc_FOUND_with_cmake TRUE)
else()
  pkg_check_modules(ATOMPAW_LIBXC QUIET IMPORTED_TARGET libxc)
  if(ATOMPAW_LIBXC_FOUND)
    message("Libxc found via pkg-config")
    set(Libxc_FOUND TRUE)
    add_library(Libxc::xc ALIAS PkgConfig::ATOMPAW_LIBXC)
    set(Libxc_FOUND_with_pkgconfig TRUE)
  endif()
endif()

# setup libxc name for optionnal substitution in pkgconfig
if (Libxc_FOUND)
  set(Libxc_Optional libxc)
endif()

# set default Fortran compile flags
include(compilers)

# Generate config.h
include(generate_config_h)

# for compatibility with autotools,
# make sure symbol HAVE_CONFIG_H is defined
add_compile_definitions(HAVE_CONFIG_H)

# make sure config.h is found
add_compile_options(-I${CMAKE_BINARY_DIR})

#
# add sources
#

add_subdirectory(src)

#
# Install documentation and examples
#

# Files to distribute in the source package
install(
  DIRECTORY example
  DESTINATION ${CMAKE_INSTALL_PREFIX}/share/doc/atompaw
  FILES_MATCHING
  PATTERN "*.atomicdata"
  PATTERN "*.input"
  PATTERN "*.UPF"
  PATTERN "*paw.abinit"
  PATTERN "in"
  PATTERN "Au"
  REGEX "explore" EXCLUDE
  REGEX "hf_bessel" EXCLUDE
  )

install(
  FILES
  doc/atompaw-usersguide.pdf
  doc/atompaw-usersguide.doc
  doc/ATOMPAW_Explore_Userguide.pdf
  doc/ATOMPAW_Explore_Userguide.odt
  DESTINATION ${CMAKE_INSTALL_PREFIX}/share/doc/atompaw/doc)

install(
  FILES
  doc/exploresetup/ParameterExplore.cpp
  doc/exploresetup/ParameterExploreReadMe.txt
  DESTINATION ${CMAKE_INSTALL_PREFIX}/share/doc/atompaw/doc/exploresetup)

install(
  FILES
  doc/scripts/explorelogderiv
  doc/scripts/explorewfn
  doc/scripts/plotdensity
  doc/scripts/plotlogderiv
  doc/scripts/plotpotential
  doc/scripts/plotwfn
  DESTINATION ${CMAKE_INSTALL_PREFIX}/share/doc/atompaw/doc/scripts)




##################### PRINT CONFIGURE STATUS ######################
message("//===================================================")
message("// ${PROJECT_NAME} build configuration:")
message("// ${PROJECT_NAME} version : ${PROJECT_VERSION}")
message("//===================================================")
message("  CMake version          : ${CMAKE_VERSION}")
if (NOT CMAKE_BUILD_TYPE)
  message("  CMake build type       : NOT SET !")
else()
  message("  CMake build type       : ${CMAKE_BUILD_TYPE}")
endif()
message("  CMake install prefix   : ${CMAKE_INSTALL_PREFIX}")
message("  CMake system processor : ${CMAKE_SYSTEM_PROCESSOR}")
message("  CMake system name (OS) : ${CMAKE_SYSTEM_NAME}")
message("")
message("  Fortran compiler Id  : ${CMAKE_Fortran_COMPILER_ID} ${CMAKE_Fortran_COMPILER_VERSION}")
message("  Fortran compiler exe :${CMAKE_Fortran_COMPILER}")
message("  Fortran flags        : ${CMAKE_Fortran_FLAGS}")
message("")

# see https://cmake.org/cmake/help/v3.20/module/FindLAPACK.html
# for an up to data list of possible value for BLA_VENDOR
# If you want to change blas/lapack implementation to
# e.g. OpenBLAS
# just add "-DBLA_VENDOR=OpenBLAS"
# You may need to modify CMAKE_PREFIX_PATH to specify your OpenBLAS
# custom installation
message(STATUS "Lapack config:")
message("    Lapack/blas vendor : ${BLA_VENDOR}")
message("    Lapack found       : ${LAPACK_FOUND}")
message("    Lapack headers     : ${LAPACK_HEADER} in ${LAPACK_INCLUDE_DIR}")
message("    Lapack libraries   : ${LAPACK_LIBRARIES}")
message("")
message(STATUS "Libxc config:")
if(Libxc_FOUND_with_cmake)
  message("    Libxc found        : ${Libxc_FOUND}")
  message("    Libxc version      : ${Libxc_VERSION}")
  message("    Libxc headers      : ${Libxc_INCLUDE_DIRS}")
  message("    Libxc libraries    : ${Libxc_LIBRARIES}")
else()
  message("    Libxc found        : ${ATOMPAW_LIBXC_FOUND}")
  message("    Libxc version      : ${ATOMPAW_LIBXC_VERSION}")
  message("    Libxc headers      : ${ATOMPAW_LIBXC_CFLAGS}")
  message("    Libxc libraries    : ${ATOMPAW_LIBXC_LDFLAGS}")
endif()
