/**
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
#import "CNMBaseRequest+Private.h"


#pragma mark Private interface declaration

@interface CNMBaseRequest (Private)


#pragma mark - Misc

/**
 @brief  Compose full remote resource URL.
 
 @return Remote resource URL instance.
 */
- (NSURL *)resourceURL;

#pragma mark -


@end


#pragma mark - Interface implementation

@implementation CNMBaseRequest


#pragma mark - Initialization and Configuration

+ (instancetype)requestWithBaseURL:(NSURL *)url {
    
    return [[self alloc] initWithBaseURL:url];
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    
    // Check whether initialization was successful or not.
    if ((self = [super init])) {
        
        _baseURL = url;
    }
    
    return self;
}


#pragma mark - Serialization

- (NSURLRequest *)request {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self resourceURL]];
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    request.allHTTPHeaderFields = self.HTTPHeaders;
    request.HTTPMethod = @"GET";
    
    return request;
}


#pragma mark - Misc

- (NSURL *)resourceURL {
    
    NSMutableString *urlString = [NSMutableString stringWithString:self.path];
    NSMutableArray *queryPairs = [NSMutableArray new];
    [self.query enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *queryFieldsEnumeratorStop) {
        
        [queryPairs addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
    }];
    if (queryPairs.count) { [urlString appendFormat:@"?%@", [queryPairs componentsJoinedByString:@"&"]]; }
    
    return [NSURL URLWithString:urlString relativeToURL:self.baseURL];
}

#pragma mark -


@end
