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

#include "window.h"
#include "ui_window.h"
#include "preferenceswindow.h"
#include "qtmacunifiedtoolbar.h"
#include <QDesktopWidget>
#include <QMenuBar>
#include <QTimer>

class WindowPrivate
{
public:
    PreferencesWindow *preferencesWindow;
    QMenuBar *mainMenuBar;
    QtMacUnifiedToolBar *toolBar;
};

Window::Window(QWidget *parent) :
    QWidget(parent),
    d(new WindowPrivate),
    ui(new Ui::Window)
{
    ui->setupUi(this);

    d->preferencesWindow = new PreferencesWindow();

    d->mainMenuBar = new QMenuBar();
    QMenu *toolsMenu = d->mainMenuBar->addMenu("Tools");
    toolsMenu->addAction("Options", d->preferencesWindow, SLOT(show()));

    d->toolBar = new QtMacUnifiedToolBar(this);
    d->toolBar->addAction(QIcon(":/qtlogo.png"), "Hello");
    d->toolBar->addAction(QIcon(":/qtlogo.png"), "World");
    d->toolBar->addStandardItem(QtMacToolButton::FlexibleSpace);
    d->toolBar->addStandardItem(QtMacToolButton::ShowColors);
    d->toolBar->addStandardItem(QtMacToolButton::ShowFonts);
    d->toolBar->addStandardItem(QtMacToolButton::PrintItem);

    d->toolBar->addAllowedAction(QIcon(":/qtlogo.png"), "Extra Button 1");
    d->toolBar->addAllowedAction(QIcon(":/qtlogo.png"), "Extra Button 2");

    d->toolBar->showInWindowForWidget(this);

    connect(d->toolBar, SIGNAL(toolButtonStyleChanged(Qt::ToolButtonStyle)), SLOT(displayModeChanged(Qt::ToolButtonStyle)));
    ui->displayModeComboBox->setCurrentIndex(d->toolBar->toolButtonStyle());

    connect(d->toolBar, SIGNAL(iconSizeChanged(QtMacToolButton::IconSize)), SLOT(sizeModeChanged(QtMacToolButton::IconSize)));
    ui->sizeModeComboBox->setCurrentIndex(d->toolBar->iconSizeType());

    connect(ui->visibleCheckBox, SIGNAL(clicked(bool)), d->toolBar, SLOT(setVisible(bool)));
    connect(d->toolBar, SIGNAL(visibilityChanged(bool)), ui->visibleCheckBox, SLOT(setChecked(bool)));
    ui->visibleCheckBox->setChecked(d->toolBar->isVisible());

    connect(ui->showsBaselineSeparatorCheckBox, SIGNAL(clicked(bool)), d->toolBar, SLOT(setShowsBaselineSeparator(bool)));
    connect(d->toolBar, SIGNAL(showsBaselineSeparatorChanged(bool)), ui->showsBaselineSeparatorCheckBox, SLOT(setChecked(bool)));
    ui->showsBaselineSeparatorCheckBox->setChecked(d->toolBar->showsBaselineSeparator());

    connect(ui->allowsUserCustomizationCheckBox, SIGNAL(clicked(bool)), d->toolBar, SLOT(setAllowsUserCustomization(bool)));
    connect(d->toolBar, SIGNAL(allowsUserCustomizationChanged(bool)), ui->allowsUserCustomizationCheckBox, SLOT(setChecked(bool)));
    ui->allowsUserCustomizationCheckBox->setChecked(d->toolBar->allowsUserCustomization());

    connect(ui->showCustomizationSheetPushButton, SIGNAL(clicked()), d->toolBar, SLOT(showCustomizationSheet()));
    connect(d->toolBar, SIGNAL(allowsUserCustomizationChanged(bool)), ui->showCustomizationSheetPushButton, SLOT(setEnabled(bool)));
    ui->showCustomizationSheetPushButton->setEnabled(d->toolBar->allowsUserCustomization());

    QTimer::singleShot(0, this, SLOT(positionWindow()));
}

Window::~Window()
{
    delete ui;
    delete d->mainMenuBar;
    delete d->preferencesWindow;
    delete d;
}

void Window::changeDisplayMode(int toolButtonStyle)
{
    d->toolBar->setToolButtonStyle(static_cast<Qt::ToolButtonStyle>(toolButtonStyle));
}

void Window::displayModeChanged(Qt::ToolButtonStyle toolButtonStyle)
{
    ui->displayModeComboBox->setCurrentIndex(toolButtonStyle);
}

void Window::changeSizeMode(int sizeMode)
{
    d->toolBar->setIconSize(static_cast<QtMacToolButton::IconSize>(sizeMode));
}

void Window::sizeModeChanged(QtMacToolButton::IconSize size)
{
    ui->sizeModeComboBox->setCurrentIndex(size);
}

void Window::positionWindow()
{
    resize(QSize());
    setGeometry(QStyle::alignedRect(Qt::LeftToRight, Qt::AlignCenter, size(), qApp->desktop()->availableGeometry()));
}
