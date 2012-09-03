#include "qtmacunifiedtoolbar.h"
#include <QApplication>

int main(int argc, char **argv)
{
    QApplication app(argc, argv);

    QWidget widget;
    widget.resize(300, 300);
    widget.setWindowTitle("Qt Mac Toolbar Example");

    QtMacUnifiedToolBar toolBar;
    toolBar.addAction(QIcon(":/qtlogo.png"), "Hello");
    toolBar.addAction(QIcon(":/qtlogo.png"), "World");
    toolBar.addStandardItem(QtMacToolButton::FlexibleSpace);
    toolBar.addStandardItem(QtMacToolButton::ShowColors);
    toolBar.addStandardItem(QtMacToolButton::ShowFonts);

    toolBar.addAllowedAction(QIcon(":/qtlogo.png"), "Extra Button 1");
    toolBar.addAllowedAction(QIcon(":/qtlogo.png"), "Extra Button 2");

    toolBar.showInWindow(widget.windowHandle());
    widget.show();

    return app.exec();
}

