cmake_minimum_required(VERSION 3.10)
project(test-ci VERSION 0.1)

find_package(PkgConfig QUIET REQUIRED)
pkg_check_modules(GTK3 gtk+-3.0)

add_executable(test-ci
    test-ci.c)

add_executable(gtk 
    gtk.c)

target_include_directories(gtk PRIVATE ${GTK3_INCLUDE_DIRS})
target_link_libraries(gtk PRIVATE ${GTK3_LIBRARIES})
install(TARGETS test-ci gtk DESTINATION bin)
if(MINGW)
    add_subdirectory(ntldd)
    configure_file(mingw.cmake.in mingw.cmake @ONLY)

    install(SCRIPT ${CMAKE_CURRENT_BINARY_DIR}/mingw.cmake)
endif()
