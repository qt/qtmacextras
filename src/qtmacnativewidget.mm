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

#include "qtmacnativewidget.h"
#if QT_VERSION >= QT_VERSION_CHECK(5, 0, 0)
#include <QtGui/QWindow>
#include <QtGui/QGuiApplication>
#include <qpa/qplatformnativeinterface.h>
#endif
#include <qdebug.h>

#import <Cocoa/Cocoa.h>

/*!
    \class QtMacNativeWidget
    \brief The QtMacNativeWidget class provides a widget for Mac OS X that provides a way to put Qt widgets
    into Cocoa hierarchies.

    QtMacNativeWidget bridges the gap between NSViews and QWidgets and makes it possible to put a
    hierarchy of Qt widgets into a non-Qt window or view.

    QtMacNativeWidget pretends it is a window (i.e. isWindow() will return true),
    but it cannot be shown on its own. It needs to be put into a window
    when it is created or later through a native call.

    Note that QtMacNativeWidget requires knowledge of Cocoa. All it
    does is get the Qt hierarchy into a window not owned by Qt. It is then up
    to the programmer to ensure it is placed correctly in the window and
    responds correctly to events.
*/

QT_BEGIN_NAMESPACE

#if QT_VERSION >= QT_VERSION_CHECK(5, 0, 0)
NSView *getEmbeddableView(QWindow *qtWindow)
{
    // Set Qt::SubWindow flag. Should be done before crate() is
    // called - if you call create() or caused it ot be called
    // before calling this function you need to set SubWindow
    // yourself
    qtWindow->setFlags(qtWindow->flags() | Qt::SubWindow);

    // Make sure the platform window is created
    qtWindow->create();

    // Get the Qt content NSView for the QWindow forom the Qt platform plugin
    QPlatformNativeInterface *platformNativeInterface = QGuiApplication::platformNativeInterface();
    NSView *qtView = (NSView *)platformNativeInterface->nativeResourceForWindow("nsview", qtWindow);
    return qtView; // qtView is ready for use.
}
#endif

/*!
    Create a QtMacNativeWidget with \a parentView as its "superview" (i.e.,
    parent). The \a parentView is  a NSView pointer.
*/
QtMacNativeWidget::QtMacNativeWidget(NSView *parentView)
    : QWidget(0, Qt::Window | Qt::SubWindow)
{
    Q_UNUSED(parentView);

    //d_func()->topData()->embedded = true;
    setPalette(QPalette(Qt::transparent));
    setAttribute(Qt::WA_SetPalette, false);
    setAttribute(Qt::WA_LayoutUsesWidgetRect);
}

NSView *QtMacNativeWidget::nativeView() const
{
#if QT_VERSION >= QT_VERSION_CHECK(5, 0, 0)
    winId();
    return getEmbeddableView(windowHandle());
#else
    return reinterpret_cast<NSView*>(winId());
#endif
}

/*!
    Destroy the QtMacNativeWidget.
*/
QtMacNativeWidget::~QtMacNativeWidget()
{
}

/*!
    \reimp
*/
QSize QtMacNativeWidget::sizeHint() const
{
    // QtMacNativeWidget really does not have any other choice
    // than to fill its designated area.
#if QT_VERSION >= QT_VERSION_CHECK(5, 0, 0)
    if (windowHandle())
        return windowHandle()->size();
    return QWidget::sizeHint();
#else
    NSRect frame = [nativeView() frame];
    return QSize(frame.size.width, frame.size.height);
#endif
}
/*!
    \reimp
*/
bool QtMacNativeWidget::event(QEvent *ev)
{
    return QWidget::event(ev);
}

QT_END_NAMESPACE
