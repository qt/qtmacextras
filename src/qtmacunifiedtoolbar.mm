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

#include "qtmacfunctions.h"
#include "qtmacunifiedtoolbar.h"
#include "qtmactoolbardelegate.h"
#include "qtnstoolbar.h"
#include <QAction>
#include <QApplication>
#include <QDebug>
#include <QTimer>
#include <QToolBar>
#include <QUuid>
#include <QWidget>

#if QT_VERSION >= QT_VERSION_CHECK(5, 0, 0)
#include <QGuiApplication>
#include <qpa/qplatformnativeinterface.h>
#else
#include <QMainWindow>
#endif

#import <AppKit/AppKit.h>

// from the Apple NSToolbar documentation
#define kNSToolbarIconSizeSmall 24
#define kNSToolbarIconSizeRegular 32
#define kNSToolbarIconSizeDefault kNSToolbarIconSizeRegular

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

NSToolbarDisplayMode toNSToolbarDisplayMode(Qt::ToolButtonStyle toolButtonStyle)
{
    switch (toolButtonStyle)
    {
    case Qt::ToolButtonIconOnly:
        return NSToolbarDisplayModeIconOnly;
    case Qt::ToolButtonTextOnly:
        return NSToolbarDisplayModeLabelOnly;
    case Qt::ToolButtonTextBesideIcon:
    case Qt::ToolButtonTextUnderIcon:
        return NSToolbarDisplayModeIconAndLabel;
    case Qt::ToolButtonFollowStyle:
    default:
        return NSToolbarDisplayModeDefault;
    }
}

Qt::ToolButtonStyle toQtToolButtonStyle(NSToolbarDisplayMode toolbarDisplayMode)
{
    switch (toolbarDisplayMode)
    {
    case NSToolbarDisplayModeIconAndLabel:
        return Qt::ToolButtonTextUnderIcon;
    case NSToolbarDisplayModeIconOnly:
        return Qt::ToolButtonIconOnly;
    case NSToolbarDisplayModeLabelOnly:
        return Qt::ToolButtonTextOnly;
    case NSToolbarDisplayModeDefault:
    default:
        return Qt::ToolButtonFollowStyle;
    }
}

@interface QtNSToolbarNotifier : NSObject
{
@public
    QtMacUnifiedToolBarPrivate *pimpl;
}
- (void)notification:(NSNotification*)note;
@end

class QtMacUnifiedToolBarPrivate
{
public:
    QtMacUnifiedToolBar *qtToolbar;
    NSToolbar *toolbar;
    QtMacToolbarDelegate *delegate;
    QtNSToolbarNotifier *notifier;

    QtMacUnifiedToolBarPrivate(QtMacUnifiedToolBar *parent, const QString &identifier = QString())
    {
        qtToolbar = parent;
        toolbar = [[QtNSToolbar alloc] initWithIdentifier:qt_mac_QStringToNSString(identifier.isEmpty() ? QUuid::createUuid().toString() : identifier)];
        [toolbar setAutosavesConfiguration:NO];

        delegate = [[QtMacToolbarDelegate alloc] init];
        [toolbar setDelegate:delegate];

        notifier = [[QtNSToolbarNotifier alloc] init];
        notifier->pimpl = this;
        [[NSNotificationCenter defaultCenter] addObserver:notifier selector:@selector(notification:) name:nil object:toolbar];
    }

    ~QtMacUnifiedToolBarPrivate()
    {
        [[NSNotificationCenter defaultCenter] removeObserver:notifier name:nil object:toolbar];
    }

    void fireVisibilityChanged()
    {
        Q_ASSERT(qtToolbar);
        Q_EMIT qtToolbar->visibilityChanged(qtToolbar->isVisible());
    }

    void fireShowsBaselineSeparatorChanged()
    {
        Q_ASSERT(qtToolbar);
        Q_EMIT qtToolbar->showsBaselineSeparatorChanged(qtToolbar->showsBaselineSeparator());
    }

    void fireToolButtonStyleChanged()
    {
        Q_ASSERT(qtToolbar);
        Q_EMIT qtToolbar->toolButtonStyleChanged(qtToolbar->toolButtonStyle());
    }

    void fireSizeModeChangedNotification()
    {
        Q_ASSERT(qtToolbar);
        Q_EMIT qtToolbar->iconSizeChanged(qtToolbar->iconSize());
        Q_EMIT qtToolbar->iconSizeChanged(qtToolbar->iconSizeType());
    }

    void fireAllowsUserCustomizationChanged()
    {
        Q_ASSERT(qtToolbar);
        Q_EMIT qtToolbar->allowsUserCustomizationChanged(qtToolbar->allowsUserCustomization());
    }
};

@implementation QtNSToolbarNotifier

- (void)notification:(NSNotification*)note
{
    Q_ASSERT(pimpl);
    if ([[note name] isEqualToString:QtNSToolbarVisibilityChangedNotification])
        pimpl->fireVisibilityChanged();
    else if ([[note name] isEqualToString:QtNSToolbarShowsBaselineSeparatorChangedNotification])
        pimpl->fireShowsBaselineSeparatorChanged();
    else if ([[note name] isEqualToString:QtNSToolbarDisplayModeChangedNotification])
        pimpl->fireToolButtonStyleChanged();
    else if ([[note name] isEqualToString:QtNSToolbarSizeModeChangedNotification])
        pimpl->fireSizeModeChangedNotification();
    else if ([[note name] isEqualToString:QtNSToolbarAllowsUserCustomizationChangedNotification])
        pimpl->fireAllowsUserCustomizationChanged();
}

@end

QtMacUnifiedToolBar* setUnifiedTitleAndToolBarOnMac(QToolBar *toolbar, bool on)
{
    return setUnifiedTitleAndToolBarOnMac(toolbar, QString(), on);
}

QtMacUnifiedToolBar* setUnifiedTitleAndToolBarOnMac(QToolBar *toolbar, const QString &identifier, bool on)
{
    if (!toolbar)
    {
        qWarning() << "setNativeToolBarOnMac: toolbar was NULL";
        return NULL;
    }

#if QT_VERSION < QT_VERSION_CHECK(5, 0, 0)
    // Turn off unified title and toolbar if it's on, because we're adding our own NSToolbar
    QMainWindow *mainWindow = qobject_cast<QMainWindow*>(toolbar->window());
    if (mainWindow && mainWindow->unifiedTitleAndToolBarOnMac())
        mainWindow->setUnifiedTitleAndToolBarOnMac(false);
#endif

    static const char *macToolBarProperty = "_q_mac_native_toolbar";

    // Check if we've already created a Mac equivalent for this toolbar
    QVariant toolBarProperty = toolbar->property(macToolBarProperty);
    QtMacUnifiedToolBar *macToolBar = NULL;
    if (toolBarProperty.canConvert<QtMacUnifiedToolBar*>())
        macToolBar = toolBarProperty.value<QtMacUnifiedToolBar*>();

    // Create one if not, but only if we're turning it on - no point in creating
    // a toolbar for the sole purpose of turning it off immediately
    if (!macToolBar && on)
    {
        macToolBar = QtMacUnifiedToolBar::fromQToolBar(toolbar, identifier);
        macToolBar->setParent(toolbar);
        toolbar->setProperty(macToolBarProperty, QVariant::fromValue(macToolBar));
    }

    toolbar->setVisible(!on);
    if (on)
        macToolBar->showInWindowForWidget(toolbar->window());
    else if (macToolBar)
        macToolBar->removeFromWindowForWidget(toolbar->window());

    return macToolBar;
}

QtMacUnifiedToolBar::QtMacUnifiedToolBar(QObject *parent)
    : QObject(parent), targetWindow(NULL), targetWidget(NULL), d(new QtMacUnifiedToolBarPrivate(this))
{
    setAllowsUserCustomization(true);
    setToolButtonStyle(Qt::ToolButtonTextUnderIcon);
}

QtMacUnifiedToolBar::QtMacUnifiedToolBar(const QString &identifier, QObject *parent)
    : QObject(parent), targetWindow(NULL), targetWidget(NULL), d(new QtMacUnifiedToolBarPrivate(this, identifier))
{
    setAllowsUserCustomization(true);
    setToolButtonStyle(Qt::ToolButtonTextUnderIcon);
}

QtMacUnifiedToolBar::~QtMacUnifiedToolBar()
{
    [d->toolbar release];
    delete d;
}

QtMacUnifiedToolBar *QtMacUnifiedToolBar::fromQToolBar(const QToolBar *toolBar, const QString &identifier)
{
    // TODO: add the QToolBar's QWidgets to the Mac toolbar once it supports this
    QtMacUnifiedToolBar *macToolBar = new QtMacUnifiedToolBar(identifier);
    foreach (QAction *action, toolBar->actions())
    {
        macToolBar->addAction(action);
    }

    return macToolBar;
}

QString QtMacUnifiedToolBar::identifier() const
{
    return qt_mac_NSStringToQString([d->toolbar identifier]);
}

bool QtMacUnifiedToolBar::isVisible() const
{
    return [d->toolbar isVisible];
}

void QtMacUnifiedToolBar::setVisible(bool visible)
{
    [d->toolbar setVisible:visible];
}

bool QtMacUnifiedToolBar::showsBaselineSeparator() const
{
    return [d->toolbar showsBaselineSeparator];
}

void QtMacUnifiedToolBar::setShowsBaselineSeparator(bool show)
{
    [d->toolbar setShowsBaselineSeparator:show];
}

bool QtMacUnifiedToolBar::allowsUserCustomization() const
{
    return [d->toolbar allowsUserCustomization];
}

void QtMacUnifiedToolBar::setAllowsUserCustomization(bool allow)
{
    [d->toolbar setAllowsUserCustomization:allow];
}

Qt::ToolButtonStyle QtMacUnifiedToolBar::toolButtonStyle() const
{
    return toQtToolButtonStyle([d->toolbar displayMode]);
}

void QtMacUnifiedToolBar::setToolButtonStyle(Qt::ToolButtonStyle toolButtonStyle)
{
    [d->toolbar setDisplayMode:toNSToolbarDisplayMode(toolButtonStyle)];

    // Since this isn't supported, no change event will be fired so do it manually
    if (toolButtonStyle == Qt::ToolButtonTextBesideIcon)
        d->fireToolButtonStyleChanged();
}

QSize QtMacUnifiedToolBar::iconSize() const
{
    switch (iconSizeType())
    {
    case QtMacToolButton::IconSizeRegular:
        return QSize(kNSToolbarIconSizeRegular, kNSToolbarIconSizeRegular);
    case QtMacToolButton::IconSizeSmall:
        return QSize(kNSToolbarIconSizeSmall, kNSToolbarIconSizeSmall);
    case QtMacToolButton::IconSizeDefault:
    default:
        return QSize(kNSToolbarIconSizeDefault, kNSToolbarIconSizeDefault);
    }
}

QtMacToolButton::IconSize QtMacUnifiedToolBar::iconSizeType() const
{
    switch ([d->toolbar sizeMode])
    {
    case NSToolbarSizeModeRegular:
        return QtMacToolButton::IconSizeRegular;
    case NSToolbarSizeModeSmall:
        return QtMacToolButton::IconSizeSmall;
    case NSToolbarSizeModeDefault:
    default:
        return QtMacToolButton::IconSizeDefault;
    }
}

void QtMacUnifiedToolBar::setIconSize(const QSize &iconSize)
{
    if (iconSize.isEmpty())
        setIconSize(QtMacToolButton::IconSizeDefault);
    else if (iconSize.width() <= kNSToolbarIconSizeSmall && iconSize.height() <= kNSToolbarIconSizeSmall)
        setIconSize(QtMacToolButton::IconSizeSmall);
    else
        setIconSize(QtMacToolButton::IconSizeRegular);
}

void QtMacUnifiedToolBar::setIconSize(QtMacToolButton::IconSize iconSize)
{
    switch (iconSize)
    {
    case QtMacToolButton::IconSizeRegular:
        [d->toolbar setSizeMode:NSToolbarSizeModeRegular];
        break;
    case QtMacToolButton::IconSizeSmall:
        [d->toolbar setSizeMode:NSToolbarSizeModeSmall];
        break;
    case QtMacToolButton::IconSizeDefault:
    default:
        [d->toolbar setSizeMode:NSToolbarSizeModeDefault];
        break;
    }
}

void QtMacUnifiedToolBar::showCustomizationSheet()
{
    [d->toolbar runCustomizationPalette:nil];
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

#if QT_VERSION >= QT_VERSION_CHECK(5, 0, 0)
void QtMacUnifiedToolBar::removeFromWindow(QWindow *window)
{
    if (!window)
        return;

    NSWindow *macWindow = static_cast<NSWindow*>(
        QGuiApplication::platformNativeInterface()->nativeResourceForWindow("nswindow", window));
    [macWindow setToolbar:nil];
}
#endif

void QtMacUnifiedToolBar::removeFromWindowForWidget(QWidget *widget)
{
    if (!widget)
        return;

    NSWindow *macWindow = reinterpret_cast<NSWindow*>([reinterpret_cast<NSView*>(widget->winId()) window]);
    [macWindow setToolbar:nil];
}

void QtMacUnifiedToolBar::setSelectedItem()
{
    setSelectedItem(qobject_cast<QAction*>(sender()));
}

QAction *QtMacUnifiedToolBar::setSelectedItem(QAction *action)
{
    // If this action is checkable, find the corresponding NSToolBarItem on the
    // real NSToolbar and set it to the selected item if it is checked
    if (action && action->isCheckable())
    {
        checkSelectableItemSanity();

        foreach (QtMacToolButton *toolButton, allowedButtons())
        {
            if (toolButton->m_action && toolButton->m_action->isChecked())
            {
                [d->toolbar setSelectedItemIdentifier:qt_mac_QStringToNSString(QString::number(qulonglong(toolButton)))];
                break;
            }
            else
            {
                [d->toolbar setSelectedItemIdentifier:nil];
            }
        }
    }

    return action;
}

void QtMacUnifiedToolBar::checkSelectableItemSanity()
{
    // Find a list of all selectable actions
    QList<QAction*> selectableActions;
    foreach (QtMacToolButton *button, allowedButtons())
        if (button->m_action && button->m_action->isCheckable())
            selectableActions.append(button->m_action);

    // If there's more than one, we need to do some sanity checks
    if (selectableActions.size() > 1)
    {
        // The action group that all selectable actions must belong to
        QActionGroup *group = NULL;

        foreach (QAction *action, selectableActions)
        {
            // The first action group we find is "the" action group that
            // all selectable actions on the toolbar must belong to
            if (!group)
                group = action->actionGroup();

            // An action not having a group is a failure
            // All actions not belonging to the same group is a failure
            // The group not being exclusive is a failure
            if (!group || (group != action->actionGroup()) || (group && !group->isExclusive()))
            {
                qWarning() << "All selectable actions in a QtMacUnifiedToolBar should belong to the same exclusive QActionGroup if there is more than one selectable action.";
                break;
            }
        }
    }
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
    connect(action, SIGNAL(triggered()), this, SLOT(setSelectedItem()));
    return setSelectedItem([d->delegate addAction:action]);
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
    connect(action, SIGNAL(triggered()), this, SLOT(setSelectedItem()));
    return setSelectedItem([d->delegate addAllowedAction:action]);
}

QAction *QtMacUnifiedToolBar::addAllowedStandardItem(QtMacToolButton::StandardItem standardItem)
{
    return [d->delegate addAllowedStandardItem:standardItem];
}


