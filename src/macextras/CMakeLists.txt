# Generated from macextras.pro.

#####################################################################
## MacExtras Module:
#####################################################################

qt_add_module(MacExtras
    SOURCES
        qmacfunctions.h qmacfunctions.mm qmacfunctions_p.h
    INCLUDE_DIRECTORIES
        ${CMAKE_CURRENT_SOURCE_DIR}
    LIBRARIES
        ${FWFoundation}
        Qt::CorePrivate
        Qt::GuiPrivate
    PUBLIC_LIBRARIES
        Qt::Core
        Qt::Gui
)

## Scopes:
#####################################################################

qt_extend_target(MacExtras CONDITION APPLE_UIKIT AND NOT APPLE_WATCHOS
    SOURCES
        qmacfunctions_ios.mm
    LIBRARIES
        ${FWUIKit}
)

qt_extend_target(MacExtras CONDITION APPLE_OSX
    SOURCES
        qmacfunctions_mac.mm
        qmactoolbar.mm
        qmactoolbardelegate.mm
        qmactoolbaritem.mm
        qnstoolbar.mm
    LIBRARIES
        ${FWAppKit}
        Qt::Widgets
)

#### Keys ignored in scope 4:.:.:macextras-lib.pri:APPLE_OSX:
# PRIVATE_HEADERS = "$$PWD/qmactoolbar_p.h" "$$PWD/qmactoolbardelegate_p.h" "$$PWD/qnstoolbar_p.h"
# PUBLIC_HEADERS = "$$PWD/qmactoolbar.h" "$$PWD/qmactoolbaritem.h"

qt_extend_target(MacExtras CONDITION (APPLE_OSX) AND ((QT_MAJOR_VERSION GREATER 4))
    SOURCES
        qmacpasteboardmime.mm
)

#### Keys ignored in scope 5:.:.:macextras-lib.pri:(QT_MAJOR_VERSION GREATER 4):
# PUBLIC_HEADERS = "$$PWD/qmacpasteboardmime.h"
qt_add_docs(MacExtras
    doc/qtmacextras.qdocconf
)

