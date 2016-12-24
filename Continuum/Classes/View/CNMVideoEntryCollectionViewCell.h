#import <UIKit/UIKit.h>


#pragma mark Class forward

@class CNMVideo;


NS_ASSUME_NONNULL_BEGIN

/**
 @brief  View which is used by feed controller to layout single video entry.
 
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
@interface CNMVideoEntryCollectionViewCell : UICollectionViewCell


///------------------------------------------------
/// @name Layout
///------------------------------------------------

/**
 @brief  Update cell layout to represent video data.
 
 @param video Reference on instance which should be presented in
              cell.
 */
- (void)upateForVideo:(CNMVideo *)video;

#pragma mark - 


@end

NS_ASSUME_NONNULL_END
