Scripts used to download and build some libraries as dependencies for Windows/Unix. Can be used as reference or start point for others.

Notice that uwebsockets doesn't have CMakeLists, so custom steps are defined. Same for simdjson, which is header-only library.

For example, include in the main CMakeLists.txt as:

include(${CMAKE_SOURCE_DIR}/deps/zlib.cmake)
include(${CMAKE_SOURCE_DIR}/deps/openssl.cmake)
include(${CMAKE_SOURCE_DIR}/deps/libuv.cmake)
include(${CMAKE_SOURCE_DIR}/deps/uwebsockets.cmake)
include(${CMAKE_SOURCE_DIR}/deps/simdjson.cmake)

