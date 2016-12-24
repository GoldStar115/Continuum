#import <Foundation/Foundation.h>


#pragma mark Class forward

@class CNMVideo;


NS_ASSUME_NONNULL_BEGIN

/**
 @brief  Model which contain only required set of fields to represent single video preset.
 
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
@interface CNMVideoPreset : NSObject


///------------------------------------------------
/// @name Information
///------------------------------------------------

/**
 @brief  Stores information about video identifier for which this preset is related.
 */
@property (nonatomic, readonly, strong) NSString *video;

/**
 @brief  Stores information about video frame width.
 */
@property (nonatomic, nullable, readonly, strong) NSNumber *width;

/**
 @brief  Stores information about video frame height.
 */
@property (nonatomic, nullable, readonly, strong) NSNumber *height;

/**
 @brief  Stores information about video file size.
 */
@property (nonatomic, readonly, strong) NSNumber *size;

/**
 @brief  Stores reference on permanent video URL for correspondig \c quality.
 */
@property (nonatomic, readonly, copy) NSString *url;

/**
 @brief  Stores information about video duration.
 */
@property (nonatomic, readonly, strong) NSNumber *duration;

/**
 @brief  Stringified video quality ientifier.
 */
@property (nonatomic, readonly, copy) NSString *quality;


///------------------------------------------------
/// @name Data mapping
///------------------------------------------------

/**
 @brief  Map dictionary representation from remote data provier to the local video data model.
 
 @param information Reference on dictionary provied by remote data provider which describe video preset.
 */
- (void)mapDataFromDictionary:(NSDictionary *)information;

#pragma mark -


@end

NS_ASSUME_NONNULL_END
