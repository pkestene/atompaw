# actually prefer using 3.18 to have nice lapack imported target
cmake_minimum_required(VERSION 3.13)

project(ATOMPAW
  LANGUAGES C Fortran
  VERSION 4.1.1.0
  HOMEPAGE_URL https://github.com/atompaw/atompaw
  DESCRIPTION "Electronic structure calculations (Density-Functional Theory) based on the Projector Augmented-Wave (PAW) method")

set(CMAKE_EXPORT_COMPILE_COMMANDS on)

# gnu compatibility,
# see https://cmake.org/cmake/help/latest/module/GNUInstallDirs.html
include(GNUInstallDirs)

# external dependencies
find_package(LAPACK REQUIRED)
find_package(Libxc)

# set default Fortran compile flags
include(cmake/compilers.cmake)

# Generate config.h
include(cmake/generate_config_h.cmake)

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
message("  Fortran Compiler : ${CMAKE_Fortran_COMPILER_ID} ")
message("                   : ${CMAKE_Fortran_COMPILER}")
message("")

# see https://cmake.org/cmake/help/v3.20/module/FindLAPACK.html
# for an up to data list of possible value for BLA_VENDOR
# If you want to change blas/lapack implementation to
# e.g. OpenBLAS
# just add "-DBLA_VENDOR=OpenBLAS"
# You may need to modify CMAKE_PREFIX_PATH to specify your OpenBLAS
# custom installation
message("Basic Linear Algebra vendor : ${BLA_VENDOR}")
message("Lapack found     : ${LAPACK_FOUND}")
message("Lapack libraries : ${LAPACK_LIBRARIES}")
message("")
message("Libxc found      : ${Libxc_FOUND}")
message("Libxc version    : ${Libxc_VERSION}")
message("Libxc inc dirs   : ${Libxc_INCLUDE_DIRS}")
message("Libxc libraries  : ${Libxc_LIBRARIES}")
