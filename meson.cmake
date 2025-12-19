# Try to find Meson build system, and if not found, install it via pip
# Include ~/.local/bin to search paths as pip --user installs there
find_program(MESON_EXECUTABLE NAMES meson
        PATHS $ENV{HOME}/.local/bin /usr/bin /usr/local/bin)

if(NOT MESON_EXECUTABLE)
    message(STATUS "Meson not found. Attempting to install via pip...")

    find_package(Python3 COMPONENTS Interpreter REQUIRED)

    execute_process(
            COMMAND ${Python3_EXECUTABLE} -m pip install --user meson
            RESULT_VARIABLE MESON_INSTALL_RESULT
            OUTPUT_VARIABLE MESON_OUT
            ERROR_VARIABLE MESON_ERR
    )

    if(MESON_INSTALL_RESULT EQUAL 0)
        message(STATUS "Meson installed successfully via pip.")
        find_program(MESON_EXECUTABLE NAMES meson
                PATHS $ENV{HOME}/.local/bin /usr/bin /usr/local/bin)
    else()
        message(FATAL_ERROR "Failed to install meson: ${MESON_ERR}")
    endif()
else()
    message(STATUS "Meson already installed: ${MESON_EXECUTABLE}")
endif()

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

message(STATUS "Meson build type set to: ${MESON_BUILDTYPE}")