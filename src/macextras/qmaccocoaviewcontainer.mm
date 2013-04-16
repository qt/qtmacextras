/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
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

#import <Cocoa/Cocoa.h>

#include "qmaccocoaviewcontainer.h"

#include <qpa/qplatformnativeinterface.h>
#include <QtGui/QWindow>

/*!
    \class QMacCocoaViewContainer

    \brief The QMacCocoaViewContainer class provides a widget for Mac OS X that can be used to wrap arbitrary
    Cocoa views (i.e., NSView subclasses) and insert them into Qt hierarchies.

    \ingroup advanced

    While Qt offers a lot of classes for writing your application, Apple's
    Cocoa framework offers lots of functionality that is not currently in Qt or
    may never end up in Qt. Using QMacCocoaViewContainer, it is possible to put an
    arbitrary NSView-derived class from Cocoa and put it in a Qt hierarchy.
    Depending on how comfortable you are with using objective-C, you can use
    QMacCocoaViewContainer directly, or subclass it to wrap further functionality
    of the underlying NSView.

    It should be also noted that at the low level on Mac OS X, there is a
    difference between windows (top-levels) and view (widgets that are inside a
    window). For this reason, make sure that the NSView that you are wrapping
    doesn't end up as a top-level. The best way to ensure this is to make sure
    you always have a parent and not set the parent to 0.

    If you are using QMacCocoaViewContainer as a sub-class and are mixing and
    matching objective-C with C++ (a.k.a. objective-C++). It is probably
    simpler to have your file end with \tt{.mm} than \tt{.cpp}. Most Apple tools will
    correctly identify the source as objective-C++.

    QMacCocoaViewContainer requires knowledge of how Cocoa works, especially in
    regard to its reference counting (retain/release) nature. It is noted in
    the functions below if there is any change in the reference count. Cocoa
    views often generate temporary objects that are released by an autorelease
    pool. If this is done outside of a running event loop, it is up to the
    developer to provide the autorelease pool.

    The following is a snippet of subclassing QMacCocoaViewContainer to wrap a NSSearchField.
    \snippet demos/macmainwindow/macmainwindow.mm 0

*/

QT_BEGIN_NAMESPACE

class QMacCocoaViewContainerPrivate
{
public:
    NSView *nsview;
    QMacCocoaViewContainerPrivate();
    ~QMacCocoaViewContainerPrivate();
};

QMacCocoaViewContainerPrivate::QMacCocoaViewContainerPrivate()
     : nsview(0)
{
}

QMacCocoaViewContainerPrivate::~QMacCocoaViewContainerPrivate()
{
    [nsview release];
}

/*!
    \fn QMacCocoaViewContainer::QMacCocoaViewContainer(NSView *cocoaViewToWrap, QWidget *parent)

    Create a new QMacCocoaViewContainer using the NSView pointer in \a
    cocoaViewToWrap with parent, \a parent. QMacCocoaViewContainer will
    retain \a cocoaViewToWrap.

*/
QMacCocoaViewContainer::QMacCocoaViewContainer(NSView *view, QWidget *parent)
   : QWidget(parent, 0)
   , d(new QMacCocoaViewContainerPrivate)
{

    if (view)
        setCocoaView(view);

    // QMacCocoaViewContainer requires a native window handle.
    setAttribute(Qt::WA_NativeWindow);
}

/*!
    Destroy the QMacCocoaViewContainer and release the wrapped view.
*/
QMacCocoaViewContainer::~QMacCocoaViewContainer()
{
    delete d;
}

/*!
    Returns the NSView that has been set on this container.
*/
NSView *QMacCocoaViewContainer::cocoaView() const
{
    return d->nsview;
}

/*!
    Sets the NSView to contain to be \a cocoaViewToWrap and retains it. If this
    container already had a view set, it will release the previously set view.
*/
void QMacCocoaViewContainer::setCocoaView(NSView *view)
{
    NSView *oldView = d->nsview;
    [view retain];
    d->nsview = view;

    // Create window and platformwindow
    winId();
    QPlatformWindow *platformWindow = this->windowHandle()->handle();

    // Set the new view as the content view for the window.
    extern QPlatformNativeInterface::NativeResourceForIntegrationFunction resolvePlatformFunction(const QByteArray &functionName);
    typedef void (*SetWindowContentViewFunction)(QPlatformWindow *window, NSView *nsview);
    reinterpret_cast<SetWindowContentViewFunction>(resolvePlatformFunction("setwindowcontentview"))(platformWindow, view);

    [oldView release];
}

QT_END_NAMESPACE
