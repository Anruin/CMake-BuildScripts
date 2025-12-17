find_package(Python3 COMPONENTS Interpreter REQUIRED)

message(STATUS "Attempting to install meson via pip...")

execute_process(
        COMMAND ${Python3_EXECUTABLE} -m pip install --user meson
        RESULT_VARIABLE MESON_PIP_RESULT
        OUTPUT_VARIABLE MESON_PIP_OUT
        ERROR_VARIABLE MESON_PIP_ERR
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_STRIP_TRAILING_WHITESPACE
)
message(STATUS "${MESON_PIP_OUT}")
if (NOT MESON_PIP_RESULT EQUAL 0)
    message(WARNING "Failed to install meson via pip: ${MESON_PIP_ERR}")
endif ()

find_program(MESON_EXECUTABLE NAMES meson PATHS $ENV{HOME}/.local/bin /usr/bin /usr/local/bin)
message(STATUS "meson: ${MESON_EXECUTABLE}")

if (CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(MESON_BUILDTYPE debug)
elseif (CMAKE_BUILD_TYPE STREQUAL "Release")
    set(MESON_BUILDTYPE release)
elseif (CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo")
    set(MESON_BUILDTYPE debugoptimized)
elseif (CMAKE_BUILD_TYPE STREQUAL "MinSizeRel")
    set(MESON_BUILDTYPE minsize)
else()
    set(MESON_BUILDTYPE plain)
endif()
