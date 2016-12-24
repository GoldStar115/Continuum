#import <UIKit/UIKit.h>


#pragma mark Class forward

@class CNMVideoFeedManager, CNMVideo;


NS_ASSUME_NONNULL_BEGIN

/**
 @brief  View controller which is responsible for user video player interface presentation.
 
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
@interface CNMVideoViewController : UIViewController


///------------------------------------------------
/// @name Configuration
///------------------------------------------------

/**
 @brief  Prepare video controller to present \c video.
 
 @param video   Reference on video entry which should be shown to the user.
 @param manager Reference on manager which can be used in case if not full video data available.
 */
- (void)prepareForVideo:(CNMVideo *)video withManager:(CNMVideoFeedManager *)manager;

#pragma mark - 


@end

NS_ASSUME_NONNULL_END
