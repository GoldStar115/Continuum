/**
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
#import <AVFoundation/AVFoundation.h>
#import "CNMVideoPlayerUIProtocol.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CNMVideoViewController.h"
#import "CNMVideoPlayerUIView.h"
#import "UIView+CNMAdditions.h"
#import "CNMVideoFeedManager.h"
#import "CNMPlayheadView.h"
#import "CNMVideoPreset.h"
#import <AVKit/AVKit.h>
#import "CNMVideo.h"
#import "Mixpanel.h"


#pragma mark Static

/**
 @brief      Stores maximum video height which should be used for playback.
 @discussion This value used only if multiple presets of specified quality is available.
 */
static CGFloat const kCNMVideoDesiredVideoHeight = 720.0f;

/**
 @brief  Stores reference on quality ientifier for which presets should be pulled out.
 */
static NSString * const kCNMVideoDesiredQuality = @"hls";


#pragma mark - Private interface declaration

@interface CNMVideoViewController () <CNMVideoPlayerUIProtocol>


#pragma mark - Properties

/**
 @brief Stores reference on view which is responsible for 
        player's UI layout.
 */
@property (nonatomic, weak) IBOutlet CNMVideoPlayerUIView *playerInterface;

/**
 @brief  Stores reference on video data load indicator which is shown when additional video data should be
         fetched.
 */
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *loadIndicatorView;

/**
 @brief  Stores whether interface will be hidden or not.
 */
@property (nonatomic, assign) BOOL hiddingInterface;

/**
 @brief  Stores reference on view which is used for player layer
         layout.
 */
@property (nonatomic, weak) IBOutlet UIView *playerHolderView;

/**
 @brief  Stores reference on video feed manager which will give ability to fetch additional video data.
 */
@property (nonatomic, strong) CNMVideoFeedManager *manager;

/**
 @brief  Stores reference on which will provide information
         for playback.
 */
@property (nonatomic) CNMVideo *video;

/**
 @brief  Reference on preset which desceribe video file for
         playback.
 */
@property (nonatomic) CNMVideoPreset *preset;

/**
 @brief  Stores reference on view which is used as player.
 */
@property (nonatomic) AVPlayer *videoPlayer;

/**
 @brief  Stores reference on \a CALayer which is used for video layout.
 */
@property (nonatomic) AVPlayerLayer *videoPlayerLayer;

/**
 @brief  Stores reference on object which has been created 
         during subscription on playhead position updates.
 */
@property (nonatomic) id playbackObserver;

/**
 @brief  Stores whether user is seeking through video or not.
 */
@property (nonatomic, assign, getter = isSeeking) BOOL seeking;

/**
 @brief  Stores whether playback should be resumed after seek or not.
 */
@property (nonatomic, assign, getter = shouldResumeAfterSeek) BOOL resumeAfterSeek;

/**
 @brief  Whether shown video should be looped at the end of playback
         or not.
 */
@property (nonatomic, getter = shoulLoopVideo) BOOL loopVideo;

/**
 @brief  Stores whether player reached video end or not.
 */
@property (nonatomic) BOOL reachedTheEnd;

/**
 @brief  Stores whether playback statistics has been sent or not.
 */
@property (nonatomic) BOOL playbackStatisticSent;


#pragma mark - Data provider

/**
 @brief  Method which allow to fetch required preset from video entry.
 */
- (void)fetchPreset;


#pragma mark - Playback

/**
 @brief  Start video playback using fetched video preset.
 */
- (void)startPlaybackWithDelay;

/**
 @brief  Start video playback using fetched video preset.
 */
- (void)startPlayback;

/**
 @brief  Manage video player instance and player subscription on events.
 */
- (void)prepareVideoPlayer;
- (void)destroyVideoPlayer;


#pragma mark - Handlers

/**
 @brief  Handle moment when playback head reach video end.
 
 @param notification Reference on notification with which event has been triggered.
 */
- (void)handlePlaybackEndNotification:(NSNotification *)notification;

/**
 @brief  Handler user tap on loop button.
 
 @param sender Reference on button on which user tapped.
 */
- (IBAction)handleLoopButtonTap:(UIButton *)sender;

/**
 @brief  Handling user tap on \c Back button.
 
 @param sender Reference on button on which user tapped.
 */
- (IBAction)handleBackButtonTap:(id)sender;

/**
 @brief  Handle jump button tap to rewind backward or forward through timeline.
 
 @param sender Reference on button which has been tappe.
 */
- (IBAction)hanleJumpButtonTap:(UIButton *)sender;

/**
 @brief  Handle user tap on play / pause button to change player's state.
 
 @param sender Reference on button which user tapped.
 */
- (IBAction)handlePlayPauseButtonTap:(UIButton *)sender;

/**
 @brief  Handle user tap on buttons responsible for playback speed and direction.
 
 @param sener Reference on button which user tapped.
 */
- (IBAction)handleRewindButtonDown:(UIButton *)sender;
- (IBAction)handleFastForwardButtonDown:(UIButton *)sender;

/**
 @brief  Handle user mouse up/down on draggable thumb element.
 
 @param slider Reference on slider who's thumb is pressed/released.
 */
- (IBAction)handleVideoPlaybackThumbDown:(CNMPlayheadView *)slider;
- (IBAction)handleVideoPlaybackThumbUp:(CNMPlayheadView *)slider;

/**
 @brief  Handle user drag to seek through video.
 
 @param slider Reference on slider with which user interact.
 */
- (IBAction)handleVideoPlaybackThumbDrag:(CNMPlayheadView *)slider;

/**
 @brief  Handle video player's status change to update interface or notify about error.
 */
- (void)handleVideoPlayerStatusChange;

/**
 @brief  Handle moment when player is ready for playback.
 */
- (void)handleVideoPlayerReadyStatus;

/**
 @brief  Handle moment when player got error and can't be used further.
 */
- (void)handleVideoPlayerErrorStatus;

/**
 @brief  Handle application transition to background execution context.
 
 @param notification Reference on notification with transition information.
 */
- (void)handleApplicationEnterBackground:(NSNotification *)notification;


#pragma mark - Misc

/**
 @brief  Subscribe/unsubscribe on/from required set of notifications.
 */
- (void)subscribeOnNotifications;
- (void)unsubscribeFromNotifications;

/**
 @brief  Retrieve current playhead position.
 */
- (NSTimeInterval)currentPlayheadPosition;

/**
 @brief  Upate player's playhead position.
 
 @param playheadPosition New position which should be set and from which playback should continue.
 */
- (void)setCurrentPlayheadPosition:(NSTimeInterval)playheadPosition;

/**
 @brief  Display alert view with message which explain what requested video still in processing.
 */
- (void)showVideoNotReadyAlert;

#pragma mark -


@end


#pragma mark - Interface implementation

@implementation CNMVideoViewController


#pragma mark - Controller life-cycle

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return UIInterfaceOrientationLandscapeLeft;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    
    return self.hiddingInterface;
}

- (BOOL)shouldAutorotate {
    
    return YES;
}

- (void)viewDidLoad {
    
    // Forward method call to the super class.
    [super viewDidLoad];
    
    [self subscribeOnNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    
    // Forward method call to the super class.
    [super viewWillAppear:animated];
    
    [self fetchPreset];
}


#pragma mark - Configuration

- (void)prepareForVideo:(CNMVideo *)video withManager:(CNMVideoFeedManager *)manager {
    
    self.video = video;
    self.manager = manager;
}


#pragma mark - Data provider

- (void)fetchPreset {

    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"quality == %@", kCNMVideoDesiredQuality];
    NSArray<CNMVideoPreset *> *filteredPresets = [self.video.presets filteredArrayUsingPredicate:filterPredicate];
    if (filteredPresets.count > 1) {
        
        NSSortDescriptor *heightSort = [[NSSortDescriptor alloc] initWithKey:@"height" ascending:YES];
        NSArray<CNMVideoPreset *> *sortedPresets = [filteredPresets sortedArrayUsingDescriptors:@[heightSort]];
        for (CNMVideoPreset *preset in sortedPresets) {
            
            CGFloat presetVideoHeightDiff = kCNMVideoDesiredVideoHeight - preset.height.floatValue;
            if (presetVideoHeightDiff >= 0.0f) { self.preset = preset; }
            else { break; }
        }
    }
    else { self.preset = filteredPresets.lastObject; }
    
    if (self.preset) {
    
        [self.playerInterface upadateForVideo:self.video withPreset:self.preset];
        [self startPlaybackWithDelay];
    }
    else {
        
        if (!self.loadIndicatorView.isAnimating) {
            
            [self.loadIndicatorView startAnimating];
            __weak __typeof__(self) weakSelf = self;
            [self.manager fetchAndUpdateDataForVideo:self.video withCompletion:^{ [weakSelf fetchPreset]; }];
        }
        else { [self showVideoNotReadyAlert]; }
    }
}


#pragma mark - Playback

- (void)startPlaybackWithDelay {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self startPlayback];
    });
}

- (void)startPlayback {
    
    [self prepareVideoPlayer];
}

- (void)prepareVideoPlayer {
    
    NSURL *videoURL = [NSURL URLWithString:self.preset.url];
    self.videoPlayer = [AVPlayer playerWithURL:videoURL];
    self.videoPlayer.allowsExternalPlayback = YES;
    [self.videoPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
    self.videoPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.videoPlayer];
    self.videoPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.videoPlayerLayer.frame = self.view.frame;
    [self.playerHolderView.layer addSublayer:self.videoPlayerLayer];
}

- (void)destroyVideoPlayer {
    
    if (_videoPlayer) {
        
        [_videoPlayer removeObserver:self forKeyPath:@"status" context:nil];
        [_videoPlayer removeTimeObserver:_playbackObserver];
        [_videoPlayer pause];
        
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification 
                                    object:[_videoPlayer currentItem]];
        
        [self.videoPlayerLayer removeFromSuperlayer];
    }
    _videoPlayerLayer = nil;
    _videoPlayer = nil;
}


#pragma mark - Handlers

- (void)handlePlaybackEndNotification:(NSNotification *)notification {
    
    self.reachedTheEnd = YES;
    BOOL shouldLoop = (!self.isSeeking && self.shoulLoopVideo);
    if (self.playerInterface.playPauseButton.isSelected && !shouldLoop) {
        
        self.playerInterface.playPauseButton.selected = NO;
    }
    if (shouldLoop) {
        
        self.currentPlayheadPosition = 0.1f;
        [self.videoPlayer play];
    }
}

- (IBAction)handleLoopButtonTap:(UIButton *)sender {
    
    [self.playerInterface postponeUIHide];
    if (sender.isSelected) { self.loopVideo = NO; }
    else { self.loopVideo = YES; }
    sender.selected = !sender.isSelected;
    sender.highlighted = sender.isSelected;
    
    if (self.shoulLoopVideo && self.reachedTheEnd) {
        
        self.playerInterface.playPauseButton.selected = YES;
        self.currentPlayheadPosition = 0.1f;
        [self.videoPlayer play];
    }
}

- (IBAction)handleBackButtonTap:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)hanleJumpButtonTap:(UIButton *)sender {
    
    [self.playerInterface postponeUIHide];
    NSString *buttonTitle = [sender titleForState:UIControlStateNormal];
    NSInteger direction = ([buttonTitle hasPrefix:@"+"] ? 1 : -1 );
    NSInteger secondsCount = [buttonTitle substringFromIndex:1].integerValue;
    
    self.currentPlayheadPosition = (self.currentPlayheadPosition + (float)(direction * secondsCount));
}

- (IBAction)handlePlayPauseButtonTap:(UIButton *)sender {
    
    [self.playerInterface postponeUIHide];
    if (self.reachedTheEnd) { self.currentPlayheadPosition = 0.1f; }
    if (sender.isSelected) { [self.videoPlayer pause]; }
    else { [self.videoPlayer play]; }
    sender.selected = !sender.isSelected;
}

- (IBAction)handleRewindButtonDown:(UIButton *)sender {
    
    [self.playerInterface postponeUIHide];
    if (sender.isHighlighted) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), 
                       dispatch_get_main_queue(), ^{
            
            self.currentPlayheadPosition -= 1.0f;
            [self handleRewindButtonDown:sender];
        });
    }
}

- (IBAction)handleFastForwardButtonDown:(UIButton *)sender {
    
    [self.playerInterface postponeUIHide];
    if (sender.isHighlighted) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), 
                       dispatch_get_main_queue(), ^{
            
            self.currentPlayheadPosition += 1.0f;
            [self handleFastForwardButtonDown:sender];
        });
    }
}

- (IBAction)handleVideoPlaybackThumbDown:(CNMPlayheadView *)slider {
    
    self.seeking = YES;
    self.resumeAfterSeek = (self.videoPlayer.rate >=0.5f);
    [self.playerInterface postponeUIHide];
    if (self.resumeAfterSeek) { [self.videoPlayer pause];  }
}

- (IBAction)handleVideoPlaybackThumbUp:(CNMPlayheadView *)slider {
    
    self.seeking = NO;
    [self.playerInterface postponeUIHide];
    if (self.shouldResumeAfterSeek) { [self.videoPlayer play]; }
}

- (IBAction)handleVideoPlaybackThumbDrag:(CNMPlayheadView *)slider {
    
    [self.playerInterface postponeUIHide];
    self.currentPlayheadPosition = slider.playheadValue;
}

- (void)handleVideoPlayerStatusChange {
    
    [self.playerInterface postponeUIHide];
    if (self.videoPlayer.status == AVPlayerStatusReadyToPlay) {
        
        [self handleVideoPlayerReadyStatus];
    }
    else if (self.videoPlayer.status == AVPlayerStatusFailed) {
        
        [self handleVideoPlayerErrorStatus];
    }
}

- (void)handleVideoPlayerReadyStatus {
    
    [self.videoPlayer play];
    [self.playerInterface enablePlaybackControls];
    
    __block __weak typeof(self) weakSelf = self;
    self.playbackObserver = [self.videoPlayer addPeriodicTimeObserverForInterval:CMTimeMake(33, 1000) 
                             queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
                                 
        __block __strong typeof(self) strongSelf = weakSelf;
        if (!strongSelf.playbackStatisticSent && 
            strongSelf.currentPlayheadPosition > strongSelf.preset.duration.doubleValue * 0.85f) {
            
            strongSelf.playbackStatisticSent = YES;
#if !TARGET_IPHONE_SIMULATOR
            [[Mixpanel sharedInstance] track:@"View play completion" 
                                  properties:@{@"Title": strongSelf.video.name, 
                                               @"Identifier": strongSelf.video.name}];
#endif
        }
        [weakSelf.playerInterface updatePlayheadWithTime:strongSelf.currentPlayheadPosition];
    }];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(handlePlaybackEndNotification:)
                               name:AVPlayerItemDidPlayToEndTimeNotification object:[self.videoPlayer currentItem]];
}

- (void)handleVideoPlayerErrorStatus {
    
    NSString *message = @"Something isn't right... The video stream cannot play properly. Please try again later.";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Playback Issue"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault 
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       [self handleBackButtonTap:nil];
                                                   }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)handleApplicationEnterBackground:(NSNotification *)notification {
    
    [self.videoPlayer pause];
    [self.playerInterface showStateForPause:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context { 
    
    if ([keyPath isEqualToString:@"status"] && [object isEqual:self.videoPlayer]) {
        
        [self handleVideoPlayerStatusChange];
    }
}


#pragma mark - UI interface delegate methods

- (void)willShowInterface {
    
    self.hiddingInterface = NO;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)willHideInterface {
    
    self.hiddingInterface = YES;
    [self setNeedsStatusBarAppearanceUpdate];
}


#pragma mark - Misc

- (void)subscribeOnNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleApplicationEnterBackground:) 
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)unsubscribeFromNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
}

- (NSTimeInterval)currentPlayheadPosition {
    
    return CMTimeGetSeconds(self.videoPlayer.currentItem.currentTime);
}

- (void)setCurrentPlayheadPosition:(NSTimeInterval)playheadPosition {
    
    if (playheadPosition < 1.0f) { self.reachedTheEnd = NO; }
    CMTime seekTime = CMTimeMakeWithSeconds(playheadPosition, NSEC_PER_SEC);
    [self.videoPlayer.currentItem seekToTime:seekTime];
}

- (void)showVideoNotReadyAlert {
    
    NSString *message = @"This video is brand new and we're working on transcoding it. Tech talk for making sure it can play on your device correctly.";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Video Transcoding Issue"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault 
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       
        [self.loadIndicatorView stopAnimating];
        [self handleBackButtonTap:nil];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)dealloc {
    
    [self unsubscribeFromNotifications];
    [self destroyVideoPlayer];
}

#pragma mark -


@end
