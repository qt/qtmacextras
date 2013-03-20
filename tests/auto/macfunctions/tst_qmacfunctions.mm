/****************************************************************************
**
** Copyright (C) 2013 froglogic GmbH and/or its subsidiary(-ies).
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

#include <QString>
#include <QtTest>
#include <QCoreApplication>
#include <QtWidgets/QMenu>
#include <QtWidgets/QMenuBar>
#include <QtWidgets/QMainWindow>
#include <qmacfunctions.h>

#import <AppKit/AppKit.h>

class tst_QMacFunctions : public QObject
{
    Q_OBJECT

public:
    tst_QMacFunctions();

private slots:
    void testToNSMenu();
};

tst_QMacFunctions::tst_QMacFunctions()
{
}

void tst_QMacFunctions::testToNSMenu()
{
    QMainWindow window;
    QMenu *qMenu = new QMenu("Menu", &window);
    QAction *action = new QAction("&Item", &window);
    qMenu->addAction(action);
    window.menuBar()->addMenu(qMenu);

    NSMenu *nsMenu = QtMacExtras::toNSMenu(qMenu);
    QVERIFY(nsMenu != NULL);
    QCOMPARE([[nsMenu title] UTF8String], "Menu");

    NSMenuItem *item = [nsMenu itemAtIndex:0];
    QCOMPARE([[item title] UTF8String], "Item");

    // get NSMenu from QMenuBar
    nsMenu = QtMacExtras::toNSMenu(window.menuBar());
    QVERIFY(nsMenu != NULL);

    // the first item should be our menu
    item = [nsMenu itemAtIndex:0];
    QCOMPARE([[item title] UTF8String], "Menu");
}

QTEST_MAIN(tst_QMacFunctions)

#include "tst_qmacfunctions.moc"
