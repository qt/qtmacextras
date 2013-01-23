QT += widgets gui-private
INCLUDEPATH += $$PWD
DEPENDPATH += $$PWD

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
minQtVersion(5, 0, 0) {
    HEADERS += $$PWD/qmacpasteboardmime.h
    mac:OBJECTIVE_SOURCES += $$PWD/qmacpasteboardmime.mm
}

isEqual(QT_VERSION, 5.0.0) {
    # Show a warning message for Qt 5.0 - QMacPasteboardMime is part of QtGui in Qt 4, and available in 5.0.1 onwards
    message("QMacPasteboardMime requires Qt 5.0.1. You have Qt $${QT_VERSION} and can still compile in the functionality but it will not be usable unless the linked Qt libraries meet the required minimum version.")
}

# Miscellaneous interop/utility functions
HEADERS += $$PWD/qtmacfunctions.h
mac:OBJECTIVE_SOURCES += $$PWD/qtmacfunctions.mm
