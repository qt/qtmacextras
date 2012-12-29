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

#ifndef QTMACTOOLBAR_H
#define QTMACTOOLBAR_H

#include "qtmactoolbutton.h"
#include <QObject>
#include <QIcon>
#include <QString>

class QAction;
class QWindow;

class QtMacUnifiedToolBarPrivate;
class QtMacUnifiedToolBar : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<QtMacToolButton *> buttons READ buttons)
    Q_PROPERTY(QList<QtMacToolButton *> allowedButtons READ allowedButtons)
public:

    QtMacUnifiedToolBar(QObject *parent = 0);
    ~QtMacUnifiedToolBar();

    QList<QtMacToolButton *> buttons();
    QList<QtMacToolButton *> allowedButtons();

    void showInWindow(QWindow *window);
    void showInWindowForWidget(QWidget *widget);
    Q_INVOKABLE void showInMainWindow();

    // Add actions to the toolbar
    Q_INVOKABLE QAction *addAction(const QString &text);
    Q_INVOKABLE QAction *addAction(const QIcon &icon, const QString &text);
    Q_INVOKABLE QAction *addAction(QAction *action);
    Q_INVOKABLE void addSeparator();
    Q_INVOKABLE QAction *addStandardItem(QtMacToolButton::StandardItem standardItem);

    // Add actions to the "Customize Toolbar" menu
    Q_INVOKABLE QAction *addAllowedAction(const QString &text);
    Q_INVOKABLE QAction *addAllowedAction(const QIcon &icon, const QString &text);
    Q_INVOKABLE QAction *addAllowedAction(QAction *action);
    Q_INVOKABLE QAction *addAllowedStandardItem(QtMacToolButton::StandardItem standardItem);
private Q_SLOTS:
    void showInWindow_impl();
private:
    QWindow *targetWindow;
    QWidget *targetWidget;
    bool m_showText;
    QList<QtMacToolButton *> m_buttons;
    QList<QtMacToolButton *> m_allowedButtons;
    QtMacUnifiedToolBarPrivate *d;
};

#endif

