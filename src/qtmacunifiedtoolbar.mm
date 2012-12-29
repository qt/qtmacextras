/****************************************************************************
 **
 ** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
 ** Contact: http://www.qt-project.org/legal
 **
 ** This file is part of QtMacExtras in the Qt Toolkit.
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

#include "qtmacunifiedtoolbar.h"
#include "qtmactoolbardelegate.h"
#include <QApplication>
#include <QTimer>
#include <QWidget>

#if QT_VERSION >= QT_VERSION_CHECK(5, 0, 0)
#include <QGuiApplication>
#include <qpa/qplatformnativeinterface.h>
#endif

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

#if QT_VERSION >= QT_VERSION_CHECK(5, 0, 0)
    showInWindow(widgets.at(0)->windowHandle());
#else
    showInWindowForWidget(widgets.at(0)->window());
#endif
}


void QtMacUnifiedToolBar::showInWindow_impl()
{
#if QT_VERSION >= QT_VERSION_CHECK(5, 0, 0)
    if (!targetWindow)
        targetWindow = targetWidget->windowHandle();

    if (!targetWindow) {
        QTimer::singleShot(100, this, SLOT(showInWindow_impl()));
        return;
    }

    NSWindow *macWindow = static_cast<NSWindow*>(
        QGuiApplication::platformNativeInterface()->nativeResourceForWindow("nswindow", targetWindow));
#else
    NSWindow *macWindow = reinterpret_cast<NSWindow*>([reinterpret_cast<NSView*>(targetWidget->winId()) window]);
#endif

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


