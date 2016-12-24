/**
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
#import "CNMVideo.h"


NS_ASSUME_NONNULL_BEGIN

#pragma mark Private interface declaration

@interface CNMVideo ()


#pragma mark - Properties

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSNumber *idx;
@property (nonatomic, nullable, copy) NSString *imagePath;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, nullable, copy) NSString *author;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, nullable, strong) NSArray<CNMVideoPreset *> *presets;


#pragma mark - Data mapping

/**
 @brief  Map dictionary representation from remote data provier to the local video data model.
 
 @param information Reference on dictionary provied by remote data provider which describe video preset.
 */
- (void)mapDataFromDictionary:(NSDictionary *)information;

#pragma mark -


@end

NS_ASSUME_NONNULL_END
