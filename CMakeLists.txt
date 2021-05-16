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
