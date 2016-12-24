#import "CNMBaseRequest.h"


NS_ASSUME_NONNULL_BEGIN

/**
 @brief  Request model which describe basic request for Vimeo as remote data provier.
 
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
@interface CNMVimeoRequest : CNMBaseRequest


///------------------------------------------------
/// @name Initialization and Configuration
///------------------------------------------------

/**
 @brief  Configure access token which should be used to perform authorized requests to remote data provider.
 
 @param token Reference on token which should be passed in headers.
 */
+ (void)setAccessToken:(NSString *)token;

#pragma mark -


@end

NS_ASSUME_NONNULL_END
