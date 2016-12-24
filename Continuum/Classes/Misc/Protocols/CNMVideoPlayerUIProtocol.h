#import <Foundation/Foundation.h>


/**
 @brief  Describe protocol which is required to communicate with player's UI representer.
 
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
@protocol CNMVideoPlayerUIProtocol <NSObject>


///------------------------------------------------
/// @name Appearance
///------------------------------------------------

/**
 @brief  Notify delegate about interface appearance change.
 */
- (void)willHideInterface;
- (void)willShowInterface;

#pragma mark -


@end
