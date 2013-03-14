QT       += testlib

TARGET = tst_qtmacfunctions
CONFIG   += console
CONFIG   -= app_bundle

TEMPLATE = app

include (../../../src/qtmacextras.pri)

OBJECTIVE_SOURCES += $$PWD/tst_qtmacfunctions.mm
LIBS *= -framework AppKit
