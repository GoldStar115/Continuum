#import <UIKit/UIKit.h>
#import "NSLayoutConstraint+CNMAdditions.h"


/**
 @brief  Useful UIView class extensions for application.
 
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum Luxury, LLC.
 */
@interface UIView (CNMAdditions)


///------------------------------------------------
/// @name Hierarchy manipulation
///------------------------------------------------

/**
 @brief  Allow to add multiple objects with single method call.
 
 @param views List of UIView instances which should be added to the view.
 */
- (void)addSubviews:(NSArray *)views;

/**
 @brief  Retrieve reference on view which is placed closer to the lower border of the view.
 
 @return \c nil in case if there is no subviews.
 */
- (UIView *)subviewToStackBelow;

/**
 @brief  Retrieve reference on view which is placed closer to the right border of the view.
 
 @return \c nil in case if there is no subviews.
 */
- (UIView *)subviewToStackRight;

/**
 @brief  Retrieve receiver's superviews hierarchy.
 
 @return List of receiver's superview superviews.
 */
- (NSArray *)superviews;

/**
 @brief  Configure block which will be called when view will be pushed to view's hierarchy.
 
 @param block Reference on block which should be called as handler. Block pass two arguments:
              \c superview - reference on view to which receiver has been added; \c view - reference
              on receiver itself.
 */
- (void)setViewAdditionHandlerBlock:(void(^)(UIView *superview, UIView *view))block;


///------------------------------------------------
/// @name Layout manipulation
///------------------------------------------------

/**
 @brief  Round all frame elements to integer points
 */
- (void)adjustFrameToPoints;

/**
 @brief  Update view's size and depending on options may keep it's original center point.
 
 @param size       Size which should be applied to the view.
 @param keepOrigin Whether view's center point should stay on same place or not.
 */
- (void)setSize:(CGSize)size keepOrigin:(BOOL)keepOrigin;

/**
 @berief  Update receiver's origin position to specified.
 
 @param origin Point to which receiver should be moved.
 */
- (void)setOrigin:(CGPoint)origin;

/**
 @brief  Calculate size which will fit passed view. 
 @note   Larger size will be returned.
 
 @param view       Reference on view which will be used for calculations.
 @param sizeOffset Additional view size change which should be added to calcilations.
 
 @return Size which will be able to enclose specified view within receiver.
 */
- (CGSize)sizeThatFitsView:(UIView *)view withOffset:(CGSize)sizeOffset;

/**
 @brief  Adjust receiver's size to make sure it will fit \c view inside with specified size offses.
 
 @param view       Reference on view which will be used for calculations.
 @param sizeOffset Additional view size change which should be added to calcilations.
 */
- (void)adjustFrameToFitView:(UIView *)view withOffset:(CGSize)sizeOffset;


///------------------------------------------------
/// @name Autolayout size manipulation
///------------------------------------------------

/**
 @brief  Lock receiver's width using current value.
 */
- (instancetype)makeWidthConstant;

/**
 @brief  Make receiver's width flexible and greater than passed value.
 
 @param width Minimum width which is allowed by auto-layout.
 */
- (instancetype)makeWidthGreaterThan:(CGFloat)width;

/**
 @brief  Make receiver's width flexible and greater than passed view's width.
 
 @param view Reference on view form which width will be used on receiver.
 */
- (instancetype)makeWidthGreaterThanView:(UIView *)view;

/**
 @brief  Make receiver's width flexible and less than passed value.
 
 @param width Maximum width which is allowed by auto-layout.
 */
- (instancetype)makeWidthLessThan:(CGFloat)width;

/**
 @brief  Make receiver's width flexible and less than passed view's width.
 
 @param view Reference on view form which width will be used on receiver.
 */
- (instancetype)makeWidthLessThanView:(UIView *)view;

/**
 @brief  Make receiver's width flexible.
 
 @param view Reference on view form which width will be used on receiver.
 */
- (instancetype)makeWidthSameAs:(UIView *)view;

/**
 @brief  Lock receiver's height using current value.
 */
- (instancetype)makeHeightConstant;

/**
 @brief  Make receiver's height flexible and greater than passed value.
 
 @param height Maximum height which is allowed by auto-layout.
 */
- (instancetype)makeHeightGreaterThan:(CGFloat)height;

/**
 @brief  Make receiver's height flexible and greater than passed view's height.
 
 @param view Reference on view form which width will be used on receiver.
 */
- (instancetype)makeHeightGreaterThanView:(UIView *)view;

/**
 @brief  Make receiver's height flexible and less than passed value.
 
 @param height Minimum height which is allowed by auto-layout.
 */
- (instancetype)makeHeightLessThan:(CGFloat)height;

/**
 @brief  Make receiver's width flexible and less than passed view's height.
 
 @param view Reference on view form which width will be used on receiver.
 */
- (instancetype)makeHeightLessThanView:(UIView *)view;

/**
 @brief  Make receiver's height flexible.
 
 @param view Reference on view form which height will be used on receiver.
 */
- (instancetype)makeHeightSameAs:(UIView *)view;

/**
 @brief  Lock receiver's size using current values.
 */
- (instancetype)makeSizeConstant;

/**
 @brief  Make receiver's size flexible.
 
 @param view Reference on view form which size will be used on receiver.
 */
- (instancetype)makeSizeSameAs:(UIView *)view;


///------------------------------------------------
/// @name Autolayout alignment
///------------------------------------------------

/**
 @brief  Allow to stick receiver to the top edge of \c view.
 
 @param view   Reference on view inside of which receiver should be placed at the top edge.
 @param offset Value on which receiver should be moved away from \c view's top edge up or down.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignTopIn:(UIView *)view withOffset:(CGFloat)offset;

/**
 @brief  Allow to stick receiver to the top edge of \c view.
 
 @param view   Reference on view inside of which receiver should be placed at the top edge.
 @param offset Value on which receiver should be moved away from \c view's top edge up or down
 @param mode   Allowed consant flexibility.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignTopIn:(UIView *)view withOffset:(CGFloat)offset
                constraint:(CNMConstraintMode)mode;

/**
 @brief  Allow to stick receiver to the top edge of \c view and horizontally centered.
 
 @param view   Reference on view inside of which receiver should be placed at the top edge.
 @param offset Value which allow to move receiver away from \c view's top edge up or down and left 
               or right from \c view's center.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignTopCenterIn:(UIView *)view withOffset:(CGPoint)offset;

/**
 @brief  Allow to stick receiver to the top edge of \c view and horizontally centered.
 
 @param view   Reference on view inside of which receiver should be placed at the top edge.
 @param offset Value which allow to move receiver away from \c view's top edge up or down and left 
               or right from \c view's center.
 @param mode   Allowed consant flexibility.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignTopCenterIn:(UIView *)view withOffset:(CGPoint)offset
                      constraint:(CNMConstraint)mode;

/**
 @brief  Allow to stick receiver to the right edge of \c view.
 
 @param view   Reference on view inside of which receiver should be placed at the right edge.
 @param offset Value on which receiver should be moved away from \c view's right edge left or right.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignRightIn:(UIView *)view withOffset:(CGFloat)offset;

/**
 @brief  Allow to stick receiver to the right edge of \c view.
 
 @param view   Reference on view inside of which receiver should be placed at the right edge.
 @param offset Value on which receiver should be moved away from \c view's right edge left or right.
 @param mode   Allowed consant flexibility.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignRightIn:(UIView *)view withOffset:(CGFloat)offset
                  constraint:(CNMConstraintMode)mode;

/**
 @brief  Allow to stick receiver to the right edge of \c view and verically centered.
 
 @param view   Reference on view inside of which receiver should be placed at the right edge.
 @param offset Value which allow to move receiver away from \c view's right edge left or right and 
               up or down from \c view's center.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignRightCenterIn:(UIView *)view withOffset:(CGPoint)offset;

/**
 @brief  Allow to stick receiver to the right edge of \c view and verically centered.
 
 @param view   Reference on view inside of which receiver should be placed at the right edge.
 @param offset Value which allow to move receiver away from \c view's right edge left or right and 
               up or down from \c view's center.
 @param mode   Allowed consant flexibility.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignRightCenterIn:(UIView *)view withOffset:(CGPoint)offset
                        constraint:(CNMConstraint)mode;

/**
 @brief  Allow to stick receiver to the bottom edge of \c view.
 
 @param view   Reference on view inside of which receiver should be placed at the bottom edge.
 @param offset Value on which receiver should be moved away from \c view's bottom edge up or down.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignBottomIn:(UIView *)view withOffset:(CGFloat)offset;

/**
 @brief  Allow to stick receiver to the bottom edge of \c view.
 
 @param view   Reference on view inside of which receiver should be placed at the bottom edge.
 @param offset Value on which receiver should be moved away from \c view's bottom edge up or down.
 @param mode   Allowed consant flexibility.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignBottomIn:(UIView *)view withOffset:(CGFloat)offset
                   constraint:(CNMConstraintMode)mode;

/**
 @brief  Allow to stick receiver to the bottom edge of \c view and horizontally centered.
 
 @param view   Reference on view inside of which receiver should be placed at the bottom edge.
 @param offset Value which allow to move receiver away from \c view's bottom edge up or down and 
               left or right from \c view's center.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignBottomCenterIn:(UIView *)view withOffset:(CGPoint)offset;

/**
 @brief  Allow to stick receiver to the bottom edge of \c view and horizontally centered.
 
 @param view   Reference on view inside of which receiver should be placed at the bottom edge.
 @param offset Value which allow to move receiver away from \c view's bottom edge up or down and 
               left or right from \c view's center.
 @param mode   Allowed consant flexibility.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignBottomCenterIn:(UIView *)view withOffset:(CGPoint)offset
                         constraint:(CNMConstraint)mode;

/**
 @brief  Allow to stick receiver to the left edge of \c view.
 
 @param view   Reference on view inside of which receiver should be placed at the left edge.
 @param offset Value on which receiver should be moved away from \c view's left edge left or right.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignLeftIn:(UIView *)view withOffset:(CGFloat)offset;

/**
 @brief  Allow to stick receiver to the left edge of \c view.
 
 @param view   Reference on view inside of which receiver should be placed at the left edge.
 @param offset Value on which receiver should be moved away from \c view's left edge left or right.
 @param mode   Allowed consant flexibility.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignLeftIn:(UIView *)view withOffset:(CGFloat)offset
                 constraint:(CNMConstraintMode)mode;

/**
 @brief  Allow to stick receiver to the left edge of \c view and verically centered.
 
 @param view   Reference on view inside of which receiver should be placed at the left edge.
 @param offset Value which allow to move receiver away from \c view's left edge left or right and
               up or down from \c view's center.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignLeftCenterIn:(UIView *)view withOffset:(CGPoint)offset;

/**
 @brief  Allow to stick receiver to the left edge of \c view and verically centered.
 
 @param view   Reference on view inside of which receiver should be placed at the left edge.
 @param offset Value which allow to move receiver away from \c view's left edge left or right and
               up or down from \c view's center.
 @param mode   Allowed consant flexibility.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignLeftCenterIn:(UIView *)view withOffset:(CGPoint)offset
                       constraint:(CNMConstraint)mode;

/**
 @brief  Allow to stick receiver to the \c view's horizontal center point.
 
 @param view   Reference on view inside of which receiver should be placed at horizontal the center
               point.
 @param offset Value which allow to move receiver away from \c view's center left or right.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignHorizontalCenterIn:(UIView *)view withOffset:(CGFloat)offset;

/**
 @brief  Allow to stick receiver to the \c view's horizontal center point.
 
 @param view   Reference on view inside of which receiver should be placed at horizontal the center
               point.
 @param offset Value which allow to move receiver away from \c view's center left or right.
 @param mode   Allowed consant flexibility.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignHorizontalCenterIn:(UIView *)view withOffset:(CGFloat)offset
                             constraint:(CNMConstraintMode)mode;

/**
 @brief  Allow to stick receiver to the \c view's vertical center point.
 
 @param view   Reference on view inside of which receiver should be placed at vertical the center
               point.
 @param offset Value which allow to move receiver away from \c view's center up or down.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignVerticalCenterIn:(UIView *)view withOffset:(CGFloat)offset;

/**
 @brief  Allow to stick receiver to the \c view's vertical center point.
 
 @param view   Reference on view inside of which receiver should be placed at vertical the center
               point.
 @param offset Value which allow to move receiver away from \c view's center up or down.
 @param mode   Allowed consant flexibility.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignVerticalCenterIn:(UIView *)view withOffset:(CGFloat)offset
                           constraint:(CNMConstraintMode)mode;

/**
 @brief  Allow to stick receiver to the \c view's center point.
 
 @param view   Reference on view inside of which receiver should be placed at the center point.
 @param offset Value which allow to move receiver away from \c view's center left or right and
               up or down.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignCenterIn:(UIView *)view withOffset:(CGPoint)offset;

/**
 @brief  Allow to stick receiver to the \c view's center point.
 
 @param view   Reference on view inside of which receiver should be placed at the center point.
 @param offset Value which allow to move receiver away from \c view's center left or right and
               up or down.
 @param mode   Allowed consant flexibility.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignCenterIn:(UIView *)view withOffset:(CGPoint)offset
                   constraint:(CNMConstraint)mode;


///------------------------------------------------
/// @name Autolayout relative alignment
///------------------------------------------------

/**
 @brief  Allow to stick receiver at the top of \c view.
 
 @param view   Reference on view in relation to which receiver should be placed at the top.
 @param offset Value on which receiver should be moved away from \c view's top edge up or down.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignTopFrom:(UIView *)view withOffset:(CGFloat)offset;

/**
 @brief  Allow to stick receiver at the top of \c view.
 
 @param view   Reference on view in relation to which receiver should be placed at the top.
 @param offset Value on which receiver should be moved away from \c view's top edge up or down.
 @param mode   Allowed consant flexibility.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignTopFrom:(UIView *)view withOffset:(CGFloat)offset
                  constraint:(CNMConstraintMode)mode;

/**
 @brief  Allow to stick receiver at the top of \c view and horizontally centered.
 
 @param view   Reference on view in relation to which receiver should be placed at the top.
 @param offset Value which allow to move receiver away from \c view's top edge up or down and left 
               or right from \c view's center.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignTopCenterFrom:(UIView *)view withOffset:(CGPoint)offset;

/**
 @brief  Allow to stick receiver at the top of \c view and horizontally centered.
 
 @param view   Reference on view in relation to which receiver should be placed at the top.
 @param offset Value which allow to move receiver away from \c view's top edge up or down and left 
               or right from \c view's center.
 @param mode   Allowed consant flexibility.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignTopCenterFrom:(UIView *)view withOffset:(CGPoint)offset
                        constraint:(CNMConstraint)mode;

/**
 @brief  Allow to stick receiver from the right side of \c view.
 
 @param view   Reference on view in relation to which receiver should be placed at the right side.
 @param offset Value on which receiver should be moved away from \c view's right edge left or right.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignRightFrom:(UIView *)view withOffset:(CGFloat)offset;

/**
 @brief  Allow to stick receiver from the right side of \c view.
 
 @param view   Reference on view in relation to which receiver should be placed at the right side.
 @param offset Value on which receiver should be moved away from \c view's right edge left or right.
 @param mode   Allowed consant flexibility.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignRightFrom:(UIView *)view withOffset:(CGFloat)offset
                    constraint:(CNMConstraintMode)mode;

/**
 @brief  Allow to stick receiver from the right side of \c view and verically centered.
 
 @param view   Reference on view in relation to which receiver should be placed at the right side.
 @param offset Value which allow to move receiver away from \c view's right edge left or right and 
               up or down from \c view's center.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignRightCenterFrom:(UIView *)view withOffset:(CGPoint)offset;

/**
 @brief  Allow to stick receiver from the right side of \c view and verically centered.
 
 @param view   Reference on view in relation to which receiver should be placed at the right side.
 @param offset Value which allow to move receiver away from \c view's right edge left or right and 
               up or down from \c view's center.
 @param mode   Allowed consant flexibility.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignRightCenterFrom:(UIView *)view withOffset:(CGPoint)offset
                    constraint:(CNMConstraint)mode;

/**
 @brief  Allow to stick receiver at the bottom of \c view.
 
 @param view   Reference on view in relation to which receiver should be placed at the bottom.
 @param offset Value on which receiver should be moved away from \c view's bottom edge up or down.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignBottomFrom:(UIView *)view withOffset:(CGFloat)offset;

/**
 @brief  Allow to stick receiver at the bottom of \c view.
 
 @param view   Reference on view in relation to which receiver should be placed at the bottom.
 @param offset Value on which receiver should be moved away from \c view's bottom edge up or down.
 @param mode   Allowed consant flexibility.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignBottomFrom:(UIView *)view withOffset:(CGFloat)offset
                     constraint:(CNMConstraintMode)mode;

/**
 @brief  Allow to stick receiver at the bottom of \c view and horizontally centered.
 
 @param view   Reference on view in relation to which receiver should be placed at the bottom.
 @param offset Value which allow to move receiver away from \c view's bottom edge up or down and 
               left or right from \c view's center.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignBottomCenterFrom:(UIView *)view withOffset:(CGPoint)offset;

/**
 @brief  Allow to stick receiver at the bottom of \c view and horizontally centered.
 
 @param view   Reference on view in relation to which receiver should be placed at the bottom.
 @param offset Value which allow to move receiver away from \c view's bottom edge up or down and 
               left or right from \c view's center.
 @param mode   Allowed consant flexibility.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignBottomCenterFrom:(UIView *)view withOffset:(CGPoint)offset
                           constraint:(CNMConstraint)mode;

/**
 @brief  Allow to stick receiver from the left side of \c view.
 
 @param view   Reference on view in relation to which receiver should be placed at the left side.
 @param offset Value on which receiver should be moved away from \c view's left edge left or right.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignLeftFrom:(UIView *)view withOffset:(CGFloat)offset;

/**
 @brief  Allow to stick receiver from the left side of \c view.
 
 @param view   Reference on view in relation to which receiver should be placed at the left side.
 @param offset Value on which receiver should be moved away from \c view's left edge left or right.
 @param mode   Allowed consant flexibility.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignLeftFrom:(UIView *)view withOffset:(CGFloat)offset
                   constraint:(CNMConstraintMode)mode;

/**
 @brief  Allow to stick receiver from the left side of \c view and verically centered.
 
 @param view   Reference on view in relation to which receiver should be placed at the left side.
 @param offset Value which allow to move receiver away from \c view's left edge left or right and
               up or down from \c view's center.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignLeftCenterFrom:(UIView *)view withOffset:(CGPoint)offset;

/**
 @brief  Allow to stick receiver from the left side of \c view and verically centered.
 
 @param view   Reference on view in relation to which receiver should be placed at the left side.
 @param offset Value which allow to move receiver away from \c view's left edge left or right and
               up or down from \c view's center.
 @param mode   Allowed consant flexibility.
 
 @return Reference on receiver - this allow to stack autolayout manipulation.
 */
- (instancetype)alignLeftCenterFrom:(UIView *)view withOffset:(CGPoint)offset
                         constraint:(CNMConstraint)mode;

#pragma mark -


@end
