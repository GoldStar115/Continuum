/**
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum Luxury, LLC.
 */
#import "NSLayoutConstraint+CNMAdditions.h"


#pragma mark Category interface implementation

@implementation NSLayoutConstraint (CNMAdditions)


#pragma mark - Alignment

+ (NSLayoutConstraint *)horizontalCenterAligningConstraintForView:(UIView *)view
                                                           inView:(UIView *)holder
                                                       withOffset:(CGFloat)offset
                                                       constraint:(CNMConstraintMode)mode {
    
    return [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX
                                        relatedBy:(NSLayoutRelation)mode toItem:holder
                                        attribute:NSLayoutAttributeCenterX multiplier:1.0f
                                         constant:offset];
}

+ (NSLayoutConstraint *)verticalCenterAligningConstraintForView:(UIView *)view
                                                         inView:(UIView *)holder
                                                     withOffset:(CGFloat)offset
                                                     constraint:(CNMConstraintMode)mode {
    
    return [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY
                                        relatedBy:(NSLayoutRelation)mode toItem:holder
                                        attribute:NSLayoutAttributeCenterY multiplier:1.0f
                                         constant:offset];
}

+ (NSArray *)centerAligningConstraintsForView:(UIView *)view inView:(UIView *)holder
                                   withOffset:(CGPoint)offset constraint:(CNMConstraint)mode {

    return @[[self horizontalCenterAligningConstraintForView:view inView:holder withOffset:offset.x
                                                  constraint:mode.horizontal],
             [self verticalCenterAligningConstraintForView:view inView:holder withOffset:offset.y
                                                constraint:mode.vertical]];
}


+ (NSLayoutConstraint *)topAligningConstraintForView:(UIView *)view inView:(UIView *)holder
                                          withOffset:(CGFloat)offset
                                          constraint:(CNMConstraintMode)mode {
    
    return [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop
                                        relatedBy:(NSLayoutRelation)mode toItem:holder
                                        attribute:NSLayoutAttributeTop multiplier:1.0f
                                         constant:offset];
}

+ (NSLayoutConstraint *)bottomAligningConstraintForView:(UIView *)view inView:(UIView *)holder
                                             withOffset:(CGFloat)offset
                                             constraint:(CNMConstraintMode)mode {
    
    return [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom
                                        relatedBy:(NSLayoutRelation)mode toItem:holder
                                        attribute:NSLayoutAttributeBottom multiplier:1.0f
                                         constant:offset];
}

+ (NSLayoutConstraint *)leftAligningConstraintForView:(UIView *)view inView:(UIView *)holder
                                           withOffset:(CGFloat)offset
                                           constraint:(CNMConstraintMode)mode {
    
    return [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading
                                        relatedBy:(NSLayoutRelation)mode toItem:holder
                                        attribute:NSLayoutAttributeLeading multiplier:1.0f
                                         constant:offset];
}

+ (NSLayoutConstraint *)rightAligningConstraintForView:(UIView *)view inView:(UIView *)holder
                                            withOffset:(CGFloat)offset
                                            constraint:(CNMConstraintMode)mode {
    
    return [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTrailing
                                        relatedBy:(NSLayoutRelation)mode toItem:holder
                                        attribute:NSLayoutAttributeTrailing multiplier:1.0f
                                         constant:offset];
}

+ (NSLayoutConstraint *)topAligningConstraintForView:(UIView *)view fromView:(UIView *)holder
                                          withOffset:(CGFloat)offset
                                          constraint:(CNMConstraintMode)mode {
    
    return [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom
                                        relatedBy:(NSLayoutRelation)mode toItem:holder
                                        attribute:NSLayoutAttributeTop multiplier:1.0f
                                         constant:offset];
}

+ (NSLayoutConstraint *)bottomAligningConstraintForView:(UIView *)view fromView:(UIView *)holder
                                             withOffset:(CGFloat)offset
                                             constraint:(CNMConstraintMode)mode {
    
    return [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop
                                        relatedBy:(NSLayoutRelation)mode toItem:holder
                                        attribute:NSLayoutAttributeBottom multiplier:1.0f
                                         constant:offset];
}

+ (NSLayoutConstraint *)leftAligningConstraintForView:(UIView *)view fromView:(UIView *)holder
                                           withOffset:(CGFloat)offset
                                           constraint:(CNMConstraintMode)mode {
    
    return [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTrailing
                                        relatedBy:(NSLayoutRelation)mode toItem:holder
                                        attribute:NSLayoutAttributeLeading multiplier:1.0f
                                         constant:offset];
}

+ (NSLayoutConstraint *)rightAligningConstraintForView:(UIView *)view fromView:(UIView *)holder
                                            withOffset:(CGFloat)offset
                                            constraint:(CNMConstraintMode)mode {
    
    return [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading
                                        relatedBy:(NSLayoutRelation)mode toItem:holder
                                        attribute:NSLayoutAttributeTrailing multiplier:1.0f
                                         constant:offset];
}


#pragma mark - Pinning

+ (NSLayoutConstraint *)constraintForView:(UIView *)view referenceView:(UIView *)referenceView 
                                   height:(CGFloat)height withConstraintMode:(CNMConstraintMode)mode {
    
    return [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight
                                        relatedBy:(NSLayoutRelation)mode toItem:referenceView
                                        attribute:NSLayoutAttributeHeight multiplier:1.0f 
                                         constant:height];
}

+ (NSLayoutConstraint *)constraintForView:(UIView *)view referenceView:(UIView *)referenceView
                                    width:(CGFloat)width withConstraintMode:(CNMConstraintMode)mode {
    
    return [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth
                                        relatedBy:(NSLayoutRelation)mode toItem:referenceView
                                        attribute:NSLayoutAttributeWidth multiplier:1.0f 
                                         constant:width];
}

+ (NSArray *)fixedSizeConstraintsForView:(UIView *)view {
    
    NSMutableArray *constraints = [NSMutableArray arrayWithArray:[self fixedWidthConstraintsForView:view]];
    [constraints addObjectsFromArray:[self fixedHeightConstraintsForView:view]];
    
    return [constraints copy];
}

+ (NSArray *)flexibleSizeConstraintsForView:(UIView *)view inView:(UIView *)holder {
    
    NSMutableArray *constraints = [NSMutableArray new];
    [constraints addObjectsFromArray:[self flexibleWidthConstraintsForView:view inView:holder]];
    [constraints addObjectsFromArray:[self flexibleHeightConstraintsForView:view inView:holder]];
    
    return [constraints copy];
}

+ (NSArray *)fixedWidthConstraintsForView:(UIView *)view {
    
    NSDictionary *bindingViews = NSDictionaryOfVariableBindings(view);
    NSDictionary *metrics = @{@"width": @(view.frame.size.width)};
    
    return [NSLayoutConstraint constraintsWithVisualFormat:@"H:[view(==width)]"
                                                   options:0 metrics:metrics views:bindingViews];
}

+ (NSArray *)flexibleWidthConstraintsForView:(UIView *)view inView:(UIView *)holder {
    
    NSMutableArray *constraints = [NSMutableArray new];
    if (view.superview && [view.superview isEqual:holder]) {
        
        [constraints addObject:[self leftAligningConstraintForView:view inView:holder withOffset:0
                                                        constraint:CNMConstraintFixed]];
        [constraints addObject:[self rightAligningConstraintForView:view inView:holder withOffset:0
                                                         constraint:CNMConstraintFixed]];
    }
    else {
        
        [constraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth
                                relatedBy:NSLayoutRelationEqual toItem:holder
                                attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f]];
    }
    
    return [constraints copy];
}

+ (NSArray *)fixedHeightConstraintsForView:(UIView *)view {
    
    NSDictionary *bindingViews = NSDictionaryOfVariableBindings(view);
    NSDictionary *metrics = @{@"height": @(view.frame.size.height)};
    
    return [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(==height)]"
                                                   options:0 metrics:metrics views:bindingViews];
}

+ (NSArray *)flexibleHeightConstraintsForView:(UIView *)view inView:(UIView *)holder {
    
    NSMutableArray *constraints = [NSMutableArray new];
    if (view.superview && [view.superview isEqual:holder]) {
        
        [constraints addObject:[self topAligningConstraintForView:view inView:holder withOffset:0
                                                       constraint:CNMConstraintFixed]];
        [constraints addObject:[self bottomAligningConstraintForView:view inView:holder withOffset:0
                                                          constraint:CNMConstraintFixed]];
    }
    else {
        
        [constraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight
                                relatedBy:NSLayoutRelationEqual toItem:holder
                                attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
    }
    
    return [constraints copy];
}

#pragma mark -


@end
