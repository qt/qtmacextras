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

#ifndef QMACTOOLBAR_P_H
#define QMACTOOLBAR_P_H

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
#import <AppKit/AppKit.h>

#include "qmactoolbar.h"

#include "qmacextrasglobal.h"
#include "qmactoolbaritem.h"

#include <QtCore/QString>
#include <QtCore/QObject>
#include <QtCore/private/qobject_p.h>

Q_FORWARD_DECLARE_OBJC_CLASS(NSToolbar);

QT_BEGIN_NAMESPACE

class QMacToolBarPrivate : public QObjectPrivate
{
public:
    QMacToolBarPrivate(const QString &identifier = QString());
    ~QMacToolBarPrivate();

    static NSString *getItemIdentifier(const QMacToolBarItem *item);
    static NSMutableArray *getItemIdentifiers(const QList<QMacToolBarItem *> &items, bool cullUnselectable);
    void itemClicked(NSToolbarItem *itemClicked);

    NSToolbar *toolbar;
    QWindow *targetWindow;
    QList<QMacToolBarItem *> items;
    QList<QMacToolBarItem *> allowedItems;

    Q_DECLARE_PUBLIC(QMacToolBar)
};

QT_END_NAMESPACE

#endif

