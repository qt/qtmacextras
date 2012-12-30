#import "qtnstoolbar.h"

NSString *QtNSToolbarDisplayModeChangedNotification = @"QtNSToolbarDisplayModeChangedNotification";
NSString *QtNSToolbarShowsBaselineSeparatorChangedNotification = @"QtNSToolbarShowsBaselineSeparatorChangedNotification";
NSString *QtNSToolbarAllowsUserCustomizationChangedNotification = @"QtNSToolbarAllowsUserCustomizationChangedNotification";
NSString *QtNSToolbarSizeModeChangedNotification = @"QtNSToolbarSizeModeChangedNotification";
NSString *QtNSToolbarVisibilityChangedNotification = @"QtNSToolbarVisibilityChangedNotification";

@implementation QtNSToolbar

- (void)setDisplayMode:(NSToolbarDisplayMode)displayMode
{
    if ([self displayMode] != displayMode)
    {
        [super setDisplayMode:displayMode];
        [[NSNotificationCenter defaultCenter] postNotificationName:QtNSToolbarDisplayModeChangedNotification object:self];
    }
}

- (void)setShowsBaselineSeparator:(BOOL)flag
{
    if ([self showsBaselineSeparator] != flag)
    {
        [super setShowsBaselineSeparator:flag];
        [[NSNotificationCenter defaultCenter] postNotificationName:QtNSToolbarShowsBaselineSeparatorChangedNotification object:self];
    }
}

- (void)setAllowsUserCustomization:(BOOL)allowsCustomization
{
    if ([self allowsUserCustomization] != allowsCustomization)
    {
        [super setAllowsUserCustomization:allowsCustomization];
        [[NSNotificationCenter defaultCenter] postNotificationName:QtNSToolbarAllowsUserCustomizationChangedNotification object:self];
    }
}

- (void)setSizeMode:(NSToolbarSizeMode)sizeMode
{
    if ([self sizeMode] != sizeMode)
    {
        [super setSizeMode:sizeMode];
        [[NSNotificationCenter defaultCenter] postNotificationName:QtNSToolbarSizeModeChangedNotification object:self];
    }
}

- (void)setVisible:(BOOL)shown
{
    BOOL isVisible = [self isVisible];
    [super setVisible:shown];

    // The super call might not always have effect - i.e. trying to hide the toolbar when the customization palette is running
    if ([self isVisible] != isVisible)
        [[NSNotificationCenter defaultCenter] postNotificationName:QtNSToolbarVisibilityChangedNotification object:self];
}

@end
