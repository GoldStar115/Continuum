#import <Foundation/Foundation.h>


/**
 @brief  Basic remote resource description used by network manager.
 
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
@interface CNMBaseRequest : NSObject


///------------------------------------------------
/// @name Initialization and Configuration
///------------------------------------------------

/**
 @brief  Construct and configure request model instance.
 
 @param url Base remote data provider address.
 
 @return Configured and ready to use request model instance.
 */
+ (instancetype)requestWithBaseURL:(NSURL *)url;


///------------------------------------------------
/// @name Serialization
///------------------------------------------------

/**
 @brief  Basing on passed by subclass data build request URL.
 
 @return Configured and ready to use request instance.
 */
- (NSURLRequest *)request;

#pragma mark -


@end
