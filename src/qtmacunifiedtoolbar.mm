/****************************************************************************
**
** Copyright (C) 2012 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the Qt Mac Extras project.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Nokia Corporation and its Subsidiary(-ies) nor
**     the names of its contributors may be used to endorse or promote
**     products derived from this software without specific prior written
**     permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
** $QT_END_LICENSE$
**
****************************************************************************/
#include "QtMacunifiedtoolbar.h"
#include "QtMactoolbardelegate.h"
#include <QtGui/QGuiApplication>
#include <QtWidgets/QApplication>
#include <qpa/qplatformnativeinterface.h>
#include <QtCore/QtCore>

#import <AppKit/AppKit.h>

NSString *toNSStandardItem(QtMacToolButton::StandardItem standardItem)
{
    if (standardItem == QtMacToolButton::ShowColors)
        return NSToolbarShowColorsItemIdentifier;
    else if (standardItem == QtMacToolButton::ShowFonts)
        return NSToolbarShowFontsItemIdentifier;
    else if (standardItem == QtMacToolButton::PrintItem)
        return NSToolbarPrintItemIdentifier;
    else if (standardItem == QtMacToolButton::Space)
        return NSToolbarSpaceItemIdentifier;
    else if (standardItem == QtMacToolButton::FlexibleSpace)
        return NSToolbarFlexibleSpaceItemIdentifier;
    return @"";
}



class QtMacUnifiedToolBarPrivate
{
public:
    NSToolbar *toolbar;
    QtMacToolbarDelegate *delegate;
};

QtMacUnifiedToolBar::QtMacUnifiedToolBar(QObject *parent)
    : QObject(parent)
{
    targetWidget = 0;
    targetWindow = 0;
    d = new QtMacUnifiedToolBarPrivate();
    d->toolbar = [[NSToolbar alloc] initWithIdentifier:@"QtMacUnifiedToolBar"];
    d->delegate = [[QtMacToolbarDelegate alloc] init];
    [d->toolbar setAllowsUserCustomization:YES];
    [d->toolbar setAutosavesConfiguration:NO];
    [d->toolbar setDisplayMode:NSToolbarDisplayModeIconAndLabel];
    [d->toolbar setDelegate: d->delegate];
}

QtMacUnifiedToolBar::~QtMacUnifiedToolBar()
{
    [d->toolbar release];
    delete d;
}

QList<QtMacToolButton *> QtMacUnifiedToolBar::buttons()
{
    return d->delegate->items;
}

QList<QtMacToolButton *> QtMacUnifiedToolBar::allowedButtons()
{
    return d->delegate->allowedItems;
}

void QtMacUnifiedToolBar::showInWindow(QWindow *window)
{
    targetWindow = window;
    QTimer::singleShot(100, this, SLOT(showInWindow_impl())); // ### hackety hack
}

void QtMacUnifiedToolBar::showInWindowForWidget(QWidget *widget)
{
    targetWidget = widget;
    widget->winId(); // create window
    showInWindow_impl();
}

void QtMacUnifiedToolBar::showInMainWindow()
{
    QWidgetList widgets = QApplication::topLevelWidgets();
    if (widgets.isEmpty())
        return;
    showInWindow(widgets.at(0)->windowHandle());
}


void QtMacUnifiedToolBar::showInWindow_impl()
{
    if (!targetWindow)
        targetWindow = targetWidget->windowHandle();

    if (!targetWindow) {
        QTimer::singleShot(100, this, SLOT(showInWindow_impl()));
        return;
    }

    NSWindow *macWindow = static_cast<NSWindow*>(
        QGuiApplication::platformNativeInterface()->nativeResourceForWindow("nswindow", targetWindow));

    if (!macWindow) {
        QTimer::singleShot(100, this, SLOT(showInWindow_impl()));
        return;
    }

    [macWindow setToolbar: d->toolbar];
    [macWindow setShowsToolbarButton:YES];
}

QAction *QtMacUnifiedToolBar::addAction(const QString &text)
{
    return [d->delegate addActionWithText:&text];
}

QAction *QtMacUnifiedToolBar::addAction(const QIcon &icon, const QString &text)
{
    return [d->delegate addActionWithText:&text icon:&icon];
}

QAction *QtMacUnifiedToolBar::addAction(QAction *action)
{
    return [d->delegate addAction:action];
}

void QtMacUnifiedToolBar::addSeparator()
{
    addStandardItem(QtMacToolButton::Space); // No Seprator on OS X.
}

QAction *QtMacUnifiedToolBar::addStandardItem(QtMacToolButton::StandardItem standardItem)
{
    return [d->delegate addStandardItem:standardItem];
}

QAction *QtMacUnifiedToolBar::addAllowedAction(const QString &text)
{
    return [d->delegate addAllowedActionWithText:&text];
}

QAction *QtMacUnifiedToolBar::addAllowedAction(const QIcon &icon, const QString &text)
{
    return [d->delegate addAllowedActionWithText:&text icon:&icon];
}

QAction *QtMacUnifiedToolBar::addAllowedAction(QAction *action)
{
    return [d->delegate addAllowedAction:action];
}

QAction *QtMacUnifiedToolBar::addAllowedStandardItem(QtMacToolButton::StandardItem standardItem)
{
    return [d->delegate addAllowedStandardItem:standardItem];
}


