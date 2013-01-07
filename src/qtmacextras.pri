QT += widgets gui-private
INCLUDEPATH += $$PWD
DEPENDPATH += $$PWD

# QtMacUnifiedToolBar
HEADERS += $$PWD/qtmacunifiedtoolbar.h  \
           $$PWD/qtmactoolbardelegate.h \
           $$PWD/qtmactoolbutton.h \
           $$PWD/qtnstoolbar.h

mac {
    OBJECTIVE_SOURCES += $$PWD/qtmacunifiedtoolbar.mm \
                         $$PWD/qtmactoolbardelegate.mm \
                         $$PWD/qtmactoolbutton.mm \
                         $$PWD/qtnstoolbar.mm

    LIBS *= -framework AppKit
} else {
    SOURCES += $$PWD/qtmacunifiedtoolbar.cpp
}

# QtMacPasteboardMime
HEADERS += $$PWD/qmacpasteboardmime.h
OBJECTIVE_SOURCES += $$PWD/qmacpasteboardmime.mm

# qt_mac_set_dock_menu
HEADERS += $$PWD/qtmacfunctions.h
OBJECTIVE_SOURCES += $$PWD/qtmacfunctions.mm

minQtVersion(5, 0, 1) {
    HEADERS += $$PWD/qtmacfunctions.h
    OBJECTIVE_SOURCES += $$PWD/qtmacfunctions.mm
} else {
    message("qt_mac_set_dock_menu requires Qt 5.0.1 and will be exculded from this build. You have Qt" $$QT_VERSION)
}

# QtMacNativeWidget
HEADERS += $$PWD/qtmacnativewidget.h
OBJECTIVE_SOURCES += $$PWD/qtmacnativewidget.mm
