mark_as_advanced(
  CMAKE_OSX_ARCHITECTURES
  CMAKE_OSX_DEPLOYMENT_TARGET
  CMAKE_OSX_SYSROOT)

if (CMAKE_OSX_DEPLOYMENT_TARGET AND
    CMAKE_OSX_DEPLOYMENT_TARGET VERSION_LESS "10.7")
  message(FATAL_ERROR "Minimum OS X deployment target is 10.7, please update CMAKE_OSX_DEPLOYMENT_TARGET.")
endif ()
