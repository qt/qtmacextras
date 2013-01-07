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

#ifndef QTMAC_H
#define QTMAC_H

#ifdef __cplusplus // C++, Objective-C++
#define CPP_CLASS(classname) class classname
#else // C, Objective-C
#define CPP_CLASS(classname) struct classname; typedef struct classname classname
#endif

#ifdef __OBJC__ // Objective-C, Objective-C++
#define OBJC_CLASS(classname) @class classname
#else // C, C++
#define OBJC_CLASS(classname) typedef struct objc_object classname
#endif

#ifdef __cplusplus
#include <QImage>
#include <QList>
#include <QPixmap>
#include <QString>
#include <CoreGraphics/CGImage.h>

OBJC_CLASS(NSArray);
OBJC_CLASS(NSImage);
OBJC_CLASS(NSString);

extern "C" NSString* toNSString(const QString &string);
extern "C" QString toQString(NSString *string);

extern "C" NSArray *toNSArray(const QList<QString> &stringList);

extern "C" CGImageRef qt_mac_image_to_cgimage(const QImage &img);

extern "C" NSImage *toNSImage(const QPixmap &pixmap);
#endif

#endif // QTMAC_H
