# Generated from macfunctions.pro.

#####################################################################
## tst_qmacfunctions Test:
#####################################################################

qt_add_test(tst_qmacfunctions
    SOURCES
        tst_qmacfunctions.mm
    PUBLIC_LIBRARIES
        Qt::Gui
        Qt::MacExtras
        Qt::Widgets
)

## Scopes:
#####################################################################

qt_extend_target(tst_qmacfunctions CONDITION APPLE_OSX
    PUBLIC_LIBRARIES
        ${FWAppKit}
)
