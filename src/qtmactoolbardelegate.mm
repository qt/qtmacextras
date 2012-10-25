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
#include "qtmactoolbardelegate.h"
#include <qdebug.h>

NSString *toNSString(const QString &string)
{
    return [NSString
                stringWithCharacters : reinterpret_cast<const UniChar *>(string.unicode())
                length : string.length()];
}

QString toQString(NSString *string)
{
    if (!string)
        return QString();

    QString qstring;
    qstring.resize([string length]);
    [string getCharacters: reinterpret_cast<unichar*>(qstring.data()) range : NSMakeRange(0, [string length])];

    return qstring;
}

NSArray *toNSArray(const QList<QString> &stringList)
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    foreach (const QString &string, stringList) {
        [array addObject : toNSString(string)];
    }
    return array;
}

static void drawImageReleaseData (void *info, const void *, size_t)
{
    delete static_cast<QImage *>(info);
}

CGImageRef qt_mac_image_to_cgimage(const QImage &img)
{
    QImage *image;
    if (img.depth() != 32)
        image = new QImage(img.convertToFormat(QImage::Format_ARGB32_Premultiplied));
    else
        image = new QImage(img);

    uint cgflags = kCGImageAlphaNone;
    switch (image->format()) {
    case QImage::Format_ARGB32_Premultiplied:
        cgflags = kCGImageAlphaPremultipliedFirst;
        break;
    case QImage::Format_ARGB32:
        cgflags = kCGImageAlphaFirst;
        break;
    case QImage::Format_RGB32:
        cgflags = kCGImageAlphaNoneSkipFirst;
    default:
        break;
    }
    cgflags |= kCGBitmapByteOrder32Host;
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(image,
                                                          static_cast<const QImage *>(image)->bits(),
                                                          image->byteCount(),
                                                          drawImageReleaseData);
    CGColorSpaceRef colorspace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);


    CGImageRef cgImage = CGImageCreate(image->width(), image->height(), 8, 32,
                                        image->bytesPerLine(),
                                        colorspace,
                                        cgflags, dataProvider, 0, false, kCGRenderingIntentDefault);

    CFRelease(dataProvider);
    CFRelease(colorspace);
    return cgImage;
}

NSImage *toNSImage(const QPixmap &pixmap)
{
    QImage qimage = pixmap.toImage();
    NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithCGImage: qt_mac_image_to_cgimage(qimage)];
    NSImage *image = [[NSImage alloc] init];
    [image addRepresentation:bitmapRep];
    [bitmapRep release];
    return image;
}

NSString *toNSStandardItem(QtMacToolButton::StandardItem standardItem);

NSMutableArray *itemIdentifiers(const QList<QtMacToolButton *> &items, bool cullUnselectable)
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    foreach (const QtMacToolButton * item, items) {
        if (cullUnselectable && item->selectable() == false)
            continue;
        if (item->standardItem() == QtMacToolButton::NoItem) {
            [array addObject : toNSString(QString::number(qulonglong(item)))];
        } else {
            [array addObject : toNSStandardItem(item->standardItem())];
        }
    }
    return array;
}

// from qaction.cpp
QString qt_strippedText(QString s)
{
    s.remove( QString::fromLatin1("...") );
    int i = 0;
    while (i < s.size()) {
        ++i;
        if (s.at(i-1) != QLatin1Char('&'))
            continue;
        if (i < s.size() && s.at(i) == QLatin1Char('&'))
            ++i;
        s.remove(i-1,1);
    }
    return s.trimmed();
}

@implementation QtMacToolbarDelegate

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar
{
    return itemIdentifiers(self->items, false);
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar
{
    return itemIdentifiers(self->allowedItems, false);
}

- (NSArray *)toolbarSelectableItemIdentifiers: (NSToolbar *)toolbar
{
    NSMutableArray *array = itemIdentifiers(self->items, true);
    [array addObjectsFromArray :  itemIdentifiers(self->allowedItems, true)];
    return array;
}

- (IBAction)itemClicked:(id)sender
{
    NSToolbarItem *item = reinterpret_cast<NSToolbarItem *>(sender);
    QString identifier = toQString([item itemIdentifier]);
    QtMacToolButton *toolButton = reinterpret_cast<QtMacToolButton *>(identifier.toULongLong());
    if (toolButton->m_action) {
        toolButton->m_action->trigger();
    }
    toolButton->emitActivated();
}

- (NSToolbarItem *) toolbar: (NSToolbar *)toolbar itemForItemIdentifier: (NSString *) itemIdentifier willBeInsertedIntoToolbar:(BOOL) willBeInserted
{
    Q_UNUSED(toolbar);
    Q_UNUSED(willBeInserted);
    const QString identifier = toQString(itemIdentifier);

    QtMacToolButton *toolButton = reinterpret_cast<QtMacToolButton *>(identifier.toULongLong()); // string -> unisgned long long -> pointer
    NSToolbarItem *toolbarItem;
//    if (toolButton->standardItem()) {
//        toolbarItem = [NSToolbarItem alloc ]initWithItemIdentifier
//
//    } else {
        toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier: itemIdentifier] autorelease];
        [toolbarItem setLabel: toNSString(qt_strippedText(toolButton->m_action->iconText()))];
        [toolbarItem setPaletteLabel:[toolbarItem label]];
        [toolbarItem setToolTip: toNSString(toolButton->m_action->toolTip())];
//    }

    QPixmap icon = toolButton->m_action->icon().pixmap(64, 64);
    if (icon.isNull() == false) {
        [toolbarItem setImage : toNSImage(icon)];
    }

    [toolbarItem setTarget : self];
    [toolbarItem setAction : @selector(itemClicked:)];

    return toolbarItem;
}

- (QAction *)addActionWithText:(const QString *)text
{
    QIcon nullIcon;
    return [self addActionWithText:text icon:&nullIcon];
}

- (QAction *)addActionWithText:(const QString *)text icon:(const QIcon *)icon
{
    QAction *action = new QAction(*icon, *text, 0);
    QtMacToolButton *button = new QtMacToolButton(action);
    button->m_action = action;
    items.append(button);
    allowedItems.append(button);
    return action;
}

- (QAction *)addAction:(QAction *)action
{
    QtMacToolButton *button = new QtMacToolButton(action);
    button->m_action = action;
    items.append(button);
    allowedItems.append(button);
    return action;
}

- (QAction *)addStandardItem:(QtMacToolButton::StandardItem) standardItem
{
    QAction *action = new QAction(0);
    QtMacToolButton *button = new QtMacToolButton(action);
    button->m_action = action;
    button->setStandardItem(standardItem);
    items.append(button);
    allowedItems.append(button);
    return action;
}

- (QAction *)addAllowedActionWithText:(const QString *)text
{
    QIcon nullIcon;
    return [self addAllowedActionWithText:text icon:&nullIcon];
}

- (QAction *)addAllowedActionWithText:(const QString *)text icon:(const QIcon *)icon
{
    QAction *action = new QAction(*icon, *text, 0);
    QtMacToolButton *button = new QtMacToolButton(action);
    button->m_action = action;
    allowedItems.append(button);
    return action;
}

- (QAction *)addAllowedAction:(QAction *)action
{
    QtMacToolButton *button = new QtMacToolButton(action);
    button->m_action = action;
    allowedItems.append(button);
    return action;
}

- (QAction *)addAllowedStandardItem:(QtMacToolButton::StandardItem)standardItem
{
    QAction *action = new QAction(0);
    QtMacToolButton *button = new QtMacToolButton(action);
    button->m_action = action;
    button->setStandardItem(standardItem);
    allowedItems.append(button);
    return action;
}

@end
