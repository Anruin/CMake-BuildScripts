include(ExternalProject)

if (CMAKE_SYSTEM_NAME STREQUAL "Windows")
    message(STATUS "libpqxx: Building for Windows/MSVC")
    if (CMAKE_BUILD_TYPE STREQUAL "Debug")
        set(_CFLAGS "/nologo /Od /Z7 /MDd /W3 /I src /DWIN32 /D_CRT_SECURE_NO_WARNINGS")
    else ()
        set(_CFLAGS "/nologo /O2 /DNDEBUG /MD /W3 /I src /DWIN32 /D_CRT_SECURE_NO_WARNINGS")
    endif ()
    set(LIBPQXX_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/libpqxx_install")
    set(LIBPQXX_LIBRARY "${LIBPQXX_INSTALL_PREFIX}/lib/libpqxx.lib")
else ()
    message(STATUS "libpqxx: Building for Unix-like system")
    if (CMAKE_BUILD_TYPE STREQUAL "Debug")
        message(STATUS "libpqxx: Building in Debug mode")
        set(_CFLAGS "-O0 -g -fPIC")
    else ()
        message(STATUS "libpqxx: Building in Release mode")
        set(_CFLAGS "-O3 -fPIC")
    endif ()
    set(LIBPQXX_INSTALL_PREFIX "/usr/local")
    set(LIBPQXX_LIBRARY "${LIBPQXX_INSTALL_PREFIX}/lib/libpqxx.a")
endif ()

set(LIBPQXX_INCLUDE_DIR "${LIBPQXX_INSTALL_PREFIX}/include")
set(LIBPQXX_GIT_REPO "https://github.com/jtv/libpqxx.git")
set(LIBPQXX_GIT_TAG 7.10.4)

ExternalProject_Add(
        libpqxx
        PREFIX "${CMAKE_BINARY_DIR}/libpqxx_src"
        GIT_REPOSITORY ${LIBPQXX_GIT_REPO}
        GIT_TAG ${LIBPQXX_GIT_TAG}
        GIT_SHALLOW 1
        CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=${LIBPQXX_INSTALL_PREFIX} # Installation directory
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} # Build type
        -DCMAKE_C_FLAGS=${_CFLAGS} # C flags
        -DPostgreSQL_ROOT=${LIBPQ_INCLUDE_DIR} # Path to libpq (PostgreSQL) includes
)