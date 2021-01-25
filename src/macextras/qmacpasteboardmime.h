/****************************************************************************
**
** Copyright (C) 2021 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the QtMacExtras of the Qt Toolkit.
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

#if !defined(QMACMIME_H) && !defined(QMIME_H)
#define QMACMIME_H

#include <QtMacExtras/qmacextrasglobal.h>

#include <QtCore/QString>
#include <QtCore/QStringList>
#include <QtCore/QByteArray>
#include <QtCore/QList>
#include <QtCore/QVariant>
#include <QtCore/QMimeData>

#include <CoreFoundation/CoreFoundation.h>

QT_BEGIN_NAMESPACE

Q_MACEXTRAS_EXPORT void qRegisterDraggedTypes(const QStringList &types);

// Duplicate of QMacPasteboardMime in the Cocoa Platform Plugin. Keep in sync!
class Q_MACEXTRAS_EXPORT QMacPasteboardMime {
    char type;
public:
    enum QMacPasteboardMimeType { MIME_DND=0x01,
        MIME_CLIP=0x02,
        MIME_QT_CONVERTOR=0x04,
        MIME_QT3_CONVERTOR=0x08,
        MIME_ALL=MIME_DND|MIME_CLIP
    };
    explicit QMacPasteboardMime(char);
    virtual ~QMacPasteboardMime();

    virtual QString convertorName() = 0;
    virtual bool canConvert(const QString &mime, QString flav) = 0;
    virtual QString mimeFor(QString flav) = 0;
    virtual QString flavorFor(const QString &mime) = 0;
    virtual QVariant convertToMime(const QString &mime, QList<QByteArray> data, QString flav) = 0;
    virtual QList<QByteArray> convertFromMime(const QString &mime, QVariant data, QString flav) = 0;
    virtual int count(QMimeData *mimeData);
};

QT_END_NAMESPACE

#endif

