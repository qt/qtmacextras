#ifndef QTNSTOOLBAR_H
#define QTNSTOOLBAR_H

#include <AppKit/NSToolbar.h>

extern NSString *QtNSToolbarDisplayModeChangedNotification;
extern NSString *QtNSToolbarShowsBaselineSeparatorChangedNotification;
extern NSString *QtNSToolbarAllowsUserCustomizationChangedNotification;
extern NSString *QtNSToolbarSizeModeChangedNotification;
extern NSString *QtNSToolbarVisibilityChangedNotification;

@interface QtNSToolbar : NSToolbar

@end

#endif // QTNSTOOLBAR_H
