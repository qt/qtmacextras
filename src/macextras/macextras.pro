TARGET = QtMacExtras

QT_PRIVATE += gui-private core-private

include($$PWD/macextras-lib.pri)

QMAKE_DOCS = $$PWD/doc/qtmacextras.qdocconf

CONFIG += no_app_extension_api_only

load(qt_module)
