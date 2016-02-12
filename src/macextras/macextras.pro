include($$PWD/macextras-lib.pri)

QT_PRIVATE += gui-private core-private
TARGET = QtMacExtras
load(qt_module)
QMAKE_DOCS = $$PWD/doc/qtmacextras.qdocconf
