CONFIG += testcase console
CONFIG -= app_bundle
TARGET = tst_qtmacfunctions
QT += macextras widgets testlib
OBJECTIVE_SOURCES += tst_qtmacfunctions.mm
LIBS *= -framework AppKit
