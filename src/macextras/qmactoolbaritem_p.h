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

#ifndef QMACTOOLBARITEM_P_H
#define QMACTOOLBARITEM_P_H

//
//  W A R N I N G
//  -------------
//
// This file is not part of the Qt API.  It exists purely as an
// implementation detail.  This header file may change from version to
// version without notice, or even be removed.
//
// We mean it.
//

#undef slots
#import <AppKit/AppKit.h>

#include <QtCore/private/qobject_p.h>

QT_BEGIN_NAMESPACE

class QMacToolBarItem;
class QMacToolBarItemPrivate : public QObjectPrivate
{
public:
    QMacToolBarItemPrivate();
    ~QMacToolBarItemPrivate();
    static NSString *toNSStandardItem(QMacToolBarItem::StandardItem standardItem);
    NSString *itemIdentifier() const;
    void initNativeToolbarItem();

    bool selectable;
    QMacToolBarItem::StandardItem standardItem;
    QString text;
    QIcon icon;
    NSToolbarItem *toolbarItem;
    Q_DECLARE_PUBLIC(QMacToolBarItem)
};

QT_END_NAMESPACE

#endif
