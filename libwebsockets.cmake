include(ExternalProject)

#region websockets

if (CMAKE_BUILD_TYPE STREQUAL "Debug")
  message(STATUS "libwebsockets: Building in Debug mode")
  set(LIBWEBSOCKETS_C_FLAGS "-O0 -g -mavx -mavx2 -ftree-vectorize -march=native -fPIC")
else ()
  message(STATUS "libwebsockets: Building in Release mode")
  set(LIBWEBSOCKETS_C_FLAGS "-O3 -mavx -mavx2 -ftree-vectorize -march=native -fPIC")
endif ()

#set(ENV{LD_LIBRARY_PATH} "${OPENSSL_LIBRARY_DIR};$ENV{LD_LIBRARY_PATH}")

ExternalProject_Add(
    libwebsockets
    PREFIX /usr/local/src/libwebsockets # Install source code to this directory
    GIT_REPOSITORY https://github.com/warmcat/libwebsockets.git
    GIT_TAG v4.3.3
    INSTALL_DIR /usr/local
    CMAKE_ARGS
    -DCMAKE_INSTALL_PREFIX=/usr/local # Install to this directory
    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} # Build type
    -DCMAKE_C_FLAGS=${LIBWEBSOCKETS_C_FLAGS} # C Flags
    -DOPENSSL_ROOT_DIR=/usr/local/src/openssl/
    -DOPENSSL_CRYPTO_LIBRARY=${OPENSSL_CRYPTO_LIBRARY}
    -DOPENSSL_SSL_LIBRARY=${OPENSSL_SSL_LIBRARY}
    -DOPENSSL_INCLUDE_DIR=${OPENSSL_INCLUDE_DIR}
    -DOPENSSL_EXECUTABLE=${OPENSSL_EXECUTABLE}
    -DLWS_HAVE_HMAC_CTX_new=ON
    -DLWS_HAVE_EVP_MD_CTX_free=ON
    -DLWS_LIBUV_INCLUDE_DIRS=${LIBUV_INCLUDE_DIR}
    -DLWS_LIBUV_LIBRARIES=${LIBUV_LIBRARY}
    -DLWS_WITH_LIBUV=1
    -DLIBCAP_LIBRARIES=${LIBCAP_LIBRARY}
    -DLWS_WITHOUT_TESTAPPS=ON # Don't build test apps
    -DLWS_MAX_SMP=8 # Maximum number of threads
    -DLWS_WITHOUT_TESTAPPS=ON # Don't build test apps
    -DLWS_WITH_EVLIB_PLUGINS=OFF # Disable shared plugin API
    -DLWS_WITH_SHARED=ON # Disable shared library
)

ExternalProject_Get_Property(libwebsockets install_dir)

set(LIBWEBSOCKETS_INSTALL_DIR ${install_dir})
set(LIBWEBSOCKETS_INCLUDE_DIR /usr/local/include)
set(LIBWEBSOCKETS_LIBRARY /usr/local/lib/libwebsockets.a)

#endregion
