#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

/**
 @brief      Customizable label.
 @discussion This implementation allow to specify label properties depending from screen size.
 
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
@interface CNMLabel : UILabel


///------------------------------------------------
/// @name Information
///------------------------------------------------

/**
 @brief  Stores instruction on which font size should be used basing on screen size (diagonal).
 */
@property (nonatomic, copy) IBInspectable NSString *sizeInstruction;

/**
 @brief  Stores whether label should present text as attributes string or not.
 @default NO
 */
@property (nonatomic, assign) IBInspectable BOOL attributeString;

/**
 @brief  Stores instruction on what line spacing should be used basing on screen size (diagonal).
 */
@property (nonatomic, copy) IBInspectable NSString *spacingInstruction;

#pragma mark -


@end

NS_ASSUME_NONNULL_END
