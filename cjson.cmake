include(ExternalProject)

#region cJSON

if (CMAKE_BUILD_TYPE STREQUAL "Debug")
  message(STATUS "cJSON: Building in Debug mode")
  set(CJSON_C_FLAGS "-O0 -g -mavx -mavx2 -ftree-vectorize -march=native")
else ()
  message(STATUS "cJSON: Building in Release mode")
  set(CJSON_C_FLAGS "-O3 -mavx -mavx2 -ftree-vectorize -march=native")
endif ()

ExternalProject_Add(
    cJSON
    PREFIX /usr/local/src/cJSON # Install source code to this directory
    GIT_REPOSITORY git@github.com:DaveGamble/cJSON.git
    GIT_TAG v1.7.18
    CMAKE_ARGS
    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
    -DCMAKE_INSTALL_PREFIX=/usr/local
    -DBUILD_SHARED_AND_STATIC_LIBS=ON
    -DCMAKE_C_FLAGS=${CJSON_C_FLAGS}
    -DENABLE_CJSON_TEST=OFF
    BUILD_COMMAND cmake --build . --config ${CMAKE_BUILD_TYPE}
)

ExternalProject_Get_Property(cJSON install_dir)
set(CJSON_ROOT_DIR ${install_dir})
set(CJSON_INCLUDE_DIR /usr/local/include)
set(CJSON_LIBRARY /usr/local/lib/libcjson.a)

#endregion