/**
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
#import "CNMVideoEntryInformationView.h"
#import "CNMLabel.h"
#import "CNMVideo.h"


#pragma mark Private interface declaration

@interface CNMVideoEntryInformationView ()


#pragma mark - Properties

/**
 @brief  Stores reference on label which is used for video title layout.
 */
@property (nonatomic, weak) IBOutlet CNMLabel *titleLabel;

/**
 @brief  Stores reference on label which is used for video author layout.
 */
@property (nonatomic, weak) IBOutlet CNMLabel *authorLabel;

#pragma mark -


@end


#pragma mark - Interface implementation

@implementation CNMVideoEntryInformationView


#pragma mark - Layout

- (void)upateForVideo:(CNMVideo *)video {
    
    self.titleLabel.text = video.name;
    self.authorLabel.text = video.author;
}

#pragma mark -


@end
