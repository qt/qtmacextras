TEMPLATE = app

OBJECTIVE_SOURCES += main.mm
HEADERS += window.h
SOURCES += window.cpp
LIBS += -framework Cocoa

QT += gui widgets 
QT += widgets-private gui-private core-private

DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0
