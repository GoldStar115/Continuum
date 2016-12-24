#import <UIKit/UIKit.h>


/**
 @brief  Useful UIScreen class extensions for application.
 
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum Luxury, LLC.
 */
@interface UIScreen (CNMAdditions)


///------------------------------------------------
/// @name Information
///------------------------------------------------

/**
 @brief  Screen size (diagonal) in inches which can be used by UI
         elements to pick up proper layout way.
 */
@property (nonatomic, readonly) NSNumber * diagonal;

#pragma mark -


@end
