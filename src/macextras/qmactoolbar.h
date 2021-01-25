/****************************************************************************
**
** Copyright (C) 2021 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the QtMacExtras module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:COMM$
**
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** $QT_END_LICENSE$
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
****************************************************************************/

#ifndef QMACTOOLBAR_H
#define QMACTOOLBAR_H

#include <QtMacExtras/qmacextrasglobal.h>
#include <QtMacExtras/qmactoolbaritem.h>

#include <QtCore/QString>
#include <QtCore/QObject>
#include <QtCore/QVariant>
#include <QtGui/QIcon>

Q_FORWARD_DECLARE_OBJC_CLASS(NSToolbar);

QT_BEGIN_NAMESPACE

class QWindow;
class QMacToolBarPrivate;

class Q_MACEXTRAS_EXPORT QMacToolBar : public QObject
{
    Q_OBJECT
public:
    explicit QMacToolBar(QObject *parent = nullptr);
    explicit QMacToolBar(const QString &identifier, QObject *parent = nullptr);
    ~QMacToolBar();

    QMacToolBarItem *addItem(const QIcon &icon, const QString &text);
    QMacToolBarItem *addAllowedItem(const QIcon &icon, const QString &text);
    QMacToolBarItem *addStandardItem(QMacToolBarItem::StandardItem standardItem);
    QMacToolBarItem *addAllowedStandardItem(QMacToolBarItem::StandardItem standardItem);
    void addSeparator();

    void setItems(QList<QMacToolBarItem *> &items);
    QList<QMacToolBarItem *> items();
    void setAllowedItems(QList<QMacToolBarItem *> &allowedItems);
    QList<QMacToolBarItem *> allowedItems();

    void attachToWindow(QWindow *window);
    void detachFromWindow();

    NSToolbar* nativeToolbar() const;
private Q_SLOTS:
    void showInWindow_impl();
private:
    Q_DECLARE_PRIVATE(QMacToolBar)
};

QT_END_NAMESPACE

Q_DECLARE_METATYPE(QMacToolBar*)

#endif

