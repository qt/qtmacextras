# Generated from embeddedqwindow.pro.

cmake_minimum_required(VERSION 3.14)
project(embeddedqwindow LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

set(INSTALL_EXAMPLEDIR "examples/macextras/embeddedqwindow")

find_package(Qt6 COMPONENTS Core)
find_package(Qt6 COMPONENTS Gui)
find_package(Qt6 COMPONENTS Widgets)
find_package(Qt6 COMPONENTS MacExtras)

add_qt_gui_executable(embeddedqwindow
    main.mm
    window.cpp window.h
)
target_link_libraries(embeddedqwindow PRIVATE
    Qt::CorePrivate
    Qt::GuiPrivate
    Qt::WidgetsPrivate
)

target_link_libraries(embeddedqwindow PUBLIC
    "-framework Cocoa"
    Qt::Core
    Qt::Gui
    Qt::MacExtras
    Qt::Widgets
)

install(TARGETS embeddedqwindow
    RUNTIME DESTINATION "${INSTALL_EXAMPLEDIR}"
    BUNDLE DESTINATION "${INSTALL_EXAMPLEDIR}"
    LIBRARY DESTINATION "${INSTALL_EXAMPLEDIR}"
)
