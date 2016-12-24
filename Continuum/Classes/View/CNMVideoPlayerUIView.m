/**
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
#import "CNMVideoPlayerUIView.h"
#import "CNMPlayheadView.h"
#import "CNMVideoPreset.h"
#import "CNMVideo.h"


#pragma mark Static

/**
 @brief  Stores delay after which interface will be hidden.
 */
static NSTimeInterval const kCNMVideoUIHideDelay = 15.0f;

/**
 @brief  Stores time which UI appear / disappear will take.
 */
static NSTimeInterval const kCNMVideoUITransitionDuration = 0.3f;


#pragma mark - Private interface declaration

@interface CNMVideoPlayerUIView ()


#pragma mark - Properties

/**
 @brief  Stores reference on view which store all elements.
 */
@property (nonatomic, weak) IBOutlet UIView *intefaceHolderView;

/**
 @brief  Stores reference on labels which is used to layout playback
         progress.
 */
@property (nonatomic, weak) IBOutlet UILabel *currentTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *durationLabel;

/**
 @brief  Stores reference on button which allow to loop playback.
 */
@property (nonatomic, weak) IBOutlet UIButton *loopButton;

/**
 @brief  Stores reference on timer which is used to hide interface 
         after some delay.
 */
@property (nonatomic) NSTimer *UIHideTimer;

/**
 @brief  Stores full video duration information.
 */
@property (nonatomic, assign) float totalVideoDuration;


#pragma mark - Appearance

/**
 @brief  Complete configuration which can be done after interface load.
 */
- (void)prepareUILayout;

/**
 @brief  Animated switch between visible / invisible interface.
 */
- (void)toggleInterfaceVisibility;


#pragma mark - Handlers

/**
 @brief  Handler for timer which trigger UI dissappearance.
 
 @param timer Reference on timer which triggered hide.
 */
- (void)handleUIHideTimer:(NSTimer *)timer;


#pragma mark - Misc

/**
 @brief  Translate float value to string with required format to represent it in interface.
 
 @param value Value which should be translated.
 
 @return Translated duration string.
 */
- (NSString *)formattedTimeFrom:(NSUInteger)value;

/**
 @brief  Launch timer which will hide interface after specified time.
 */
- (void)startUIHideTimer;

/**
 @brief  Stop UI hidding timer if launched.
 */
- (void)stopUIHideTimer;

#pragma mark -


@end


#pragma mark - Interface implementation

@implementation CNMVideoPlayerUIView


#pragma mark - View life-cycle

- (void)awakeFromNib {
    
    // Forwar method call to the super class.
    [super awakeFromNib];
    
    [self prepareUILayout];
    [self startUIHideTimer];
}


#pragma mark - Appearance

- (void)upadateForVideo:(CNMVideo *)video withPreset:(CNMVideoPreset *)preset {
    
    self.totalVideoDuration = preset.duration.floatValue;
    self.videoTitle.text = video.name;
    self.playbackProgress.enabled = NO;
    [self.playbackProgress setVideoDuration:preset.duration.floatValue];
    
    self.currentTimeLabel.text = @"00.00";
    self.durationLabel.text = [self formattedTimeFrom:preset.duration.unsignedIntegerValue];
}

- (void)enablePlaybackControls {
    
    self.playbackProgress.enabled = YES;
    self.playPauseButton.selected = YES;
    self.playPauseButton.enabled = YES;
    self.rewindButton.enabled = YES;
    self.fastForwardButton.enabled = YES;
    self.loopButton.enabled = YES;
}

- (void)showStateForPause:(BOOL)paused {
    
    self.playPauseButton.selected = !paused;
}

- (void)updatePlayheadWithTime:(NSTimeInterval)time {
    
    self.jumpBackwardButton.enabled = (time > 10.0f);
    self.jumpForwardButton.enabled = (self.totalVideoDuration - time > 10.0f);
    self.currentTimeLabel.text = [self formattedTimeFrom:time];
    [self.playbackProgress setTime:time];
}

- (void)postponeUIHide {
    
    [self startUIHideTimer];
}

- (void)prepareUILayout {
    
    UIImage *buttonImage = [UIImage imageNamed:@"airplay-button-icon"];
    [self.sourceButton setRouteButtonImage:buttonImage forState:UIControlStateNormal];
    self.sourceButton.showsVolumeSlider = NO;
}

- (void)toggleInterfaceVisibility {
    
    CGFloat targetAlpha = (self.intefaceHolderView.alpha < 1.0f ? 1.0f : 0.0f);
    if (targetAlpha > 0.0f) {
        
        [self.delegate willShowInterface];
        [self startUIHideTimer]; 
    }
    else { 
        
        [self.delegate willHideInterface];
        [self stopUIHideTimer];
    }
    [UIView animateWithDuration:kCNMVideoUITransitionDuration
                     animations:^{ self.intefaceHolderView.alpha = targetAlpha; }];
}

#pragma mark - Handlers

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if ([touches.anyObject.view isEqual:self] || [touches.anyObject.view isEqual:self.intefaceHolderView]) { 

        [self toggleInterfaceVisibility]; 
    }
}

- (void)handleUIHideTimer:(NSTimer *)timer {
    
    [UIView animateWithDuration:kCNMVideoUITransitionDuration
                     animations:^{ self.intefaceHolderView.alpha = 0.0f; }];
}


#pragma mark - Misc

- (NSString *)formattedTimeFrom:(NSUInteger)value {
    
    NSUInteger hours = value / 3600;
    NSUInteger minutes = (value / 60) % 60;
    NSUInteger seconds = value % 60;
    
    return [NSString stringWithFormat:@"%@%02lu.%02lu",
            (hours > 0 ? [NSString stringWithFormat:@"%02lu", (unsigned long)hours] : @""),
            (unsigned long)minutes, (unsigned long)seconds];
}

- (void)startUIHideTimer {
    
    [self stopUIHideTimer];
    
    self.UIHideTimer = [NSTimer scheduledTimerWithTimeInterval:kCNMVideoUIHideDelay target:self 
                        selector:@selector(handleUIHideTimer:) userInfo:nil repeats:NO];
}

- (void)stopUIHideTimer {
    
    if (self.UIHideTimer.isValid) { [self.UIHideTimer invalidate]; }
    self.UIHideTimer = nil;
}

#pragma mark -


@end
