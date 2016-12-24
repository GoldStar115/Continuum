#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

/**
 @brief      Customizable button.
 @discussion This implementation allow to specify button properties depending from screen size.
 
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
@interface CNMButton : UIButton


///------------------------------------------------
/// @name Information
///------------------------------------------------

/**
 @brief  Stores instruction on which button size should be used basing on screen size (diagonal).
 */
@property (nonatomic, copy) IBInspectable NSString *sizeInstruction;

/**
 @brief  Stores instruction about image size which should be used basing on screen size (diagonal).
 */
@property (nonatomic, copy) IBInspectable NSString *imageSizeInstruction;

#pragma mark -


@end

NS_ASSUME_NONNULL_END
