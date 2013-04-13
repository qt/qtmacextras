/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the QtMacExtras module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.  For licensing terms and
** conditions see http://qt.digia.com/licensing.  For further information
** use the contact form at http://qt.digia.com/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Digia gives you certain additional
** rights.  These rights are described in the Digia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "qmacfunctions.h"
#ifdef Q_OS_IOS
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#else
#import <Cocoa/Cocoa.h>
#endif

QT_BEGIN_NAMESPACE

#if QT_VERSION >= QT_VERSION_CHECK(5, 0, 0)
#include <QtCore/qDebug.h>
#include <QtGui/QGuiApplication>
#include <QtWidgets/QMenu>
#include <QtWidgets/QMenuBar>
#include <qpa/qplatformmenu.h>
#include <qpa/qplatformnativeinterface.h>

QPlatformNativeInterface::NativeResourceForIntegrationFunction resolvePlatformFunction(const QByteArray &functionName)
{
    QPlatformNativeInterface *nativeInterface = QGuiApplication::platformNativeInterface();
    QPlatformNativeInterface::NativeResourceForIntegrationFunction function =
        nativeInterface->nativeResourceFunctionForIntegration(functionName);
    if (!function)
         qWarning() << "Qt could not resolve function" << functionName
                    << "from QGuiApplication::platformNativeInterface()->nativeResourceFunctionForIntegration()";
    return function;
}

#ifndef Q_OS_IOS
void qt_mac_set_dock_menu(QMenu *menu)
{
    // Get the platform menu, which will be a QCocoaMenu
    QPlatformMenu *platformMenu = menu->platformMenu();

    // Get the setDockMenu function and call it.
    QPlatformNativeInterface::NativeResourceForIntegrationFunction function = resolvePlatformFunction("setdockmenu");
    if (function) {
        typedef void (*SetDockMenuFunction)(QPlatformMenu *platformMenu);
        reinterpret_cast<SetDockMenuFunction>(function)(platformMenu);
    }
}

NSMenu *QtMacExtras::toNSMenu(QMenu *menu)
{
    // Get the platform menu, which will be a QCocoaMenu
    QPlatformMenu *platformMenu = menu->platformMenu();

    // Get the qMenuToNSMenu function and call it.
    QPlatformNativeInterface::NativeResourceForIntegrationFunction function = resolvePlatformFunction("qmenutonsmenu");
    if (function) {
        typedef void* (*QMenuToNSMenuFunction)(QPlatformMenu *platformMenu);
        return reinterpret_cast<NSMenu *>(reinterpret_cast<QMenuToNSMenuFunction>(function)(platformMenu));
    }
    return nil;
}
#endif

NSMenu *QtMacExtras::toNSMenu(QMenuBar *menubar)
{
    // Get the platform menubar, which will be a QCocoaMenuBar
    QPlatformMenuBar *platformMenuBar = menubar->platformMenuBar();

    // Get the qMenuBarToNSMenu function and call it.
    QPlatformNativeInterface::NativeResourceForIntegrationFunction function = resolvePlatformFunction("qmenubartonsmenu");
    if (function) {
        typedef void* (*QMenuBarToNSMenuFunction)(QPlatformMenuBar *platformMenuBar);
        return reinterpret_cast<NSMenu *>(reinterpret_cast<QMenuBarToNSMenuFunction>(function)(platformMenuBar));
    }
    return nil;
}

#endif

namespace QtMacExtras
{

NSString *toNSString(const QString &string)
{
    return [NSString stringWithCharacters:reinterpret_cast<const UniChar*>(string.unicode()) length:string.length()];
}

QString fromNSString(const NSString *string)
{
    if (!string)
        return QString();

    QString qstring;
    qstring.resize([string length]);
    [string getCharacters:reinterpret_cast<unichar*>(qstring.data()) range:NSMakeRange(0, [string length])];

    return qstring;
}

/*!
    Creates a \c CGImageRef equivalent to the QPixmap. Returns the \c CGImageRef handle.

    It is the caller's responsibility to release the \c CGImageRef data
    after use.

    This function is not available in Qt 5.x until 5.0.2 and will return NULL in earlier versions.

    \sa fromCGImageRef()
*/
CGImageRef toCGImageRef(const QPixmap &pixmap)
{
#if QT_VERSION >= QT_VERSION_CHECK(5, 0, 0)
    QPlatformNativeInterface::NativeResourceForIntegrationFunction function = resolvePlatformFunction("qimagetocgimage");
    if (function) {
        typedef CGImageRef (*QImageToCGIamgeFunction)(const QImage &image);
        return reinterpret_cast<QImageToCGIamgeFunction>(function)(pixmap.toImage());
    }

    return NULL;
#else
    return pixmap.toCGImageRef();
#endif
}

#ifndef Q_OS_IOS
NSImage* toNSImage(const QPixmap &pixmap)
{
    NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithCGImage:toCGImageRef(pixmap)];
    NSImage *image = [[NSImage alloc] init];
    [image addRepresentation:bitmapRep];
    [bitmapRep release];
    return image;
}
#endif

/*!
    Returns a QPixmap that is equivalent to the given \a image.

    This function is not available in Qt 5.x until 5.0.2 and will return a null pixmap in earlier versions.

    \sa toCGImageRef(), {QPixmap#Pixmap Conversion}{Pixmap Conversion}
*/
QPixmap fromCGImageRef(CGImageRef image)
{
#if QT_VERSION >= QT_VERSION_CHECK(5, 0, 0)
    QPlatformNativeInterface::NativeResourceForIntegrationFunction function = resolvePlatformFunction("cgimagetoqimage");
    if (function) {
        typedef QImage (*CGImageToQImageFunction)(CGImageRef image);
        return QPixmap::fromImage(reinterpret_cast<CGImageToQImageFunction>(function)(image));
    }

    return QPixmap();
#else
    return QPixmap::fromCGImageRef(image);
#endif
}

} // namespace QtMacExtras

QT_END_NAMESPACE
