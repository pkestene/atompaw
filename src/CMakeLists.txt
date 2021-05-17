add_library(libatompaw "")

target_sources(libatompaw
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
  radialdirac.F90
  radialsr.F90
  report_mod.F90
  abinitinterface.F90
  pwscfinterface.F90
  xmlinterface.F90
  atompaw_report.F90
  graphatom_report.F90)

configure_file(pkginfo.f90.cmake pkginfo.f90)

target_sources(libatompaw
  PRIVATE
  ${CMAKE_CURRENT_BINARY_DIR}/pkginfo.f90)

###########################
add_executable(atompaw "")
target_sources(atompaw
  PRIVATE
  atompaw_prog.F90)

if (CMAKE_VERSION VERSION_GREATER_EQUAL 3.18)
  target_link_libraries(atompaw
    PRIVATE
    libatompaw
    LAPACK::LAPACK)
else()
  target_link_libraries(atompaw
    PRIVATE
    libatompaw
    ${LAPACK_LIBRARIES})
endif()

###########################
add_executable(graphatom "")
target_sources(graphatom
  PRIVATE
  graphatom.F90)

if (CMAKE_VERSION VERSION_GREATER_EQUAL 3.18)
  target_link_libraries(graphatom
    PRIVATE
    libatompaw
    LAPACK::LAPACK)
else()
  target_link_libraries(graphatom
    PRIVATE
    libatompaw
    ${LAPACK_LIBRARIES})
endif()

#
# Install
#
install(TARGETS atompaw graphatom
  RUNTIME)
