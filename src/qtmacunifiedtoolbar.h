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

#ifndef QTMACTOOLBAR_H
#define QTMACTOOLBAR_H

#include <QtCore/QObject>
#include <QtCore/QString>
#include <QtGui/QWindow>
#include <QtWidgets/QAction>

#include "qtmactoolbutton.h"

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

