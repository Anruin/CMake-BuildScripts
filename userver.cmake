include(ExternalProject)

if (CMAKE_SYSTEM_NAME STREQUAL "Windows")
    message(STATUS "userver: Building for Windows/MSVC")
    if (CMAKE_BUILD_TYPE STREQUAL "Debug")
        set(_CFLAGS "/nologo /Od /Z7 /MDd /W3 /DWIN32 /D_CRT_SECURE_NO_WARNINGS")
    else ()
        set(_CFLAGS "/nologo /O2 /DNDEBUG /MD /W3 /DWIN32 /D_CRT_SECURE_NO_WARNINGS")
    endif ()
    set(USERVER_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/userver_install")
    set(USERVER_LIBRARY "${USERVER_INSTALL_PREFIX}/lib/userver.lib")
else ()
    message(STATUS "userver: Building for Unix-like system")
    if (CMAKE_BUILD_TYPE STREQUAL "Debug")
        message(STATUS "userver: Building in Debug mode")
        set(_CFLAGS "-O0 -g -fPIC")
    else ()
        message(STATUS "userver: Building in Release mode")
        set(_CFLAGS "-O3 -fPIC")
    endif ()
    set(USERVER_INSTALL_PREFIX "/usr/local")
    set(USERVER_LIBRARY "${USERVER_INSTALL_PREFIX}/lib/libuserver.a")
endif ()

set(USERVER_INCLUDE_DIR "${USERVER_INSTALL_PREFIX}/include")
set(USERVER_GIT_REPO "https://github.com/userver-framework/userver.git")
set(USERVER_GIT_TAG v2.13)

ExternalProject_Add(
        userver
        PREFIX "${CMAKE_BINARY_DIR}/userver_src"
        GIT_REPOSITORY ${USERVER_GIT_REPO}
        GIT_TAG ${USERVER_GIT_TAG}
        GIT_SHALLOW 1
        CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=${USERVER_INSTALL_PREFIX} # Installation directory
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} # Build type
        -DCMAKE_C_FLAGS=${_CFLAGS} # C flags
)

message(STATUS "USERVER_INCLUDE_DIR: ${USERVER_INCLUDE_DIR}")
