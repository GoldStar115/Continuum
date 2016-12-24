#import <Foundation/Foundation.h>


#pragma mark Class forward

@class CNMVideo;


NS_ASSUME_NONNULL_BEGIN

/**
 @brief  Manager which provide entry point to retrieve required data feed from remote data provider.
 
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
@interface CNMVideoFeedManager : NSObject


///------------------------------------------------
/// @name Initialization and Configuration
///------------------------------------------------

/**
 @brief  Create and configure manager instance to operate with predefined configuration.

 @param token Reference on service-generated persistent access token with required access rights.
 
 @return Configured and ready to use viedeo feed manager.
 */
+ (instancetype)managerWithClientAccessToken:(NSString *)token;


///------------------------------------------------
/// @name Feed data
///------------------------------------------------

/**
 @brief  Specify concrete channel identifier from which video feed information should be retrieved.
 
 @param ientifier Data channel identifier on remote data provider.
 */
- (void)setChannelIentifier:(NSString *)identifier;

/**
 @brief  Fetch latest data from video feed.
 
 @param block Reference on block which should be called at the end of fetching process. Block pass array of 
              video entry instances or error instance.
 */
- (void)fetchNewestFeedWithCompletion:(void(^)(NSArray<CNMVideo *> *feed, NSError * _Nullable error))block;

/**
 @brief      Fetch next portion of data from video feed.
 @discussion This feature is possible when remote data provier support pagination.
 
 @param block Reference on block which should be called at the end of fetching process. Block pass array of 
              video entry instances or error instance.
 */
- (void)fetchNextFeedPageWithCompletion:(void(^)(NSArray<CNMVideo *> *feed, NSError * _Nullable error))block;

/**
 @brief      Fetch updates for video feed entry by request.
 @discussion Method can be used to receive data in case if previously video was in \c transcoding state.
 
 @param video Reference on video entry data model for which data should be pulled out.
 @param block Reference on block which should be called at the end of data fetching process.
 */
- (void)fetchAndUpdateDataForVideo:(CNMVideo *)video withCompletion:(dispatch_block_t)block;

#pragma mark -


@end

NS_ASSUME_NONNULL_END
