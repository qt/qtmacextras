#include <QString>
#include <QtTest>
#include <QCoreApplication>
#include <QtWidgets/QMenu>
#include <QtWidgets/QMenuBar>
#include <QtWidgets/QMainWindow>
#include "../../src/qtmacfunctions.h"

#import <AppKit/AppKit.h>

class tst_QtMacFunctions : public QObject
{
    Q_OBJECT

public:
    tst_QtMacFunctions();

private Q_SLOTS:
    void testQMenuToNSMenu();
};

tst_QtMacFunctions::tst_QtMacFunctions()
{
}

void tst_QtMacFunctions::testQMenuToNSMenu()
{
    QMainWindow window;
    QMenu *qMenu = new QMenu("Menu", &window);
    QAction *action = new QAction("&Item", &window);
    qMenu->addAction(action);
    window.menuBar()->addMenu(qMenu);

    NSMenu *nsMenu = toNSMenu(qMenu);
    QVERIFY(nsMenu != NULL);
    QCOMPARE([[nsMenu title] UTF8String], "Menu");

    NSMenuItem *item = [nsMenu itemAtIndex:0];
    QCOMPARE([[item title] UTF8String], "Item");
}

QTEST_MAIN(tst_QtMacFunctions)

#include "tst_qtmacfunctions.moc"
