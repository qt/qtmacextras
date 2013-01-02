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
