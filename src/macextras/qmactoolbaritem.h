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

#ifndef QMACTOOLBARITEM_H
#define QMACTOOLBARITEM_H

#include <QtCore/QObject>
#include <QtCore/QString>
#include <QtGui/QIcon>

#include <QtMacExtras/qmacextrasglobal.h>

Q_FORWARD_DECLARE_OBJC_CLASS(NSToolbarItem);

QT_BEGIN_NAMESPACE

class QMacToolBarItemPrivate;
class Q_MACEXTRAS_EXPORT QMacToolBarItem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool selectable READ selectable WRITE setSelectable)
    Q_PROPERTY(StandardItem standardItem READ standardItem WRITE setStandardItem)
    Q_PROPERTY(QString text READ text WRITE setText)
    Q_PROPERTY(QIcon icon READ icon WRITE setIcon)
    Q_ENUMS(StandardItem)

public:
    enum StandardItem
    {
        NoStandardItem,
        Space,
        FlexibleSpace
    };

    explicit QMacToolBarItem(QObject *parent = nullptr);
    virtual ~QMacToolBarItem();

    bool selectable() const;
    void setSelectable(bool selectable);

    StandardItem standardItem() const;
    void setStandardItem(StandardItem standardItem);

    QString text() const;
    void setText(const QString &text);

    QIcon icon() const;
    void setIcon(const QIcon &icon);

    NSToolbarItem *nativeToolBarItem() const;

Q_SIGNALS:
    void activated();
private:
    friend class QMacToolBarPrivate;
    Q_DECLARE_PRIVATE(QMacToolBarItem)
};

QT_END_NAMESPACE

#endif
