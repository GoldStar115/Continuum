#import <Foundation/Foundation.h>


#pragma mark Class forward

@class CNMBaseRequest;


NS_ASSUME_NONNULL_BEGIN

/**
 @brief  Manager which provide ability to perform network requests to pull out JSON data from remote data 
         proviers.
 
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
@interface CNMNetorkManager : NSObject


///------------------------------------------------
/// @name Requests
///------------------------------------------------

/**
 @brief  Perform network request using model which describe remote resource url.
 
 @param request Reference on model which describe remote resource.
 @param block   Reference on block which will be called on main queue and pass two arguments: 
                \c JSONObject - reference on parsed JSON object; \c error - reference on error which describe
                request issues.
 
 @return Currently active request instance.
 */
- (id)fetchJSONWithRequest:(CNMBaseRequest *)request 
           completionBlock:(void(^)(id JSONObject, NSError * _Nullable error))block;

/**
 @brief  Stop remote data request.
 
 @param request Reference on request instance which has required information about data request.
 */
- (void)cancelRequest:(CNMBaseRequest *)request;

#pragma mark -


@end

NS_ASSUME_NONNULL_END
