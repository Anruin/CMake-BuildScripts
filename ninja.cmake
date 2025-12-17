message(STATUS "Attempting to install ninja via apt...")

execute_process(
        COMMAND apt update
        RESULT_VARIABLE NINJA_RESULT
        OUTPUT_VARIABLE NINJA_OUT
        ERROR_VARIABLE NINJA_ERR
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_STRIP_TRAILING_WHITESPACE
)
message(STATUS "${NINJA_OUT}")
if (NOT NINJA_RESULT EQUAL 0)
    message(WARNING "Failed to update apt: ${NINJA_ERR}")
endif ()

execute_process(
        COMMAND apt install -y ninja-build
        RESULT_VARIABLE NINJA_RESULT
        OUTPUT_VARIABLE NINJA_OUT
        ERROR_VARIABLE NINJA_ERR
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_STRIP_TRAILING_WHITESPACE
)
message(STATUS "${NINJA_OUT}")
if (NOT NINJA_RESULT EQUAL 0)
    message(WARNING "Failed to install ninja: ${NINJA_ERR}")
endif ()

find_program(NINJA_EXECUTABLE NAMES ninja ninja-build)
message(STATUS "ninja: ${NINJA_EXECUTABLE}")