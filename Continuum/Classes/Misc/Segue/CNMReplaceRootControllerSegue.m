/**
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
#import "CNMReplaceRootControllerSegue.h"


#pragma mark Interface implementation

@implementation CNMReplaceRootControllerSegue


#pragma mark - Transition

- (void)perform {
    
    UIApplication *application = [UIApplication sharedApplication];
    UIView *destinationView = [self.destinationViewController view];
    UIView *sourceView = [self.sourceViewController view];
    UIWindow *activeWindow = application.keyWindow;
    [UIView transitionFromView:sourceView toView:destinationView duration:0.4f 
                       options:(UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionTransitionCrossDissolve)
                    completion:^(BOOL finished) {
                        
        ((UITabBarController *)self.destinationViewController).delegate = (id<UITabBarControllerDelegate>)application.delegate;
        activeWindow.rootViewController = self.destinationViewController;
    }];
}

#pragma mark -


@end
