#include "window.h"
#include "ui_window.h"
#include "qtmacunifiedtoolbar.h"
#include <QDesktopWidget>
#include <QTimer>

class WindowPrivate
{
public:
    QtMacUnifiedToolBar *toolBar;
};

Window::Window(QWidget *parent) :
    QWidget(parent),
    d(new WindowPrivate),
    ui(new Ui::Window)
{
    ui->setupUi(this);

    d->toolBar = new QtMacUnifiedToolBar(this);
    d->toolBar->addAction(QIcon(":/qtlogo.png"), "Hello");
    d->toolBar->addAction(QIcon(":/qtlogo.png"), "World");
    d->toolBar->addStandardItem(QtMacToolButton::FlexibleSpace);
    d->toolBar->addStandardItem(QtMacToolButton::ShowColors);
    d->toolBar->addStandardItem(QtMacToolButton::ShowFonts);
    d->toolBar->addStandardItem(QtMacToolButton::PrintItem);

    d->toolBar->addAllowedAction(QIcon(":/qtlogo.png"), "Extra Button 1");
    d->toolBar->addAllowedAction(QIcon(":/qtlogo.png"), "Extra Button 2");

    d->toolBar->showInWindowForWidget(this);

    connect(d->toolBar, SIGNAL(toolButtonStyleChanged(Qt::ToolButtonStyle)), SLOT(displayModeChanged(Qt::ToolButtonStyle)));
    ui->displayModeComboBox->setCurrentIndex(d->toolBar->toolButtonStyle());

    connect(d->toolBar, SIGNAL(iconSizeChanged(QtMacToolButton::IconSize)), SLOT(sizeModeChanged(QtMacToolButton::IconSize)));
    ui->sizeModeComboBox->setCurrentIndex(d->toolBar->iconSizeType());

    connect(ui->visibleCheckBox, SIGNAL(clicked(bool)), d->toolBar, SLOT(setVisible(bool)));
    connect(d->toolBar, SIGNAL(visibilityChanged(bool)), ui->visibleCheckBox, SLOT(setChecked(bool)));
    ui->visibleCheckBox->setChecked(d->toolBar->isVisible());

    connect(ui->showsBaselineSeparatorCheckBox, SIGNAL(clicked(bool)), d->toolBar, SLOT(setShowsBaselineSeparator(bool)));
    connect(d->toolBar, SIGNAL(showsBaselineSeparatorChanged(bool)), ui->showsBaselineSeparatorCheckBox, SLOT(setChecked(bool)));
    ui->showsBaselineSeparatorCheckBox->setChecked(d->toolBar->showsBaselineSeparator());

    connect(ui->allowsUserCustomizationCheckBox, SIGNAL(clicked(bool)), d->toolBar, SLOT(setAllowsUserCustomization(bool)));
    connect(d->toolBar, SIGNAL(allowsUserCustomizationChanged(bool)), ui->allowsUserCustomizationCheckBox, SLOT(setChecked(bool)));
    ui->allowsUserCustomizationCheckBox->setChecked(d->toolBar->allowsUserCustomization());

    connect(ui->showCustomizationSheetPushButton, SIGNAL(clicked()), d->toolBar, SLOT(showCustomizationSheet()));
    connect(d->toolBar, SIGNAL(allowsUserCustomizationChanged(bool)), ui->showCustomizationSheetPushButton, SLOT(setEnabled(bool)));
    ui->showCustomizationSheetPushButton->setEnabled(d->toolBar->allowsUserCustomization());

    QTimer::singleShot(0, this, SLOT(positionWindow()));
}

Window::~Window()
{
    delete ui;
    delete d;
}

void Window::changeDisplayMode(int toolButtonStyle)
{
    d->toolBar->setToolButtonStyle(static_cast<Qt::ToolButtonStyle>(toolButtonStyle));
}

void Window::displayModeChanged(Qt::ToolButtonStyle toolButtonStyle)
{
    ui->displayModeComboBox->setCurrentIndex(toolButtonStyle);
}

void Window::changeSizeMode(int sizeMode)
{
    d->toolBar->setIconSize(static_cast<QtMacToolButton::IconSize>(sizeMode));
}

void Window::sizeModeChanged(QtMacToolButton::IconSize size)
{
    ui->sizeModeComboBox->setCurrentIndex(size);
}

void Window::positionWindow()
{
    resize(QSize());
    setGeometry(QStyle::alignedRect(Qt::LeftToRight, Qt::AlignCenter, size(), qApp->desktop()->availableGeometry()));
}
