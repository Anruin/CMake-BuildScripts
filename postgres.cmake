include(ExternalProject)
include("${CMAKE_SOURCE_DIR}/deps/meson.cmake")
include("${CMAKE_SOURCE_DIR}/deps/ninja.cmake")

if (CMAKE_SYSTEM_NAME STREQUAL "Windows")
    message(STATUS "postgres: Building for Windows/MSVC")
    if (CMAKE_BUILD_TYPE STREQUAL "Debug")
        set(_CFLAGS "/nologo /Od /Z7 /MDd /W3 /DWIN32 /D_CRT_SECURE_NO_WARNINGS")
    else ()
        set(_CFLAGS "/nologo /O2 /DNDEBUG /MD /W3 /DWIN32 /D_CRT_SECURE_NO_WARNINGS")
    endif ()
    set(POSTGRES_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/postgres_install")
    set(LIBPQ_LIBRARY "${POSTGRES_INSTALL_PREFIX}/lib/libpq.lib")
else ()
    message(STATUS "postgres: Building for Unix-like system")
    if (CMAKE_BUILD_TYPE STREQUAL "Debug")
        message(STATUS "postgres: Building in Debug mode")
        set(_CFLAGS "-O0 -g -fPIC")
    else ()
        message(STATUS "postgres: Building in Release mode")
        set(_CFLAGS "-O3 -fPIC")
    endif ()
    set(POSTGRES_INSTALL_PREFIX "/usr/local")
    set(LIBPQ_LIBRARY
            "${POSTGRES_INSTALL_PREFIX}/lib/x86_64-linux-gnu/libpq.a"
            "${POSTGRES_INSTALL_PREFIX}/lib/x86_64-linux-gnu/libpgcommon.a"
            "${POSTGRES_INSTALL_PREFIX}/lib/x86_64-linux-gnu/libpgport.a"
            "${POSTGRES_INSTALL_PREFIX}/lib/x86_64-linux-gnu/libpgtypes.a"
    )
endif ()

set(POSTGRES_GIT_REPO "https://github.com/postgres/postgres.git")
set(POSTGRES_GIT_TAG REL_16_11)
set(POSTGRES_INCLUDE_DIR "${POSTGRES_INSTALL_PREFIX}/include")

message(STATUS "${POSTGRES_INSTALL_PREFIX}")

ExternalProject_Add(
        postgres
        PREFIX "${CMAKE_BINARY_DIR}/postgres_src"
        GIT_REPOSITORY ${POSTGRES_GIT_REPO}
        GIT_TAG ${POSTGRES_GIT_TAG}
        GIT_SHALLOW 1
        CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${POSTGRES_INSTALL_PREFIX}
        -DCMAKE_C_FLAGS=${_CFLAGS}
        CONFIGURE_COMMAND ${CMAKE_COMMAND} -E chdir ${CMAKE_BINARY_DIR}/postgres_src/src/postgres ${MESON_EXECUTABLE} setup build --prefix ${POSTGRES_INSTALL_PREFIX} --buildtype=${MESON_BUILDTYPE} -Dssl=openssl
        BUILD_COMMAND ${CMAKE_COMMAND} -E chdir ${CMAKE_BINARY_DIR}/postgres_src/src/postgres ninja -C build
        INSTALL_COMMAND ${CMAKE_COMMAND} -E chdir ${CMAKE_BINARY_DIR}/postgres_src/src/postgres ninja -C build install
)

ExternalProject_Get_Property(postgres install_dir)
set(POSTGRES_ROOT_DIR ${install_dir})
