include(ExternalProject)

#region uWebSockets

if (CMAKE_SYSTEM_NAME STREQUAL "Windows")
    message(STATUS "uwebsockets: Building for Windows/MSVC")

    set(UWEBSOCKETS_EXTRA_INCLUDE_DIRS "${CMAKE_BINARY_DIR}/libuv_install/include")

    set(UWEBSOCKETS_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/uwebsockets_install")
    set(UWEBSOCKETS_LIBRARY "${UWEBSOCKETS_INSTALL_PREFIX}/lib/uSockets.lib")

    set(_UWS_SOURCE_DIR "${CMAKE_BINARY_DIR}/uwebsockets_src/src/uwebsockets")
    set(_USOCKETS_DIR "${_UWS_SOURCE_DIR}/uSockets")

    set(_EXTRA_INC_FLAGS "")
    foreach (dir IN LISTS UWEBSOCKETS_EXTRA_INCLUDE_DIRS)
        if (dir)
            list(APPEND _EXTRA_INC_FLAGS " /I ${dir}")
        endif ()
    endforeach ()
    string(JOIN " " _EXTRA_INC_FLAGS_STR "${_EXTRA_INC_FLAGS}")

    if (CMAKE_BUILD_TYPE STREQUAL "Debug")
        set(_USOCKETS_CFLAGS "/nologo /Od /Z7 /MDd /W3 /I src /D_WIN32 /D_CRT_SECURE_NO_WARNINGS ${_EXTRA_INC_FLAGS_STR}")
    else ()
        set(_USOCKETS_CFLAGS "/nologo /O2 /DNDEBUG /MD /W3 /I src /D_WIN32 /D_CRT_SECURE_NO_WARNINGS ${_EXTRA_INC_FLAGS_STR}")
    endif ()

    set(_USOCKETS_DEFINES "/D LIBUS_NO_SSL /D LIBUS_USE_LIBUV")

    set(UWEBSOCKETS_BUILD_COMMAND
            ${CMAKE_COMMAND} -E echo "Building uSockets (Windows)" &&
            ${CMAKE_COMMAND} -E chdir ${_USOCKETS_DIR} cmd /C "cl ${_USOCKETS_CFLAGS} ${_USOCKETS_DEFINES} /c src\\*.c src\\eventing\\*.c src\\crypto\\*.c && lib /nologo /OUT:uSockets.lib *.obj"
    )

    set(UWEBSOCKETS_INSTALL_COMMAND
            ${CMAKE_COMMAND} -E make_directory ${UWEBSOCKETS_INSTALL_PREFIX}/include &&
            ${CMAKE_COMMAND} -E make_directory ${UWEBSOCKETS_INSTALL_PREFIX}/include/uwebsockets/uSockets &&
            ${CMAKE_COMMAND} -E make_directory ${UWEBSOCKETS_INSTALL_PREFIX}/lib &&
            ${CMAKE_COMMAND} -E copy_directory ${_UWS_SOURCE_DIR}/src ${UWEBSOCKETS_INSTALL_PREFIX}/include/uwebsockets &&
            ${CMAKE_COMMAND} -E copy_directory ${_USOCKETS_DIR}/src ${UWEBSOCKETS_INSTALL_PREFIX}/include/uwebsockets/uSockets &&
            ${CMAKE_COMMAND} -E copy ${_USOCKETS_DIR}/uSockets.lib ${UWEBSOCKETS_LIBRARY}
    )
else ()
    message(STATUS "uwebsockets: Building for Unix-like system")

    if (CMAKE_BUILD_TYPE STREQUAL "Debug")
        set(UWEBSOCKETS_C_FLAGS "-O0 -g -mavx -mavx2 -ftree-vectorize -march=native -fPIC")
    else ()
        set(UWEBSOCKETS_C_FLAGS "-O3 -mavx -mavx2 -ftree-vectorize -march=native -fPIC")
    endif ()

    set(UWEBSOCKETS_INSTALL_PREFIX "/usr/local")
    set(USOCKETS_LIBRARY "${UWEBSOCKETS_INSTALL_PREFIX}/lib/uSockets.a")

    # Build and install uSockets static library
    set(UWEBSOCKETS_BUILD_COMMAND cd ${CMAKE_BINARY_DIR}/uwebsockets_src/src/uwebsockets/uSockets && WITH_ZLIB=1 WITH_LIBUV=1 WITH_OPENSSL=1 make)
    set(UWEBSOCKETS_INSTALL_COMMAND ${CMAKE_COMMAND} -E make_directory ${UWEBSOCKETS_INSTALL_PREFIX}/include &&
            ${CMAKE_COMMAND} -E make_directory ${UWEBSOCKETS_INSTALL_PREFIX}/include/uwebsockets/uSockets &&
            ${CMAKE_COMMAND} -E make_directory ${UWEBSOCKETS_INSTALL_PREFIX}/lib &&
            ${CMAKE_COMMAND} -E copy_directory ${CMAKE_BINARY_DIR}/uwebsockets_src/src/uwebsockets/src ${UWEBSOCKETS_INSTALL_PREFIX}/include/uwebsockets &&
            ${CMAKE_COMMAND} -E copy_directory ${CMAKE_BINARY_DIR}/uwebsockets_src/src/uwebsockets/uSockets/src ${UWEBSOCKETS_INSTALL_PREFIX}/include/uwebsockets/uSockets &&
            ${CMAKE_COMMAND} -E copy ${CMAKE_BINARY_DIR}/uwebsockets_src/src/uwebsockets/uSockets/uSockets.a ${USOCKETS_LIBRARY})
endif ()

set(UWEBSOCKETS_INCLUDE_DIR "${UWEBSOCKETS_INSTALL_PREFIX}/include")
set(UWEBSOCKETS_GIT_REPO "https://github.com/uNetworking/uWebSockets.git")
set(UWEBSOCKETS_GIT_TAG "v20.66.0")

ExternalProject_Add(
        uwebsockets
        PREFIX "${CMAKE_BINARY_DIR}/uwebsockets_src"
        GIT_REPOSITORY ${UWEBSOCKETS_GIT_REPO}
        GIT_TAG ${UWEBSOCKETS_GIT_TAG}
        GIT_SHALLOW 1
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ${UWEBSOCKETS_BUILD_COMMAND}
        INSTALL_COMMAND ${UWEBSOCKETS_INSTALL_COMMAND}
)

ExternalProject_Get_Property(uwebsockets install_dir)
set(UWEBSOCKETS_ROOT_DIR ${install_dir})

#endregion
