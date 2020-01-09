# Generated from mactoolbar.pro.

cmake_minimum_required(VERSION 3.14)
project(mactoolbar LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

set(INSTALL_EXAMPLEDIR "examples/macextras/mactoolbar")

find_package(Qt6 COMPONENTS Core)
find_package(Qt6 COMPONENTS Gui)
find_package(Qt6 COMPONENTS MacExtras)

add_qt_gui_executable(mactoolbar
    main.cpp
    rasterwindow.cpp rasterwindow.h
    toolbarcontrollerwindow.cpp toolbarcontrollerwindow.h
)
target_link_libraries(mactoolbar PUBLIC
    Qt::Core
    Qt::Gui
    Qt::MacExtras
)


# Resources:
set(mactoolbar_resource_files
    "qtlogo.png"
)

qt6_add_resources(mactoolbar "mactoolbar"
    PREFIX
        "/"
    FILES
        ${mactoolbar_resource_files}
)

install(TARGETS mactoolbar
    RUNTIME DESTINATION "${INSTALL_EXAMPLEDIR}"
    BUNDLE DESTINATION "${INSTALL_EXAMPLEDIR}"
    LIBRARY DESTINATION "${INSTALL_EXAMPLEDIR}"
)
