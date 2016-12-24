#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

/**
 @brief  Application entry point class which will handle and process application events.
 
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
@interface CNMApplicationDelegate : UIResponder <UIApplicationDelegate>


///------------------------------------------------
/// @name Properties
///------------------------------------------------

/**
 @brief  Stores reference on window which is used for user interface layout.
 */
@property (strong, nonatomic) UIWindow *window;


#pragma mark -


@end

NS_ASSUME_NONNULL_END
