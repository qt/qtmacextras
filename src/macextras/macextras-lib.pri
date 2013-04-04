INCLUDEPATH += $$PWD

mac {
    PUBLIC_HEADERS += $$PWD/qtmacfunctions.h
    OBJECTIVE_SOURCES += $$PWD/qtmacfunctions.mm
}

macx:!ios {
    PUBLIC_HEADERS += \
        $$PWD/qtmaccocoaviewcontainer.h \
        $$PWD/qtmacnativewidget.h \
        $$PWD/qtmactoolbutton.h \
        $$PWD/qtmacunifiedtoolbar.h

    PRIVATE_HEADERS += \
        $$PWD/qtmactoolbardelegate.h \
        $$PWD/qtnstoolbar.h

    OBJECTIVE_SOURCES += \
        $$PWD/qtmaccocoaviewcontainer.mm \
        $$PWD/qtmacnativewidget.mm \
        $$PWD/qtmactoolbardelegate.mm \
        $$PWD/qtmactoolbutton.mm \
        $$PWD/qtmacunifiedtoolbar.mm \
        $$PWD/qtnstoolbar.mm

    greaterThan(QT_MAJOR_VERSION, 4) {
        PUBLIC_HEADERS += $$PWD/qmacpasteboardmime.h
        OBJECTIVE_SOURCES += $$PWD/qmacpasteboardmime.mm
    }

    LIBS *= -framework AppKit
} else {
    SOURCES += $$PWD/qtmacunifiedtoolbar.cpp
}

HEADERS += $$PUBLIC_HEADERS $$PRIVATE_HEADERS
