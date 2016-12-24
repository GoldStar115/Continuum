#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CNMVideoPlayerUIProtocol.h"


#pragma mark Class forward

@class CNMPlayheadView, CNMVideoPreset, CNMVideo;


NS_ASSUME_NONNULL_BEGIN

/**
 @brief  View which is used to present video player control interface.
 
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
@interface CNMVideoPlayerUIView : UIView


///------------------------------------------------
/// @name Information
///------------------------------------------------

/**
 @brief  Stores reference on object which will accept callbacks from interface.
 */
@property (nonatomic, weak) IBOutlet id<CNMVideoPlayerUIProtocol> delegate;

/**
 @brief  Stores reference on label which is used for video title layout.
 */
@property (nonatomic, weak) IBOutlet UILabel *videoTitle;

/**
 @brief  Stores reference on button which allow to select output source.
 */
@property (nonatomic) IBOutlet MPVolumeView *sourceButton;

/**
 @brief  Reference on view which is used for playback progress layout.
 */
@property (nonatomic) IBOutlet CNMPlayheadView *playbackProgress;

/**
 @brief  Stores reference on buttons which allow to jump back and forth.
 */
@property (nonatomic) IBOutlet UIButton *jumpBackwardButton;
@property (nonatomic) IBOutlet UIButton *jumpForwardButton;

/**
 @brief  Stores reference on buttons which allow control playback.
 */
@property (nonatomic) IBOutlet UIButton *playPauseButton;
@property (nonatomic) IBOutlet UIButton *rewindButton;
@property (nonatomic) IBOutlet UIButton *fastForwardButton;


///------------------------------------------------
/// @name Appearance
///------------------------------------------------

/**
 @brief  Update interface layout for concrete video entry and file preset information.
 
 @param video  Reference on video entry which store part of information required for layout.
 @param preset Stores vieo file information which is required for correct layout.
 */
- (void)upadateForVideo:(CNMVideo *)video withPreset:(CNMVideoPreset *)preset;

/**
 @brief  Enable all elements which is responsible for playback control.
 */
- (void)enablePlaybackControls;

/**
 @brief  Update user interface to be shown depending on whether video is paused or not.
 
 @param paused Whether interface for paused state should be shown or for active playback.
 */
- (void)showStateForPause:(BOOL)paused;

/**
 @brief  Update playback progress view with current playback time.
 
 @param time Number of seconds since video playback start.
 */
- (void)updatePlayheadWithTime:(NSTimeInterval)time;

/**
 @brief  Reset hide timers, so interface won't get hiden.
 */
- (void)postponeUIHide;

#pragma mark -


@end

NS_ASSUME_NONNULL_END
