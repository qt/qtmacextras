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

#include "preferenceswindow.h"
#include <QMacNativeToolBar>
#include <QTimer>

PreferencesWindow::PreferencesWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::PreferencesWindow)
{
    ui->setupUi(this);

    // Ensure we can only select one 'tab' at a time
    QActionGroup *items = new QActionGroup(this);
    foreach (QAction *action, ui->toolBar->actions())
        items->addAction(action);

    // This single line of code is all that's needed to transform a QToolBar into a native toolbar!
    QtMacExtras::setNativeToolBar(ui->toolBar, ui->useNativeToolbarCheckBox->isChecked());

    QTimer::singleShot(0, this, SLOT(pack()));
}

PreferencesWindow::~PreferencesWindow()
{
    delete ui;
}

void PreferencesWindow::toolbarItemTriggered()
{
    QAction *action = qobject_cast<QAction*>(sender());
    if (action)
    {
        setWindowTitle(action->text());
    }

    if (sender() == ui->actionGeneral)
    {
        ui->stackedWidget->setCurrentWidget(ui->generalPage);
    }
    else if (sender() == ui->actionNetwork)
    {
        ui->stackedWidget->setCurrentWidget(ui->networkPage);
    }
    else if (sender() == ui->actionAdvanced)
    {
        ui->stackedWidget->setCurrentWidget(ui->advancedPage);
    }

    QTimer::singleShot(0, this, SLOT(pack()));
}

void PreferencesWindow::useNativeToolBarToggled(bool on)
{
    QtMacExtras::setNativeToolBar(ui->toolBar, on);
    QTimer::singleShot(0, this, SLOT(pack()));
}

void PreferencesWindow::pack()
{
    resize(QSize());
}
