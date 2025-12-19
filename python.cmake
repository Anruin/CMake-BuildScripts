# Check and install python3
execute_process(
        COMMAND python3 --version
        RESULT_VARIABLE PYTHON_EXIT_CODE
        OUTPUT_QUIET
        ERROR_QUIET
)

if (PYTHON_EXIT_CODE EQUAL 0)
    message(STATUS "python3 is installed and working.")
else ()
    message(STATUS "Attempting to install python...")

    execute_process(
            COMMAND apt update
            RESULT_VARIABLE APT_UPDATE_RESULT
            OUTPUT_VARIABLE APT_UPDATE_OUT
            ERROR_VARIABLE APT_UPDATE_ERR
            OUTPUT_STRIP_TRAILING_WHITESPACE
            ERROR_STRIP_TRAILING_WHITESPACE
    )

    execute_process(
            COMMAND apt install -y python3.10
            RESULT_VARIABLE APT_PYTHON_RESULT
            OUTPUT_VARIABLE APT_PYTHON_OUT
            ERROR_VARIABLE APT_PYTHON_ERR
            OUTPUT_STRIP_TRAILING_WHITESPACE
            ERROR_STRIP_TRAILING_WHITESPACE
    )

    message(STATUS "${APT_PYTHON_OUT}")
    if (NOT APT_PYTHON_RESULT EQUAL 0)
        message(WARNING "Failed to install python: ${APT_PYTHON_ERR}")
    endif ()
endif ()

# Check and install python venv module
execute_process(
        COMMAND python3.10 -m venv --help
        RESULT_VARIABLE VENV_CHECK_RESULT
        OUTPUT_QUIET
        ERROR_QUIET
)

if (VENV_CHECK_RESULT EQUAL 0)
    message(STATUS "python3.10 venv module is available.")
else ()
    message(STATUS "Attempting to install python venv module...")

    execute_process(
            COMMAND apt install -y python3.10-venv
            RESULT_VARIABLE APT_VENV_RESULT
            OUTPUT_VARIABLE APT_VENV_OUT
            ERROR_VARIABLE APT_VENV_ERR
            OUTPUT_STRIP_TRAILING_WHITESPACE
            ERROR_STRIP_TRAILING_WHITESPACE
    )

    message(STATUS "${APT_VENV_OUT}")
    if (NOT APT_VENV_RESULT EQUAL 0)
        message(WARNING "Failed to install python venv module: ${APT_VENV_ERR}")
    endif ()
endif ()