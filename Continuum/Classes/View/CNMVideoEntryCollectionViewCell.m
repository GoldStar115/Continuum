/**
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
#import "CNMVideoEntryCollectionViewCell.h"
#import "UIImage+CNMAdditions.h"
#import <Haneke/Haneke.h>
#import "CNMVideo.h"


#pragma mark Private interface declaration

@interface CNMVideoEntryCollectionViewCell ()


#pragma mark - Properties

/**
 @brief  Stores reference on image view which is used to show video cover at background.
 */
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;

/**
 @brief  Stores reference on cover load progress view.
 */
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *progress;

/**
 @brief  Stores reference on video entry model instance.
 */
@property (nonatomic, strong) CNMVideo *video;

/**
 @brief  Stores whether cell is observing when cell image path will be available or not.
 */
@property (nonatomic, assign) BOOL observingCoverURL;


#pragma mark - Layout

/**
 @brief  Load and show video cover image to the user.
 */
- (void)showVideoCoverImage;

/**
 @brief  Update cell layout to show video w/o cover.
 */
- (void)showNoVideoCoverImage;


#pragma mark - Misc

/**
 @brief  Enable and disable KVO on video entry cover URL.
 */
- (void)startImageURLObservation;
- (void)stopImageURLObservation;

#pragma mark -


@end


#pragma mark - Interface implementation

@implementation CNMVideoEntryCollectionViewCell


#pragma mark - View life-cycle

- (void)prepareForReuse {
    
    [self stopImageURLObservation];
    self.video = nil;
    self.backgroundImageView.alpha = 1.0f;
    self.backgroundImageView.image = nil;
}


#pragma mark - Layout

- (void)upateForVideo:(CNMVideo *)video {
    
    self.video = video;
    [self.progress startAnimating];
    [self showVideoCoverImage];
}

- (void)showVideoCoverImage {
    
    NSURL *imageURL = [NSURL URLWithString:self.video.imagePath];
    if (imageURL) {
        
        __weak typeof(self) weakSelf = self;
        [self.backgroundImageView hnk_setImageFromURL:imageURL placeholder:nil success:^(UIImage *image) {
            
            typeof(self) strongSelf = weakSelf;
            strongSelf.backgroundImageView.alpha = 1.0f;
            strongSelf.backgroundImageView.image = image;
            [strongSelf.progress stopAnimating];
        } failure:^(NSError *error) { [self showNoVideoCoverImage]; }];
    }
    else { 
        
        [self startImageURLObservation];
        [self showNoVideoCoverImage];
    }
}

- (void)showNoVideoCoverImage {
    
    self.backgroundImageView.image = [UIImage imageNamed:@"splash-logo"];
    self.backgroundImageView.alpha = 0.3f;
    [self.progress stopAnimating];
}


#pragma mark - Handlers 

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change
                       context:(void *)context {
    
    if ([object isKindOfClass:CNMVideo.class]) {
        
        [self stopImageURLObservation];
        [self showVideoCoverImage];
    }
}


#pragma mark - Misc

- (void)startImageURLObservation {
    
    if (!self.observingCoverURL) {
        
        self.observingCoverURL = YES;
        [self.video addObserver:self forKeyPath:@"imagePath" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)stopImageURLObservation {
    
    if (self.observingCoverURL) {
        
        [self.video removeObserver:self forKeyPath:@"imagePath" context:nil];
        self.observingCoverURL = NO;
    }
}

- (void)dealloc {
    
    [self stopImageURLObservation];
    _video = nil;
}

#pragma mark - 


@end
