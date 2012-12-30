#ifndef WINDOW_H
#define WINDOW_H

#include <QWidget>
#include "qtmactoolbutton.h"

namespace Ui {
class Window;
}

class WindowPrivate;
class Window : public QWidget
{
    Q_OBJECT

public:
    explicit Window(QWidget *parent = 0);
    ~Window();

private slots:
    void changeDisplayMode(int);
    void displayModeChanged(Qt::ToolButtonStyle);

    void changeSizeMode(int);
    void sizeModeChanged(QtMacToolButton::IconSize);

    void positionWindow();

private:
    WindowPrivate *d;
    Ui::Window *ui;
};

#endif // WINDOW_H
