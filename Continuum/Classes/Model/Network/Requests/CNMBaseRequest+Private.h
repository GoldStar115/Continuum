/**
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
#import "CNMBaseRequest.h"


#pragma mark Private interface declaration

@interface CNMBaseRequest ()


#pragma mark - Properties

/**
 @brief  Stores base URL against which requests should be done.
 */
@property (nonatomic, copy) NSURL *baseURL;

/**
 @brief  Stores reference on remote resource path.
 */
@property (nonatomic, copy) NSString *path;

/**
 @brief  Stores reference on dictionary with key/value pairs which should be used as query parameters.
 */
@property (nonatomic, copy) NSDictionary *query;

/**
 @brief  Stores reference on key/value HTTP header fields.
 */
@property (nonatomic, copy) NSDictionary *HTTPHeaders;

/**
 @brief  Stores reference on started task instance.
 */
@property (nonatomic) NSURLSessionDataTask *activeTask;


#pragma mark - Initialization and Configuration

/**
 @brief  Initialize request model instance.
 
 @param url Base remote data provider address.
 
 @return Initialized and ready to use request model instance.
 */
- (instancetype)initWithBaseURL:(NSURL *)url;

#pragma mark -


@end
