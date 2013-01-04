include (../../src/qtmacextras.pri)

QT += core gui
greaterThan(QT_MAJOR_VERSION, 4):QT += widgets

SOURCES += \
    main.cpp \
    preferenceswindow.cpp \
    window.cpp

HEADERS += \
    preferenceswindow.h \
    window.h

FORMS += \
    preferenceswindow.ui \
    window.ui

RESOURCES += \
    macunifiedtoolbar.qrc

ICON = qtlogo.icns
