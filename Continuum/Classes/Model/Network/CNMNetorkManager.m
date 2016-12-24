/**
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
#import "CNMNetorkManager.h"
#import "CNMBaseRequest+Private.h"
#import <libkern/OSAtomic.h>


#pragma mark Private interface declaration

@interface CNMNetorkManager () <NSURLSessionDelegate>


#pragma mark - Properties

/**
 @brief  Stores reference on queue which should be used for
         data processing.
 */
@property (nonatomic) dispatch_queue_t parsingQueue;

/**
 @brief  Stores reference on session instance which is used to 
         send network requests.
 */
@property (nonatomic) NSURLSession *session;

/**
 @brief  Stores reference on lock which is used in critical data
         access sections.
 */
@property (nonatomic, assign) OSSpinLock lock;


#pragma mark - Handlers

/**
 @brief  Handle data task request completion.
 
 @param task         Reference on task which has been used by URL session.
 @param data         Response binary object.
 @param response     HTTP response with all required HTTP fields.
 @param requestError Reference on request processing error.
 @param block        Reference on block which will be called on main queue to notify about requests processing
                     results.
 */
- (void)handleDataTaskResponseFor:(NSURLSessionDataTask *)task withData:(NSData *)data
                         response:(NSHTTPURLResponse *)response error:(NSError *)requestError 
                  completionBlock:(void (^)(id JSONObject, NSError *error))block;


#pragma mark - Misc

/**
 @brief  Configure URL session instance for further usage with requests.
 */
- (void)prepareURLSession;

/**
 @brief  Network request session configuration.
 
 @return Configured and ready to use session configuration instance.
 */
- (NSURLSessionConfiguration *)sessionConfiguration;

/**
 @brief  Requests operation queue (queue on which requests performed).
 
 @param Reference on session configuration instance.
 
 @return Configured and ready to use operations queue.
 */
- (NSOperationQueue *)operationQueueWithConfiguration:(NSURLSessionConfiguration *)configuration;

/**
 @brief  Initialize network session instance using user-provied configuration.
 
 @param configuration Reference on session configuration instance.
 
 @return Configured session for network request session.
 */
- (NSURLSession *)sessionWithConfiguration:(NSURLSessionConfiguration *)configuration;

/**
 @brief  Extract data received from remote data provider.
 
 @param data                 Reference on data retrieved from remote data provider.
 @param deserializationError Reference on pointer where de-serialization error should be stored.
 */
- (id)deserializedResponseFromData:(NSData *)data withError:(NSError *__autoreleasing *)deserializationError;

#pragma mark -


@end


#pragma mark - Interface implementation

@implementation CNMNetorkManager


#pragma mark - Initialization and Configuration

- (instancetype)init {
    
    // Check whether initialization was successful or not.
    if ((self = [super init])) {
        
        _parsingQueue = dispatch_queue_create("com.continuumluxury.continuum.network", DISPATCH_QUEUE_CONCURRENT);
        _lock = OS_SPINLOCK_INIT;
        [self prepareURLSession];
    }
    
    return self;
}

#pragma mark - Requests

- (id)fetchJSONWithRequest:(CNMBaseRequest *)request 
           completionBlock:(void(^)(id JSONObject, NSError *error))block {
    
    __block NSURLSessionDataTask *task = nil;
    __weak __typeof(self) weakSelf = self;
    
    OSSpinLockLock(&_lock);
    task = [self.session dataTaskWithRequest:request.request 
                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        [weakSelf handleDataTaskResponseFor:task withData:data response:(NSHTTPURLResponse *)response
                                      error:(error?: task.error) completionBlock:block];
    }];
    OSSpinLockUnlock(&_lock);
    request.activeTask = task;
    [task resume];
    
    return request;
}

- (void)cancelRequest:(CNMBaseRequest *)request {
    
    OSSpinLockLock(&_lock);
    [request.activeTask cancel];
    request.activeTask = nil;
    OSSpinLockUnlock(&_lock);
}


#pragma mark - Handlers

- (void)handleDataTaskResponseFor:(NSURLSessionDataTask *)task withData:(NSData *)data
                         response:(NSHTTPURLResponse *)response error:(NSError *)requestError 
                  completionBlock:(void (^)(id JSONObject, NSError *error))block {
    
    dispatch_async(self.parsingQueue, ^{

        NSError *serializationError = nil;
        id processedObject = [self deserializedResponseFromData:data withError:&serializationError];
        NSError *error = ((requestError.code == NSURLErrorCancelled ? nil : requestError)?: serializationError);
        dispatch_async(dispatch_get_main_queue(), ^{ block(processedObject, error); });
    });
}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error {
    
    if (error) {
        
        OSSpinLockLock(&_lock);
        [self prepareURLSession];
        OSSpinLockUnlock(&_lock);
    }
}


#pragma mark - Misc

- (void)prepareURLSession {
    
    _session = [self sessionWithConfiguration:[self sessionConfiguration]];
}

- (NSURLSessionConfiguration *)sessionConfiguration {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    configuration.URLCache = nil;
    configuration.HTTPShouldUsePipelining = YES;
    configuration.timeoutIntervalForRequest = 10.0f;
    configuration.HTTPMaximumConnectionsPerHost = 5;
    configuration.HTTPAdditionalHeaders = @{@"Accept-Encoding": @"gzip,deflate", @"Connection": @"keep-alive"};
    
    return configuration;
}

- (NSOperationQueue *)operationQueueWithConfiguration:(NSURLSessionConfiguration *)configuration {
    
    NSOperationQueue *queue = [NSOperationQueue new];
    queue.maxConcurrentOperationCount = configuration.HTTPMaximumConnectionsPerHost;
    
    return queue;
}

- (NSURLSession *)sessionWithConfiguration:(NSURLSessionConfiguration *)configuration {
    
    NSOperationQueue *queue = [self operationQueueWithConfiguration:configuration];
    
    return [NSURLSession sessionWithConfiguration:configuration delegate:self
                                    delegateQueue:queue];
}

- (id)deserializedResponseFromData:(NSData *)data withError:(NSError *__autoreleasing *)deserializationError {
    
    id deserializedResponse = nil;
    if ([data length]) {
        
        @autoreleasepool {
            
            NSError *JSONDeserializationError = nil;
            deserializedResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:(NSJSONReadingOptions)0
                                                                     error:&JSONDeserializationError];
            *deserializationError = JSONDeserializationError;
        }
    }
    
    return deserializedResponse;
}

#pragma mark -


@end
