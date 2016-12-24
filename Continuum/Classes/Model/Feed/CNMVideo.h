#import <Foundation/Foundation.h>


#pragma mark Class forward

@class CNMVideoPreset;


NS_ASSUME_NONNULL_BEGIN

/**
 @brief  Model which contain only required set of fields to represent wide in feed stream.
 
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
@interface CNMVideo : NSObject


///------------------------------------------------
/// @name Information
///------------------------------------------------

/**
 @brief  Stores reference on video identifier on remote data provider database.
 */
@property (nonatomic, readonly, copy) NSString *identifier;

/**
 @brief  Stores reference on video idx where oldest video has smaller index value.
 */
@property (nonatomic, readonly, copy) NSNumber *idx;

/**
 @brief  Stores reference on full image path which has been choosed basing on device screen resolution.
 */
@property (nonatomic, nullable, readonly, copy) NSString *imagePath;

/**
 @brief  Stores name of the video.
 */
@property (nonatomic, readonly, copy) NSString *name;

/**
 @brief  Stores reference on name of the author who created this video.
 */
@property (nonatomic, nullable, readonly, copy) NSString *author;

/**
 @brief  Stores video creation date which has been received from remote data provider.
 */
@property (nonatomic, readonly, strong) NSDate *creationDate;

/**
 @brief  Stores reference on list of video file presets.
 */
@property (nonatomic, nullable, readonly, strong) NSArray<CNMVideoPreset *> *presets;


#pragma mark - Configuration

/**
 @brief  Update video credits information using passed object.
 
 @param data Reference on array of video credits.
 */
- (void)updateCredits:(NSArray<NSDictionary<NSString *, id> *> *)data;

/**
 @brief  Update receiver from another video model.
 
 @param video Reference on video model from which data should be retrieved.
 */
- (void)updateWithVideo:(CNMVideo *)video;

#pragma mark -


@end

NS_ASSUME_NONNULL_END
