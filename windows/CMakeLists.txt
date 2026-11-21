cmake_minimum_required(VERSION 4.5)

set(CMAKE_C_STANDARD 23)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_SCAN_FOR_MODULES ON)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

project(winedirectalsawindows LANGUAGES C CXX)

add_library(winedirectalsa SHARED
        src/dllmain.cpp
        src/CASIO.cpp
        src/CASIOClassFactory.cpp
        src/ALSABackend.cpp
        src/wine_unixlib.c
        src/WDA.cpp
        src/winedirectalsa.def
)

target_sources(winedirectalsa
        PRIVATE FILE_SET modules TYPE CXX_MODULES FILES
        src/globals.cppm
        src/CASIOClassFactory.cppm
        src/CASIO.cppm
        src/ALSABackend.cppm
        src/asio.cppm

        PUBLIC FILE_SET pub TYPE CXX_MODULES FILES
        src/WDA.cppm
)

add_custom_command(
        TARGET winedirectalsa
        POST_BUILD
        COMMAND winebuild --builtin "$<TARGET_FILE:winedirectalsa>"
)

target_include_directories(winedirectalsa
        PRIVATE /usr/include/wine
        PRIVATE /opt/wine-devel/include/wine
        PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../common
)

target_link_libraries(winedirectalsa
        PRIVATE /usr/lib/wine/x86_64-windows/libwinecrt0.a
        PRIVATE ntdll
        PRIVATE winmm
)

install(
        TARGETS winedirectalsa
        RUNTIME DESTINATION x86_64-windows
)

add_executable(wdactrl WIN32
        src/wdactrl/winmain.cpp
        src/wdactrl/control.rc
)

target_include_directories(wdactrl
        PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../common
)

target_link_libraries(wdactrl PRIVATE winedirectalsa)

install(
        TARGETS wdactrl
        RUNTIME DESTINATION x86_64-windows
)
