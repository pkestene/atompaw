add_library(atompaw "")

target_sources(atompaw
  PRIVATE
  libxc_tools.c
  io_tools.F90
  tools_mod.F90
  general_mod.F90
  globalmath.F90
  search_sort.F90
  input_dataset_mod.F90
  aeatom.F90
  anderson_driver.F90
  atomdata.F90
  blockdavidson_mod.F90
  excor.F90
  exx_mod.F90
  exx_pseudo.F90
  exxdata.F90
  fock.F90
  gridmod.F90
  hf_mod.F90
  hf_pseudo.F90
  interpolation_mod.F90
  ldagga_mod.F90
  libxc_mod.F90
  numerov_mod.F90
  paw_sub.F90
  pseudo_sub.F90
  pseudo.F90
  pseudodata.F90
  r2scanmod.F90
  radialdirac.F90
  radialked.F90
  splinesolver.F90
  radialsr.F90
  report_mod.F90
  abinitinterface.F90
  pwscfinterface.F90
  xmlinterface.F90
  atompaw_report.F90
  graphatom_report.F90)

configure_file(pkginfo.f90.cmake pkginfo.f90)

target_sources(atompaw
  PRIVATE
  ${CMAKE_CURRENT_BINARY_DIR}/pkginfo.f90)

if (Libxc_FOUND)
  target_link_libraries(atompaw
    PUBLIC
    Libxc::xc)
endif()

###########################
add_executable(atompaw_exe "")
target_sources(atompaw_exe
  PRIVATE
  atompaw_prog.F90)

if (CMAKE_VERSION VERSION_GREATER_EQUAL 3.18)
  target_link_libraries(atompaw_exe
    PRIVATE
    atompaw
    LAPACK::LAPACK)
else()
  target_link_libraries(atompaw_exe
    PRIVATE
    atompaw
    ${LAPACK_LIBRARIES})
endif()

if (Libxc_FOUND)
  target_link_libraries(atompaw_exe
    PRIVATE
    atompaw)
endif()


###########################
add_executable(graphatom "")
target_sources(graphatom
  PRIVATE
  graphatom.F90)

if (CMAKE_VERSION VERSION_GREATER_EQUAL 3.18)
  target_link_libraries(graphatom
    PRIVATE
    atompaw
    LAPACK::LAPACK)
else()
  target_link_libraries(graphatom
    PRIVATE
    atompaw
    ${LAPACK_LIBRARIES})
endif()

if (Libxc_FOUND)
  target_link_libraries(graphatom
    PRIVATE
    atompaw)
endif()

##########################################################################
#
# Generate CMake own package config file as well as and regular pkg-config
#
# and
#
# Install
#
##########################################################################

#
# Generate configs files
#

include(CMakePackageConfigHelpers)

# setup some variables
set(version_config ${PROJECT_BINARY_DIR}/atompaw-config-version.cmake)
set(project_config_src ${PROJECT_SOURCE_DIR}/src/atompaw-config.cmake.in)
set(project_config_dst ${PROJECT_BINARY_DIR}/src/atompaw-config.cmake)
set(targets_export_name atompaw-targets)

# important variables
set(INSTALL_LIBDIR ${CMAKE_INSTALL_LIBDIR} CACHE STRING
  "Installation directory for libraries, relative to ${CMAKE_INSTALL_PREFIX}.")

set(INSTALL_INCLUDEDIR ${CMAKE_INSTALL_INCLUDEDIR} CACHE STRING
  "Installation directory for include files, relative to ${CMAKE_INSTALL_PREFIX}.")

set(INSTALL_PKGCONFIG_DIR ${CMAKE_INSTALL_LIBDIR}/pkgconfig CACHE PATH
  "Installation directory for pkgconfig (.pc) files, relative to ${CMAKE_INSTALL_PREFIX}.")

set(INSTALL_CMAKE_DIR ${CMAKE_INSTALL_LIBDIR}/cmake CACHE STRING
  "Installation directory for cmake files, relative to ${CMAKE_INSTALL_PREFIX}.")

# generate pkg-config file
include(generate_pkg_config)
generate_pkg_config(atompaw)

# Generate the version, config and target files into the build directory.
write_basic_package_version_file(
  ${version_config}
  VERSION ${PROJECT_VERSION}
  COMPATIBILITY AnyNewerVersion)

# generate cmake my_package-config.cmake file
configure_package_config_file(
  ${project_config_src}
  ${project_config_dst}
  INSTALL_DESTINATION ${INSTALL_CMAKE_DIR})

#
# setup the list of targets to install
#
set (INSTALL_TARGETS atompaw)

# Use a namespace because CMake provides better diagnostics
# for namespaced imported targets.
export(
  TARGETS ${INSTALL_TARGETS} NAMESPACE atompaw::
  FILE ${PROJECT_BINARY_DIR}/${targets_export_name}.cmake)

#
# Install version, config and target files.
#
install(
  FILES ${project_config_dst} ${version_config}
  DESTINATION ${INSTALL_CMAKE_DIR})

install(
  EXPORT ${targets_export_name}
  DESTINATION ${INSTALL_CMAKE_DIR}
  NAMESPACE atompaw::)

#
# install the pkg-config file
#
install(
  FILES ${CMAKE_CURRENT_BINARY_DIR}/atompaw.pc
  DESTINATION "${INSTALL_PKGCONFIG_DIR}")

#
# Install binaries and library
#
install(
  TARGETS atompaw
  EXPORT ${targets_export_name}
  LIBRARY DESTINATION ${INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

# rename exe before install
set_target_properties(atompaw_exe PROPERTIES OUTPUT_NAME "atompaw")
install(TARGETS atompaw_exe
  RUNTIME)

install(TARGETS graphatom
  RUNTIME)
