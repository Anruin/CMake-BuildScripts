# deps/simdjson.cmake

set(SIMDJSON_SINGLEHEADER_DIR "${CMAKE_SOURCE_DIR}/src/vendor/simdjson_singleheader")
set(SIMDJSON_HEADER_URL "https://raw.githubusercontent.com/simdjson/simdjson/master/singleheader/simdjson.h")
set(SIMDJSON_CPP_URL "https://raw.githubusercontent.com/simdjson/simdjson/master/singleheader/simdjson.cpp")

if (NOT EXISTS ${SIMDJSON_SINGLEHEADER_DIR})
    message(STATUS "Creating directory for simdjson single-header files: ${SIMDJSON_SINGLEHEADER_DIR}")
    file(MAKE_DIRECTORY ${SIMDJSON_SINGLEHEADER_DIR})
endif ()

if (NOT EXISTS ${SIMDJSON_SINGLEHEADER_DIR}/simdjson.h)
    file(DOWNLOAD ${SIMDJSON_HEADER_URL}
            ${SIMDJSON_SINGLEHEADER_DIR}/simdjson.h
            SHOW_PROGRESS
            STATUS status_header
    )
endif ()

if (NOT EXISTS ${SIMDJSON_SINGLEHEADER_DIR}/simdjson.cpp)
    file(DOWNLOAD ${SIMDJSON_CPP_URL}
            ${SIMDJSON_SINGLEHEADER_DIR}/simdjson.cpp
            SHOW_PROGRESS
            STATUS status_cpp
    )
endif ()

set(SIMDJSON_INCLUDE_DIR ${SIMDJSON_SINGLEHEADER_DIR})
set(SIMDJSON_SRC ${SIMDJSON_SINGLEHEADER_DIR}/simdjson.cpp)
