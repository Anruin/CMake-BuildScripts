include(ExternalProject)

#region OpenSSL

if (CMAKE_SYSTEM_NAME STREQUAL "Windows")
    message(STATUS "libopenssl: Building for Windows/MSVC")

    set(OPENSSL_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/openssl_install")

    set(ZLIB_ROOT "${CMAKE_BINARY_DIR}/zlib_install")
    set(ZLIB_INCLUDE_DIR "${ZLIB_ROOT}/include")
    if (CMAKE_BUILD_TYPE STREQUAL "Debug")
        set(ZLIB_LIBRARY "${ZLIB_ROOT}/lib/zlibstaticd.lib")
    else ()
        set(ZLIB_LIBRARY "${ZLIB_ROOT}/lib/zlibstatic.lib")
    endif ()

    set(OPENSSL_EXTRA_INCLUDE_DIRS "${ZLIB_INCLUDE_DIR}")
    set(_EXTRA_INC_FLAGS "")
    foreach (dir IN LISTS OPENSSL_EXTRA_INCLUDE_DIRS)
        if (dir)
            list(APPEND _EXTRA_INC_FLAGS " /I ${dir}")
        endif ()
    endforeach ()
    string(JOIN " " _EXTRA_INC_FLAGS_STR "${_EXTRA_INC_FLAGS}")

    if (NOT IS_ABSOLUTE "${OPENSSL_INSTALL_PREFIX}")
        message(FATAL_ERROR "OPENSSL_INSTALL_PREFIX must be an absolute path!")
    endif ()
    if (CMAKE_SIZEOF_VOID_P EQUAL 8)
        message(STATUS "Detected 64-bit architecture")
        set(OPENSSL_LIBRARY_DIR "${OPENSSL_INSTALL_PREFIX}/lib64")
        set(OPENSSL_CONFIGURE_COMMAND
                ${CMAKE_COMMAND} -E echo "Creating install dir..."
                COMMAND ${CMAKE_COMMAND} -E make_directory "${OPENSSL_INSTALL_PREFIX}"
                COMMAND ${CMAKE_COMMAND} -E echo "Running OpenSSL Configure..."
                COMMAND perl "${CMAKE_BINARY_DIR}/openssl_src/src/openssl/Configure" VC-WIN64A --prefix=${OPENSSL_INSTALL_PREFIX} --openssldir=${OPENSSL_INSTALL_PREFIX} shared zlib threads --with-zlib-include=${CMAKE_BINARY_DIR}/zlib_install/include --with-zlib-lib=${ZLIB_INCLUDE_DIR} --with-zlib-lib=${ZLIB_LIBRARY}
        )
    else ()
        message(STATUS "Detected 32-bit architecture")
        set(OPENSSL_LIBRARY_DIR "${OPENSSL_INSTALL_PREFIX}/lib")
        set(OPENSSL_CONFIGURE_COMMAND
                ${CMAKE_COMMAND} -E echo "Creating install dir..."
                COMMAND ${CMAKE_COMMAND} -E make_directory "${OPENSSL_INSTALL_PREFIX}"
                COMMAND ${CMAKE_COMMAND} -E echo "Running OpenSSL Configure..."
                COMMAND perl "${CMAKE_BINARY_DIR}/openssl_src/src/openssl/Configure" VC-WIN32 --prefix=${OPENSSL_INSTALL_PREFIX} --openssldir=${OPENSSL_INSTALL_PREFIX} shared zlib threads --with-zlib-include=${CMAKE_BINARY_DIR}/zlib_install/include --with-zlib-lib=${ZLIB_INCLUDE_DIR} --with-zlib-lib=${ZLIB_LIBRARY}
        )
    endif ()
    message(STATUS "Using OpenSSL install prefix: ${OPENSSL_INSTALL_PREFIX}")
    message(STATUS "Using OpenSSL configure command: ${OPENSSL_CONFIGURE_COMMAND}")
    message(STATUS "Using OpenSSL build command: ${OPENSSL_BUILD_COMMAND}")
    set(OPENSSL_BUILD_COMMAND
            ${CMAKE_COMMAND} -E echo "Building OpenSSL..."
            COMMAND ${CMAKE_COMMAND} -E chdir "${CMAKE_BINARY_DIR}/openssl_src/src/openssl-build"
            ${CMAKE_COMMAND} -E env CL=${_EXTRA_INC_FLAGS_STR} nmake
    )
    set(OPENSSL_INSTALL_COMMAND
            ${CMAKE_COMMAND} -E echo "Installing OpenSSL..."
            COMMAND ${CMAKE_COMMAND} -E chdir "${CMAKE_BINARY_DIR}/openssl_src/src/openssl-build"
            nmake install_sw
    )
    set(OPENSSL_CRYPTO_LIBRARY "${OPENSSL_LIBRARY_DIR}/libcrypto.lib")
    set(OPENSSL_SSL_LIBRARY "${OPENSSL_LIBRARY_DIR}/libssl.lib")
else ()
    message(STATUS "libopenssl: Building for Unix-like system")
    set(OPENSSL_INSTALL_PREFIX "/usr/local")
    if (CMAKE_SIZEOF_VOID_P EQUAL 8)
        message(STATUS "Detected 64-bit architecture")
        set(OPENSSL_LIBRARY_DIR "${OPENSSL_INSTALL_PREFIX}/lib64")
    else ()
        message(STATUS "Detected 32-bit architecture")
        set(OPENSSL_LIBRARY_DIR "${OPENSSL_INSTALL_PREFIX}/lib")
    endif ()
    set(OPENSSL_CRYPTO_LIBRARY "${OPENSSL_LIBRARY_DIR}/libcrypto.a")
    set(OPENSSL_SSL_LIBRARY "${OPENSSL_LIBRARY_DIR}/libssl.a")
    set(OPENSSL_CONFIGURE_COMMAND /usr/local/src/openssl/src/openssl/Configure
            --prefix=${OPENSSL_INSTALL_PREFIX}
            --openssldir=${OPENSSL_INSTALL_PREFIX}
            shared zlib threads)
endif ()

set(OPENSSL_INCLUDE_DIR "${OPENSSL_INSTALL_PREFIX}/include")

set(OPENSSL_GIT_REPO "https://github.com/openssl/openssl.git")
set(OPENSSL_GIT_TAG "openssl-3.2.0")

ExternalProject_Add(
        openssl
        PREFIX ${CMAKE_BINARY_DIR}/openssl_src
        GIT_REPOSITORY ${OPENSSL_GIT_REPO}
        GIT_TAG ${OPENSSL_GIT_TAG}
        GIT_SHALLOW 1
        CONFIGURE_COMMAND ${OPENSSL_CONFIGURE_COMMAND}
        BUILD_COMMAND ${OPENSSL_BUILD_COMMAND}
        INSTALL_COMMAND ${OPENSSL_INSTALL_COMMAND}
)

#endregion
