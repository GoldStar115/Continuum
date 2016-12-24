#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

/**
 @brief      Customizable image view.
 @discussion This implementation allow to specify image view properties depending from screen size.
 
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
@interface CNMImageView : UIImageView


///------------------------------------------------
/// @name Information
///------------------------------------------------

/**
 @brief  Stores instruction on which button size should be used basing on screen size (diagonal).
 */
@property (nonatomic, copy) IBInspectable NSString *sizeInstruction;

#pragma mark -


@end

NS_ASSUME_NONNULL_END
