include(ExternalProject)

#region libuv

if (CMAKE_SYSTEM_NAME STREQUAL "Windows")
    message(STATUS "libuv: Building for Windows/MSVC")
    if (CMAKE_BUILD_TYPE STREQUAL "Debug")
        set(_CFLAGS "/nologo /Od /Z7 /MDd /W3 /I src /D_WIN32 /D_CRT_SECURE_NO_WARNINGS")
    else ()
        set(_CFLAGS "/nologo /O2 /DNDEBUG /MD /W3 /I src /D_WIN32 /D_CRT_SECURE_NO_WARNINGS")
    endif ()
    set(LIBUV_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/libuv_install")
    set(LIBUV_LIBRARY "${LIBUV_INSTALL_PREFIX}/lib/libuv.lib")
else ()
    message(STATUS "libuv: Building for Unix-like system")
    if (CMAKE_BUILD_TYPE STREQUAL "Debug")
        message(STATUS "libuv: Building in Debug mode")
        set(_CFLAGS "-O0 -g -mavx -mavx2 -ftree-vectorize -march=native -fPIC")
    else ()
        message(STATUS "libuv: Building in Release mode")
        set(_CFLAGS "-O3 -mavx -mavx2 -ftree-vectorize -march=native -fPIC")
    endif ()
    set(LIBUV_INSTALL_PREFIX "/usr/local")
    set(LIBUV_LIBRARY "${LIBUV_INSTALL_PREFIX}/lib/libuv.a")
endif ()

set(LIBUV_INCLUDE_DIR "${LIBUV_INSTALL_PREFIX}/include")
set(LIBUV_GIT_REPO "https://github.com/libuv/libuv.git")
set(LIBUV_GIT_TAG v1.48.0)

ExternalProject_Add(
        libuv
        PREFIX "${CMAKE_BINARY_DIR}/libuv_src"
        GIT_REPOSITORY ${LIBUV_GIT_REPO}
        GIT_TAG ${LIBUV_GIT_TAG}
        GIT_SHALLOW 1
        CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=${LIBUV_INSTALL_PREFIX} # Installation directory
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} # Build type
        -DCMAKE_C_FLAGS=${_CFLAGS} # C flags
        -DLIBUV_BUILD_TESTS=0 # Don't build tests
)

ExternalProject_Get_Property(libuv install_dir)
set(LIBUV_ROOT_DIR ${install_dir})

#endregion