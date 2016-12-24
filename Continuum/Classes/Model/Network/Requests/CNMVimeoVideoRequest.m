/**
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
#import "CNMVimeoVideoRequest.h"
#import "CNMBaseRequest+Private.h"
#import "CNMVideo.h"


#pragma mark Private interface declaration

@interface CNMVimeoVideoRequest ()


#pragma mark - Initialization and Configuration

/**
 @brief  Create and configure video data fetch request.
 
 @param video Reference on video entry for which information should be retrieved.
 
 @return Configured and ready to use request.
 */
- (instancetype)initForVideo:(CNMVideo *)video;


#pragma mark - Misc

/**
 @brief  Compose remote resource request path.
 
 @param video Reference on video feed entry data model for which path should be composed.
 
 @return Request path which can be used to access video data from remote data provider channel.
 */
- (NSString *)pathForVideo:(CNMVideo *)video;

#pragma mark -


@end



#pragma mark - Interface implementation

@implementation CNMVimeoVideoRequest


#pragma mark - Initialization and Configuration

+ (instancetype)requestForVideo:(CNMVideo *)video {
    
    return [[self alloc] initForVideo:video];
}

- (instancetype)initForVideo:(CNMVideo *)video {
    
    // Check whether initialization was successful or not.
    if ((self = [super init])) {
        
        self.path = [self pathForVideo:video];
    }
    
    return self;
}


#pragma mark - Misc

- (NSString *)pathForVideo:(CNMVideo *)video {
    
    return [NSString stringWithFormat:@"/videos/%@", video.identifier];
}

#pragma mark -


@end
