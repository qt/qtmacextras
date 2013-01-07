TEMPLATE = app
TARGET = macfunctions
DEPENDPATH += .
INCLUDEPATH += .
QT += widgets

include (../../src/qtmacextras.pri)

# Input
SOURCES += main.cpp

RESOURCES += \
    macfunctions.qrc
