/**
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
#import "CNMTabBarController.h"


#pragma mark Private interface declaration

@interface CNMTabBarController ()


#pragma mark - Interface customization

/**
 @brief  Upate view controllers' tab bar items layout.
 */
- (void)upateTabBarItems;

#pragma mark -


@end


#pragma mark - Private interface declaration

@implementation CNMTabBarController


#pragma mark - Controller life-cycle methods

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return UIInterfaceOrientationPortrait;
}

- (void)viewDidLoad {
    
    // Forard method call to the super class.
    [super viewDidLoad];
    
    [self upateTabBarItems];
}


#pragma mark - Interface customization

- (void)upateTabBarItems {
    
    NSArray *tabBarIconNames = @[@"tab-button-feed-icon", @"tab-button-contact-icon",
                                 @"tab-button-rss-icon", @"tab-button-donation-icon"];
    NSArray *items = [self.viewControllers valueForKey:@"tabBarItem"];
    [items enumerateObjectsUsingBlock:^(UITabBarItem *item, NSUInteger itemIdx, BOOL *itemsEnumeratorStop) {
        
        UIImage *icon = [UIImage imageNamed:tabBarIconNames[itemIdx]];
        item.image = [icon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }];
}

#pragma mark -


@end
