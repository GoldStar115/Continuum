/**
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
#import "CNMVideoPreset.h"


NS_ASSUME_NONNULL_BEGIN

#pragma mark Private interface declaration

@interface CNMVideoPreset ()


#pragma mark - Properties

@property (nonatomic, strong) NSString *video;
@property (nonatomic, nullable, strong) NSNumber *width;
@property (nonatomic, nullable, strong) NSNumber *height;
@property (nonatomic, strong) NSNumber *size;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) NSNumber *duration;
@property (nonatomic, copy) NSString *quality;

#pragma mark -


@end

NS_ASSUME_NONNULL_END
