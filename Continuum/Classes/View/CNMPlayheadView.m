/**
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
#import "CNMPlayheadView.h"


#pragma mark Private interface declaration

@interface CNMPlayheadView ()


#pragma mark - Properties

/**
 @brief  Stores total video length.
 */
@property (nonatomic, assign) NSTimeInterval videoDuration;


#pragma mark - Interface customization

/**
 @brief  Complete playhead initialization process.
 */
- (void)preparePlayheadLayout;

#pragma mark -


@end


#pragma mark - Interface implementation

@implementation CNMPlayheadView


#pragma mark - View life-cycle methods

- (void)awakeFromNib {
    
    // Forward method call to the super class.
    [super awakeFromNib];
    
    [self preparePlayheadLayout];
}


#pragma mark - Interface customization

- (void)preparePlayheadLayout {
    
    UIEdgeInsets resizeInsets = UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 6.0f);
    UIImage *sliderTrackImage = [[UIImage imageNamed:@"playhead-track-background"] resizableImageWithCapInsets:resizeInsets];
    resizeInsets = UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 6.0f);
    UIImage *sliderTrackFillImage = [[UIImage imageNamed:@"playhead-track-fill"] resizableImageWithCapInsets:resizeInsets];
    [self setMaximumTrackImage:sliderTrackImage forState:UIControlStateNormal];
    [self setMinimumTrackImage:sliderTrackFillImage forState:UIControlStateNormal];
    
    UIImage *thumbImage = [UIImage imageNamed:@"playhead-thumb"];
    [self setThumbImage:thumbImage forState:UIControlStateNormal];
    self.maximumValue = 1.0f;
    self.minimumValue = 0.0f;
}


#pragma mark - Information

- (NSTimeInterval)playheadValue {
    
    return (self.value * self.videoDuration);
}


#pragma mark - Configuration

- (void)setVideoDuration:(NSTimeInterval)duration {
    
    _videoDuration = duration;
}

- (void)setTime:(NSTimeInterval)time {
    
    self.value = (time / self.videoDuration);
}

#pragma mark -


@end
