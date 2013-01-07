TEMPLATE = app

include (../../src/qtmacextras.pri)

OBJECTIVE_SOURCES += main.mm
LIBS += -framework Cocoa

QT += gui widgets 
QT += widgets-private gui-private core-private

#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0
