#import <UIKit/UIKit.h>


#pragma mark Types and Structures

/**
 @brief  Represent enumerator with possible options how constraint constants should be used.
 */
typedef NS_ENUM(NSInteger, CNMConstraintMode) {
    
    /**
     @brief  Tell what passed constant should be treated by constraint as absolute and shouldn't
             allow any modifications (no flexibility).
     */
    CNMConstraintFixed = NSLayoutRelationEqual,
    
    /**
     @brief  Tell what passed constant should allow constraint to set option greater or equal then
             constant (flexible).
     */
    CNMConstraintFlexibleGreater = NSLayoutRelationGreaterThanOrEqual,
    
    /**
     @brief  Tell what passed constant should allow constraint to set option less or equal then
             constant (flexible).
     */
    CNMConstraintFlexibleLess = NSLayoutRelationLessThanOrEqual
};

/**
 @brief  Constraint mode description structure.
 */
struct CNMConstraint {
    CNMConstraintMode horizontal;
    CNMConstraintMode vertical;
};
typedef struct CNMConstraint CNMConstraint;

/**
 @brief  Constraint description builder helper.
 
 @param horizontal Contraint mode applied for constant in horizontal direction.
 @param vertical   Contraint mode applied for constant in vertical direction.
 */
static inline CNMConstraint
CNMConstraintMake(CNMConstraintMode horizontal, CNMConstraintMode vertical)
{
    CNMConstraint constraint;
    constraint.horizontal = horizontal;
    constraint.vertical = vertical;
    
    return constraint;
}


/**
 @brief  Useful NSLayoutConstraint class extensions for application.
 
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum Luxury, LLC.
 */
@interface NSLayoutConstraint (CNMAdditions)


///------------------------------------------------
/// @name Alignment
///------------------------------------------------

/**
 @brief  Construct list of constraints which is required to make \c view align to the horizontal 
         center of \c holder view.
 
 @param view   Reference on view which should be aligned at the center of container.
 @param holder Reference on view in relation to which \c view will be aligned.
 @param offset Value on which aligning point should be shifted.
 @param mode   Allowed consant flexibility.
 
 @return Configured and ready to use constraints.
 */
+ (NSLayoutConstraint *)horizontalCenterAligningConstraintForView:(UIView *)view
                                                           inView:(UIView *)holder
                                                       withOffset:(CGFloat)offset
                                                       constraint:(CNMConstraintMode)mode;

/**
 @brief  Construct list of constraints which is required to make \c view align to the vertical 
         center of \c holder view.
 
 @param view   Reference on view which should be aligned at the center of container.
 @param holder Reference on view in relation to which \c view will be aligned.
 @param offset Value on which aligning point should be shifted.
 @param mode   Allowed consant flexibility.
 
 @return Configured and ready to use constraints.
 */
+ (NSLayoutConstraint *)verticalCenterAligningConstraintForView:(UIView *)view
                                                         inView:(UIView *)holder
                                                     withOffset:(CGFloat)offset
                                                     constraint:(CNMConstraintMode)mode;

/**
 @brief  Construct list of constraints which is required to make \c view align to the center of
         \c holder view.
 
 @param view   Reference on view which should be aligned at the center of container.
 @param holder Reference on view in relation to which \c view will be aligned.
 @param offset Value on which aligning point should be shifted.
 @param mode   Allowed consant flexibility.
 
 @return Configured and ready to use constraints.
 */
+ (NSArray *)centerAligningConstraintsForView:(UIView *)view inView:(UIView *)holder
                                   withOffset:(CGPoint)offset constraint:(CNMConstraint)mode;

/**
 @brief  Construct list of constraints which is required to make \c view align to the top of 
         \c holder view.
 
 @param view   Reference on view which should be aligned at the top of container.
 @param holder Reference on view in relation to which \c view will be aligned.
 @param offset Value on which aligning point should be shifted.
 @param mode   Allowed consant flexibility.
 
 @return Configured and ready to use constraints.
 */
+ (NSLayoutConstraint *)topAligningConstraintForView:(UIView *)view inView:(UIView *)holder
                                          withOffset:(CGFloat)offset
                                          constraint:(CNMConstraintMode)mode;

/**
 @brief  Construct list of constraints which is required to make \c view align to the bottom of
         \c holder view.
 
 @param view   Reference on view which should be aligned at the bottom of container.
 @param holder Reference on view in relation to which \c view will be aligned.
 @param offset Value on which aligning point should be shifted.
 @param mode   Allowed consant flexibility.
 
 @return Configured and ready to use constraints.
 */
+ (NSLayoutConstraint *)bottomAligningConstraintForView:(UIView *)view inView:(UIView *)holder
                                             withOffset:(CGFloat)offset
                                             constraint:(CNMConstraintMode)mode;

/**
 @brief  Construct list of constraints which is required to make \c view align to the left of
         \c holder view.
 
 @param view   Reference on view which should be aligned at the left of container.
 @param holder Reference on view in relation to which \c view will be aligned.
 @param offset Value on which aligning point should be shifted.
 @param mode   Allowed consant flexibility.
 
 @return Configured and ready to use constraints.
 */
+ (NSLayoutConstraint *)leftAligningConstraintForView:(UIView *)view inView:(UIView *)holder
                                           withOffset:(CGFloat)offset
                                           constraint:(CNMConstraintMode)mode;

/**
 @brief  Construct list of constraints which is required to make \c view align to the right of
         \c holder view.
 
 @param view   Reference on view which should be aligned at the right of container.
 @param holder Reference on view in relation to which \c view will be aligned.
 @param offset Value on which aligning point should be shifted.
 @param mode   Allowed consant flexibility.
 
 @return Configured and ready to use constraints.
 */
+ (NSLayoutConstraint *)rightAligningConstraintForView:(UIView *)view inView:(UIView *)holder
                                            withOffset:(CGFloat)offset
                                            constraint:(CNMConstraintMode)mode;

/**
 @brief  Construct list of constraints which is required to make \c view align to the top edge of
         \c holder view.
 
 @param view   Reference on view which should be aligned at the top of container.
 @param holder Reference on view in relation to which \c view will be aligned.
 @param offset Value on which aligning point should be shifted.
 @param mode   Allowed consant flexibility.
 
 @return Configured and ready to use constraints.
 */
+ (NSLayoutConstraint *)topAligningConstraintForView:(UIView *)view fromView:(UIView *)holder
                                          withOffset:(CGFloat)offset
                                          constraint:(CNMConstraintMode)mode;

/**
 @brief  Construct list of constraints which is required to make \c view align at the bottom edge of
         \c holder view.
 
 @param view   Reference on view which should be aligned at the bottom of container.
 @param holder Reference on view in relation to which \c view will be aligned.
 @param offset Value on which aligning point should be shifted.
 @param mode   Allowed consant flexibility.
 
 @return Configured and ready to use constraints.
 */
+ (NSLayoutConstraint *)bottomAligningConstraintForView:(UIView *)view fromView:(UIView *)holder
                                             withOffset:(CGFloat)offset
                                             constraint:(CNMConstraintMode)mode;

/**
 @brief  Construct list of constraints which is required to make \c view align before \c holder 
         view's left edge.
 
 @param view   Reference on view which should be aligned at the left side of container.
 @param holder Reference on view in relation to which \c view will be aligned.
 @param offset Value on which aligning point should be shifted.
 @param mode   Allowed consant flexibility.
 
 @return Configured and ready to use constraints.
 */
+ (NSLayoutConstraint *)leftAligningConstraintForView:(UIView *)view fromView:(UIView *)holder
                                           withOffset:(CGFloat)offset
                                           constraint:(CNMConstraintMode)mode;

/**
 @brief  Construct list of constraints which is required to make \c view align next to \c holder 
         view's right edge.
 
 @param view   Reference on view which should be aligned at the right side of container.
 @param holder Reference on view in relation to which \c view will be aligned.
 @param offset Value on which aligning point should be shifted.
 @param mode   Allowed consant flexibility.
 
 @return Configured and ready to use constraints.
 */
+ (NSLayoutConstraint *)rightAligningConstraintForView:(UIView *)view fromView:(UIView *)holder
                                            withOffset:(CGFloat)offset
                                            constraint:(CNMConstraintMode)mode;


///------------------------------------------------
/// @name Pinning
///------------------------------------------------

/**
 @brief  Construct constraint which will make height of target \c view height
         follow constant behavior \c mode. 
 
 @param view          Reference on view for which height constraint should be created.
 @param referenceView Reference on view in relation to which height will be calculated.
 @param height        Height of the view from which using \c mode further behavior 
                      will be calculated.
 @param mode          Allowed consant flexibility.
 
 @return Configured and ready to use constraints.
 */
+ (NSLayoutConstraint *)constraintForView:(UIView *)view referenceView:(UIView *)referenceView 
                                   height:(CGFloat)height withConstraintMode:(CNMConstraintMode)mode;

/**
 @brief  Construct constraint which will make height of target \c view width
         follow constant behavior \c mode. 
 
 @param view          Reference on view for which width constraint should be created.
 @param referenceView Reference on view in relation to which width will be calculated.
 @param width         Width of the view from which using \c mode further behavior will be
                      calculated.
 @param mode          Allowed consant flexibility.
 
 @return Configured and ready to use constraints.
 */
+ (NSLayoutConstraint *)constraintForView:(UIView *)view referenceView:(UIView *)referenceView
                                    width:(CGFloat)width withConstraintMode:(CNMConstraintMode)mode;

/**
 @brief  Construct list of consraints which is required to keep \c view's size constant.
 
 @param view Reference on view for which constraints should be calculated.
 
 @return Configured and ready to use constraints.
 */
+ (NSArray *)fixedSizeConstraintsForView:(UIView *)view;

/**
 @brief  Construct list of consraints which is required to make \c view's size flexible.
 
 @param view   Reference on view for which constraints should be calculated.
 @param holder Reference on view in relation to which \c view will be stretched.
 
 @return Configured and ready to use constraints.
 */
+ (NSArray *)flexibleSizeConstraintsForView:(UIView *)view inView:(UIView *)holder;

/**
 @brief  Construct list of consraints which is required to keep \c view's width constant.
 
 @param view Reference on view for which constraints should be calculated.
 
 @return Configured and ready to use constraints.
 */
+ (NSArray *)fixedWidthConstraintsForView:(UIView *)view;

/**
 @brief  Construct list of consraints which is required to make \c view's width flexible.
 
 @param view   Reference on view for which constraints should be calculated.
 @param holder Reference on view in relation to which \c view will be stretched.
 
 @return Configured and ready to use constraints.
 */
+ (NSArray *)flexibleWidthConstraintsForView:(UIView *)view inView:(UIView *)holder;

/**
 @brief  Construct list of consraints which is required to keep \c view's height constant.
 
 @param view Reference on view for which constraints should be calculated.
 
 @return Configured and ready to use constraints.
 */
+ (NSArray *)fixedHeightConstraintsForView:(UIView *)view;

/**
 @brief  Construct list of consraints which is required to make \c view's height flexible.
 
 @param view   Reference on view for which constraints should be calculated.
 @param holder Reference on view in relation to which \c view will be stretched.
 
 @return Configured and ready to use constraints.
 */
+ (NSArray *)flexibleHeightConstraintsForView:(UIView *)view inView:(UIView *)holder;

@end
