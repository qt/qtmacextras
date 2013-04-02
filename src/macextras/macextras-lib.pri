INCLUDEPATH += $$PWD

PUBLIC_HEADERS += \
    $$PWD/qtmacfunctions.h \
    $$PWD/qtmacnativewidget.h \
    $$PWD/qtmactoolbardelegate.h \
    $$PWD/qtmactoolbutton.h \
    $$PWD/qtmacunifiedtoolbar.h  \
    $$PWD/qtnstoolbar.h

macx:!ios {
    OBJECTIVE_SOURCES += \
        $$PWD/qtmacfunctions.mm \
        $$PWD/qtmacnativewidget.mm \
        $$PWD/qtmactoolbardelegate.mm \
        $$PWD/qtmactoolbutton.mm \
        $$PWD/qtmacunifiedtoolbar.mm \
        $$PWD/qtnstoolbar.mm

    LIBS *= -framework AppKit
} else {
    SOURCES += $$PWD/qtmacunifiedtoolbar.cpp
}

macx:!ios:greaterThan(QT_MAJOR_VERSION, 4) {
    HEADERS += $$PWD/qmacpasteboardmime.h
    OBJECTIVE_SOURCES += $$PWD/qmacpasteboardmime.mm
}

HEADERS += $$PUBLIC_HEADERS
