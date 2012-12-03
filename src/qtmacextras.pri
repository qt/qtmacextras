QT += widgets gui-private
INCLUDEPATH += $$PWD
DEPENDPATH += $$PWD

# qtmacunifiedtoolbar
HEADERS += $$PWD/qtmacunifiedtoolbar.h  \
           $$PWD/qtmactoolbardelegate.h \
           $$PWD/qtmactoolbutton.h \
           $$PWD/qtmacfunctions.h

mac {
    OBJECTIVE_SOURCES += $$PWD/qtmacunifiedtoolbar.mm \
                         $$PWD/qtmactoolbardelegate.mm \
                         $$PWD/qtmactoolbutton.mm \
                         $$PWD/qtmacfunctions.mm

    LIBS *= -framework AppKit
}
