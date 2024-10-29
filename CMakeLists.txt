cmake_minimum_required(VERSION 3.10)
project(test-ci VERSION 0.1)
add_executable(test-ci
    test-ci.c)
install(TARGETS test-ci DESTINATION bin)
if(MINGW)
    add_subdirectory(ntldd)
    configure_file(mingw.cmake.in mingw.cmake @ONLY)

    install(SCRIPT ${CMAKE_CURRENT_BINARY_DIR}/mingw.cmake)
endif()
