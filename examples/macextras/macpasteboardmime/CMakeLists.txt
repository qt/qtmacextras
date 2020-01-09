# Generated from macpasteboardmime.pro.

cmake_minimum_required(VERSION 3.14)
project(macpasteboardmime LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

set(INSTALL_EXAMPLEDIR "examples/macextras/macpasteboardmime")

find_package(Qt6 COMPONENTS Core)
find_package(Qt6 COMPONENTS Gui)
find_package(Qt6 COMPONENTS MacExtras)
find_package(Qt6 COMPONENTS Widgets)

add_qt_gui_executable(macpasteboardmime
    main.cpp
)
target_link_libraries(macpasteboardmime PUBLIC
    Qt::Core
    Qt::Gui
    Qt::MacExtras
    Qt::Widgets
)

install(TARGETS macpasteboardmime
    RUNTIME DESTINATION "${INSTALL_EXAMPLEDIR}"
    BUNDLE DESTINATION "${INSTALL_EXAMPLEDIR}"
    LIBRARY DESTINATION "${INSTALL_EXAMPLEDIR}"
)
