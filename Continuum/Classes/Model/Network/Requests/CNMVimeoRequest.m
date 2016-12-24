/**
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
#import "CNMVimeoRequest.h"
#import "CNMBaseRequest+Private.h"


#pragma mark Static

/**
 @brief  Stores remote data provider base URL against which access should be done.
 */
static NSString * const kCNMRemoteDataProvierBaseURL = @"https://api.vimeo.com";

/**
 @brief  Stores user-provided access token which shoul be used with requests.
 */
static NSString *CNMAccessToken;


#pragma mark - Private interface declaration

@interface CNMVimeoRequest ()


#pragma mark - Misc

/**
 @brief  Compose headers which is required to complete authorized request.
 */
- (NSDictionary *)requestHeaders;


#pragma mark -


@end


#pragma mark - Interface implementation

@implementation CNMVimeoRequest


#pragma mark - Initialization and Configuration

+ (void)setAccessToken:(NSString *)token {
    
    CNMAccessToken = token;
}

- (instancetype)init {
    
    // Check whether initialization was successful or not.
    if ((self = [super initWithBaseURL:[NSURL URLWithString:kCNMRemoteDataProvierBaseURL]])) {
        
        self.HTTPHeaders = [self requestHeaders];
    }
    
    return self;
}

- (NSDictionary *)requestHeaders {
    
    static NSDictionary *_channelRequestHeaders;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _channelRequestHeaders = @{@"Accept": @"application/vnd.vimeo.*+json; version=3.2",
                                   @"Authorization": [NSString stringWithFormat:@"Bearer %@", CNMAccessToken]};
    });
    
    return _channelRequestHeaders;
}

#pragma mark -


@end
