# Check ninja and install if missing
find_program(NINJA_EXECUTABLE NAMES ninja ninja-build)

if(NOT NINJA_EXECUTABLE)
    message(STATUS "Ninja not found. Attempting to install via apt...")

    execute_process(
            COMMAND sudo apt update
            RESULT_VARIABLE UPDATE_RESULT
            ERROR_QUIET
    )

    execute_process(
            COMMAND sudo apt install -y ninja-build
            RESULT_VARIABLE INSTALL_RESULT
            OUTPUT_VARIABLE INSTALL_OUT
            ERROR_VARIABLE INSTALL_ERR
    )

    if(INSTALL_RESULT EQUAL 0)
        message(STATUS "Ninja installed successfully.")
        find_program(NINJA_EXECUTABLE NAMES ninja ninja-build)
    else()
        message(WARNING "Failed to install ninja. Error: ${INSTALL_ERR}")
    endif()
else()
    message(STATUS "Ninja already installed: ${NINJA_EXECUTABLE}")
endif()