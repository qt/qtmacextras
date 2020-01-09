# Generated from mactoolbar.pro.

#####################################################################
## mactoolbar Binary:
#####################################################################

qt_add_manual_test(mactoolbar
    GUI
    SOURCES
        main.cpp
        toolbarcontrollerwidget.cpp toolbarcontrollerwidget.h
    PUBLIC_LIBRARIES
        Qt::Gui
        Qt::MacExtras
        Qt::Widgets
)

# Resources:
set(mactoolbar_resource_files
    "qtlogo.png"
)

qt_add_resource(mactoolbar "mactoolbar"
    PREFIX
        "/"
    FILES
        ${mactoolbar_resource_files}
)

