QT += widgets gui-private
INCLUDEPATH += $$PWD
DEPENDPATH += $$PWD

OBJECTS_DIR = .obj
MOC_DIR = .moc

# minQtVersion from qtcreator.pri
defineTest(minQtVersion) {
    maj = $$1
    min = $$2
    patch = $$3
    isEqual(QT_MAJOR_VERSION, $$maj) {
        isEqual(QT_MINOR_VERSION, $$min) {
            isEqual(QT_PATCH_VERSION, $$patch) {
                return(true)
            }
            greaterThan(QT_PATCH_VERSION, $$patch) {
                return(true)
            }
        }
        greaterThan(QT_MINOR_VERSION, $$min) {
            return(true)
        }
    }
    greaterThan(QT_MAJOR_VERSION, $$maj) {
        return(true)
    }
    return(false)
}

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
mac:minQtVersion(5, 0, 0) {
    HEADERS += $$PWD/qmacpasteboardmime.h
    OBJECTIVE_SOURCES += $$PWD/qmacpasteboardmime.mm
}

# qt_mac_set_dock_menu
HEADERS += $$PWD/qtmacfunctions.h
OBJECTIVE_SOURCES += $$PWD/qtmacfunctions.mm

# QtMacNativeWidget
HEADERS += $$PWD/qtmacnativewidget.h
OBJECTIVE_SOURCES += $$PWD/qtmacnativewidget.mm

# QMacCocoaViewContainer
HEADERS += $$PWD/qtmaccocoaviewcontainer.h
OBJECTIVE_SOURCES += $$PWD/qtmaccocoaviewcontainer.mm
