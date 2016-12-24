#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

/**
 @brief      Custom pager controller implementation.
 @discussion Implementation allow to use images as dots and allow to use real values for page number. Real 
             number allow to provide smooth transition between active dots.
 
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
@interface CNMPageControl : UIView


///------------------------------------------------
/// @name Information
///------------------------------------------------

/**
 @brief  Stores reference on image which will be used to show user selected / active page.
 */
@property (nonatomic, strong) IBInspectable UIImage *activeDotImage;

/**
 @brief  Stores reference on image which will be used to show user inactive dots.
 */
@property (nonatomic, strong) IBInspectable UIImage *inactiveDotImage;

/**
 @brief      Stores currently active page index.
 @discussion Interface will be redrawn in case to show \c active dot image at index which correspond to the
             passed value.
 */
@property (nonatomic, assign) IBInspectable CGFloat currentPage;

/**
 @brief      Stores how many pages shoul be represented by controller.
 @discussion Interface will show same number of dots as passed value.
 */
@property (nonatomic, assign) IBInspectable NSUInteger numberOfPages;

/**
 @brief  Stores information about horizontal step between dots which represent pages.
 */
@property (nonatomic, assign) IBInspectable CGFloat dotsHorizontalStep;

#pragma mark -


@end

NS_ASSUME_NONNULL_END
