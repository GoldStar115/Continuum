#import "CNMVimeoRequest.h"


#pragma mark Class forward

@class CNMVideo;


NS_ASSUME_NONNULL_BEGIN

/**
 @brief  Request model which describe way to retrieve single video entry credits information from remote data 
         provider.
 
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
@interface CNMVimeoVideoCreditsRequest : CNMVimeoRequest


///------------------------------------------------
/// @name Initialization and Configuration
///------------------------------------------------

/**
 @brief  Create and configure video data fetch request.
 
 @param video Reference on video entry for which credits information should be retrieved.
 
 @return Configured and ready to use request.
 */
+ (instancetype)requestForVideo:(CNMVideo *)video;

#pragma mark -


@end

NS_ASSUME_NONNULL_END
