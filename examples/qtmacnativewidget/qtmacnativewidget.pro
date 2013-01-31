TEMPLATE = app

include (../../src/qtmacextras.pri)

OBJECTIVE_SOURCES += main.mm
LIBS += -framework Cocoa

QT += gui widgets
QT += widgets-private gui-private core-private
