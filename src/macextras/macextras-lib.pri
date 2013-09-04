INCLUDEPATH += $$PWD

mac {
    PUBLIC_HEADERS += $$PWD/qmacfunctions.h
    PRIVATE_HEADERS += $$PWD/qmacfunctions_p.h
    OBJECTIVE_SOURCES += $$PWD/qmacfunctions.mm

    ios {
        OBJECTIVE_SOURCES += \
            $$PWD/qmacfunctions_ios.mm

        LIBS *= -framework UIKit
    } else {
        PUBLIC_HEADERS += \
            $$PWD/qmaccocoaviewcontainer.h \
            $$PWD/qmacnativetoolbar.h \
            $$PWD/qmacnativewidget.h \
            $$PWD/qmactoolbutton.h

        PRIVATE_HEADERS += \
            $$PWD/qmactoolbardelegate_p.h \
            $$PWD/qnstoolbar_p.h

        OBJECTIVE_SOURCES += \
            $$PWD/qmaccocoaviewcontainer.mm \
            $$PWD/qmacfunctions_mac.mm \
            $$PWD/qmacnativetoolbar.mm \
            $$PWD/qmacnativewidget.mm \
            $$PWD/qmactoolbardelegate.mm \
            $$PWD/qmactoolbutton.mm \
            $$PWD/qnstoolbar.mm

        greaterThan(QT_MAJOR_VERSION, 4) {
            PUBLIC_HEADERS += $$PWD/qmacpasteboardmime.h
            OBJECTIVE_SOURCES += $$PWD/qmacpasteboardmime.mm
        }

        LIBS *= -framework AppKit
    }
}

HEADERS += $$PUBLIC_HEADERS $$PRIVATE_HEADERS
