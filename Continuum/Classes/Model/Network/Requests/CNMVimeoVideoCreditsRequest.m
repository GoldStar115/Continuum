//
//  CNMVimeoVideoCreditsRequest.m
//  Continuum
//
//  Created by Sergey Mamontov on 2/25/16.
//  Copyright © 2016 Continuum LLC. All rights reserved.
//

#import "CNMVimeoVideoCreditsRequest.h"
#import "CNMBaseRequest+Private.h"
#import "CNMVideo.h"


#pragma mark Private interface declaration

@interface CNMVimeoVideoCreditsRequest ()


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
- (NSString *)pathForVideoCredits:(CNMVideo *)video;

/**
 @brief  Compose query dictionary which will have information to request required portion of data.
 
 @return Configured and ready to use query dictionary.
 */
- (NSDictionary *)query;

#pragma mark -


@end



#pragma mark - Interface implementation

@implementation CNMVimeoVideoCreditsRequest


#pragma mark - Initialization and Configuration

+ (instancetype)requestForVideo:(CNMVideo *)video {
    
    return [[self alloc] initForVideo:video];
}

- (instancetype)initForVideo:(CNMVideo *)video {
    
    // Check whether initialization was successful or not.
    if ((self = [super init])) {
        
        self.path = [self pathForVideoCredits:video];
    }
    
    return self;
}


#pragma mark - Misc

- (NSString *)pathForVideoCredits:(CNMVideo *)video {
    
    return [NSString stringWithFormat:@"/videos/%@/credits", video.identifier];
}

- (NSDictionary *)query {
    
    return @{@"fields": @"role,name"};
}

#pragma mark -


@end
