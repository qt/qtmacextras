/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the test suite of the Qt Toolkit.
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

#include <QApplication>
#include <QDebug>
#include <QHBoxLayout>
#include <QLineEdit>
#include <QPainter>
#include <QPushButton>
#include <QVBoxLayout>
#include <QWidget>
#include <Cocoa/Cocoa.h>
#include <qmacnativewidget.h>

class RedWidget : public QWidget
{
public:
    RedWidget() {

    }

    void resizeEvent(QResizeEvent *)
    {
        qDebug() << "RedWidget::resize" << size();
    }

    void paintEvent(QPaintEvent *event)
    {
        QPainter p(this);
        Q_UNUSED(event);
        QRect rect(QPoint(0, 0), size());
        qDebug() << "Painting geometry" << rect;
        p.fillRect(rect, QColor(133, 50, 50));
    }
};

@interface WindowCreator : NSObject {}
- (void)createWindow;
@end

@implementation WindowCreator
- (void)createWindow {

    // Create the NSWindow
    NSRect frame = NSMakeRect(500, 500, 500, 500);
    NSWindow* window  = [[NSWindow alloc] initWithContentRect:frame
                        styleMask:NSTitledWindowMask |  NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask
                        backing:NSBackingStoreBuffered
                        defer:NO];
    [window setTitle:@"NSWindow"];

    // Create widget hierarchy with QPushButton and QLineEdit
    QMacNativeWidget *nativeWidget = new QMacNativeWidget();

    QHBoxLayout *hlayout = new QHBoxLayout();
    hlayout->addWidget(new QPushButton("Push", nativeWidget));
    hlayout->addWidget(new QLineEdit);

    QVBoxLayout *vlayout = new QVBoxLayout();
    vlayout->addLayout(hlayout);

    //RedWidget * redWidget = new RedWidget;
    //vlayout->addWidget(redWidget);

    nativeWidget->setLayout(vlayout);

    // Get the NSView for QMacNativeWidget and set it as the content view for the NSWindow
    [window setContentView:nativeWidget->nativeView()];

    // show() must be called on nativeWiget to get the widgets int he correct state.
    nativeWidget->show();

    // Show the NSWindow
    [window makeKeyAndOrderFront:NSApp];
}
@end

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    // Start Cocoa. Create NSApplicaiton.
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    [NSApplication sharedApplication];

    // Schedule call to create the UI using a zero timer.
    WindowCreator *windowCreator= [WindowCreator alloc];
    [NSTimer scheduledTimerWithTimeInterval:0 target:windowCreator selector:@selector(createWindow) userInfo:nil repeats:NO];

    // Stare the Cocoa event loop.
    [(NSApplication *)NSApp run];
    [NSApp release];
    [pool release];
    exit(0);
    return 0;
}



