include(ExternalProject)

#region Zlib

if (CMAKE_SYSTEM_NAME STREQUAL "Windows")
    message(STATUS "zlib: Building for Windows/MSVC")
    set(ZLIB_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/zlib_install")
    set(ZLIB_LIBRARY "${ZLIB_INSTALL_PREFIX}/lib/zlib.lib")
else ()
    message(STATUS "zlib: Building for Unix-like system")
    if (CMAKE_BUILD_TYPE STREQUAL "Debug")
        set(ZLIB_C_FLAGS "-O0 -g -mavx -mavx2 -ftree-vectorize -march=native")
    else ()
        set(ZLIB_C_FLAGS "-O3 -mavx -mavx2 -ftree-vectorize -march=native")
    endif ()
    set(ZLIB_INSTALL_PREFIX "/usr/local")
    set(ZLIB_LIBRARY "${ZLIB_INSTALL_PREFIX}/lib/libz.a")
endif ()

set(ZLIB_INCLUDE_DIR "${ZLIB_INSTALL_PREFIX}/include")
set(ZLIB_GIT_REPO "https://github.com/madler/zlib.git")
set(ZLIB_GIT_TAG v1.3.1)

ExternalProject_Add(
        zlib
        PREFIX "${CMAKE_BINARY_DIR}/zlib_src"
        GIT_REPOSITORY ${ZLIB_GIT_REPO}
        GIT_TAG ${ZLIB_GIT_TAG}
        GIT_SHALLOW 1
        CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=${ZLIB_INSTALL_PREFIX}
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_C_FLAGS=${ZLIB_C_FLAGS}
        -DZLIB_BUILD_EXAMPLES=0
        BUILD_COMMAND ${ZLIB_BUILD_COMMAND}
        INSTALL_COMMAND ${ZLIB_INSTALL_COMMAND}
)

ExternalProject_Get_Property(zlib install_dir)
set(ZLIB_ROOT_DIR ${install_dir})

#endregion
