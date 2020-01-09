# Generated from macfunctions.pro.

cmake_minimum_required(VERSION 3.14)
project(macfunctions LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

set(INSTALL_EXAMPLEDIR "examples/macextras/macfunctions")

find_package(Qt6 COMPONENTS Core)
find_package(Qt6 COMPONENTS Gui)
find_package(Qt6 COMPONENTS Widgets)
find_package(Qt6 COMPONENTS MacExtras)

add_qt_gui_executable(macfunctions
    main.cpp
)
target_include_directories(macfunctions PUBLIC
    .
)

target_link_libraries(macfunctions PUBLIC
    Qt::Core
    Qt::Gui
    Qt::MacExtras
    Qt::Widgets
)


# Resources:
set(macfunctions_resource_files
    "qtlogo.png"
)

qt6_add_resources(macfunctions "macfunctions"
    PREFIX
        "/"
    FILES
        ${macfunctions_resource_files}
)

install(TARGETS macfunctions
    RUNTIME DESTINATION "${INSTALL_EXAMPLEDIR}"
    BUNDLE DESTINATION "${INSTALL_EXAMPLEDIR}"
    LIBRARY DESTINATION "${INSTALL_EXAMPLEDIR}"
)
