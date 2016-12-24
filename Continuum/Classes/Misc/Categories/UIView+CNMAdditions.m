/**
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum Luxury, LLC.
 */
#import "UIView+CNMAdditions.h"
#import "NSLayoutConstraint+CNMAdditions.h"
#import <objc/runtime.h>


#pragma mark Static

/**
 @brief  Stores reference on run-time key under which view addition handler block is stored.
 */
static char CNMViewAddHandlerBlockKey;


#pragma mark - Private category interface declaration

@interface UIView (CNMAdditionsPrivate)


#pragma mark - Hierarchy manipulation

/**
 @brief  Retrieve \c view's superviews hierarchy.
 
 @param view    Reference on view for which superviews tree should be received.
 @param storage Reference on array which should store superviews tree.
 
 @return List of \c view's superview superviews.
 */
+ (NSArray *)superviewsFor:(UIView *)view withStorage:(NSMutableArray *)storage;


#pragma mark - Handlers

/**
 @brief  Try to perform addition handler block call in case if it has been specified.
 */
- (void)callAdditionHandlerBlock;


#pragma mark - Autolayout

/**
 @brief  Prepare receiver for layout using autolayout.
 */
- (void)prepareForAutoLayout;

/**
 @brief  Find suitable view for constraints addition.
 @discussion If receiver should add constraints in relation to another view, they should be added to
             it's super view. This method allow to decide whether use specified \c holder view or
             it's super view.
 
 @param holder Reference on initial view against which constraints calculated for receiver.
 
 @return View which will receive calculated constraints.
 */
- (UIView *)viewForConstraints:(UIView *)holder;

#pragma mark -


@end


#pragma mark - Category interface implementation

@implementation UIView (CNMAdditions)


#pragma mark - Hierarchy manipulation

- (void)addSubviews:(NSArray *)views {
    
    for (UIView *view in views) {
        
        [self addSubview:view];
    }
}

- (void)didMoveToSuperview {
    
    if (self.superview != nil) {
        
        [self callAdditionHandlerBlock];
    }
}

- (void)setViewAdditionHandlerBlock:(void(^)(UIView *superview, UIView *view))block {
    
    void(^targetBlock)(UIView *, UIView *) = block;
    void(^storedBlock)(UIView *, UIView *) = objc_getAssociatedObject(self, &CNMViewAddHandlerBlockKey);
    if (storedBlock) {
        
        // Chain additional handler block.
        targetBlock = ^(UIView *superview, UIView *view) {
            
            block(superview, view);
            storedBlock(superview, view);
        };
    }
    objc_setAssociatedObject(self, &CNMViewAddHandlerBlockKey, targetBlock, OBJC_ASSOCIATION_COPY);
}

- (UIView *)subviewToStackBelow {
    
    NSArray *subviews = [self.subviews sortedArrayUsingComparator:^NSComparisonResult(UIView * view1,
                                                                                      UIView * view2) {
        
        CGFloat view1Y = CGRectGetMaxY(view1.frame);
        CGFloat view2Y = CGRectGetMaxY(view2.frame);
        NSComparisonResult result = (view1Y == view2Y ? NSOrderedSame : NSOrderedAscending);
        if (result != NSOrderedSame && view2Y < view1Y) {
            
            result = NSOrderedDescending;
        }
        return result;
    }];
    
    return ([subviews count] ? [subviews lastObject] : nil);
}

- (UIView *)subviewToStackRight {
    
    NSArray *subviews = [self.subviews sortedArrayUsingComparator:^NSComparisonResult(UIView * view1,
                                                                                      UIView * view2) {
        
        CGFloat view1X = CGRectGetMaxX(view1.frame);
        CGFloat view2X = CGRectGetMaxX(view2.frame);
        NSComparisonResult result = (view1X == view2X ? NSOrderedSame : NSOrderedAscending);
        if (result != NSOrderedSame && view2X < view1X) {
            
            result = NSOrderedDescending;
        }
        return result;
    }];
    
    return ([subviews count] ? [subviews lastObject] : nil);
}

+ (NSArray *)superviewsFor:(UIView *)view withStorage:(NSMutableArray *)storage {
    
    NSArray *superviews = nil;
    if (view) {
        
        [storage addObject:view];
        superviews = [self superviewsFor:view.superview withStorage:storage];
    }
    else { superviews = [storage copy]; }
    
    return superviews;
}

- (NSArray *)superviews {
    
    return [self.class superviewsFor:self withStorage:[NSMutableArray new]];
}


#pragma mark - Handlers

- (void)callAdditionHandlerBlock {
    
    void(^block)(UIView *, UIView *) = objc_getAssociatedObject(self, &CNMViewAddHandlerBlockKey);
    if (block) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            block(self.superview, self);
        });
    }
}


#pragma mark - Layout manipulation

- (void)adjustFrameToPoints {
    
    CGRect frame = self.frame;
    self.frame = CGRectMake(ceilf(frame.origin.x), ceilf(frame.origin.y),
                            ceilf(frame.size.width), ceilf(frame.size.height));
}

- (void)setSize:(CGSize)size keepOrigin:(BOOL)keepOrigin {
    
    CGRect frame = self.frame;
    if (keepOrigin) {
        
        CGFloat widthDelta = frame.size.width - size.width;
        CGFloat heightDelta = frame.size.height - size.height;
        frame.origin = CGRectOffset(frame, widthDelta * 0.5f, heightDelta * 0.5f).origin;
        frame.size = size;
    }
    frame.size = size;
    self.bounds = (CGRect){.size = size};
}

- (void)setOrigin:(CGPoint)origin {
    
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)sizeThatFitsView:(UIView *)view withOffset:(CGSize)sizeOffset {
    
    CGSize size = self.frame.size;
    size.width = MAX(size.width, CGRectGetMaxX(view.frame) + sizeOffset.width);
    size.height = MAX(size.height, CGRectGetMaxY(view.frame) + sizeOffset.height);
    
    return size;
}

- (void)adjustFrameToFitView:(UIView *)view withOffset:(CGSize)sizeOffset {
    
    CGRect frame = self.frame;
    frame.size = [self sizeThatFitsView:view withOffset:sizeOffset];
    self.frame = frame;
}

- (void)prepareForAutoLayout {
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
}

- (UIView *)viewForConstraints:(UIView *)holder {
    
    UIView *targetView = nil;
    if (![holder isEqual:self.superview]) {
        
        targetView = [[self superviews] firstObjectCommonWithArray:[holder superviews]];
    }
    else { targetView = holder; }
    
    return targetView;
}


#pragma mark - Autolayout size manipulation

- (instancetype)makeWidthConstant {
    
    [self prepareForAutoLayout];
    [self addConstraints:[NSLayoutConstraint fixedWidthConstraintsForView:self]];
    
    return self;
}

- (instancetype)makeWidthGreaterThan:(CGFloat)width {
    
    [self prepareForAutoLayout];
    [self addConstraint:[NSLayoutConstraint constraintForView:self referenceView:nil width:width 
                                           withConstraintMode:CNMConstraintFlexibleGreater]];
    
    return self;
}

- (instancetype)makeWidthGreaterThanView:(UIView *)view {
    
    [self prepareForAutoLayout];
    [[self viewForConstraints:view] addConstraint:[NSLayoutConstraint constraintForView:self referenceView:view width:0.0f 
                               withConstraintMode:CNMConstraintFlexibleGreater]];
    
    return self;
}

- (instancetype)makeWidthLessThan:(CGFloat)width {
    
    [self prepareForAutoLayout];
    [self addConstraint:[NSLayoutConstraint constraintForView:self referenceView:nil width:width 
                                           withConstraintMode:CNMConstraintFlexibleLess]];
    
    return self;
}

- (instancetype)makeWidthLessThanView:(UIView *)view {
    
    [self prepareForAutoLayout];
    [[self viewForConstraints:view] addConstraint:[NSLayoutConstraint constraintForView:self referenceView:view width:0.0f 
                               withConstraintMode:CNMConstraintFlexibleLess]];
    
    return self;
}

- (instancetype)makeWidthSameAs:(UIView *)view {
    
    [self prepareForAutoLayout];
    NSArray *constraints = [NSLayoutConstraint flexibleWidthConstraintsForView:self inView:view];
    [[self viewForConstraints:view] addConstraints:constraints];
    
    return self;
}

- (instancetype)makeHeightConstant {
    
    [self prepareForAutoLayout];
    [self addConstraints:[NSLayoutConstraint fixedHeightConstraintsForView:self]];
    
    return self;
}

- (instancetype)makeHeightGreaterThan:(CGFloat)height {
    
    [self prepareForAutoLayout];
    [self addConstraint:[NSLayoutConstraint constraintForView:self referenceView:nil height:height 
                                           withConstraintMode:CNMConstraintFlexibleGreater]];
    
    return self;
}

- (instancetype)makeHeightGreaterThanView:(UIView *)view {
    
    [self prepareForAutoLayout];
    [[self viewForConstraints:view] addConstraint:[NSLayoutConstraint constraintForView:self referenceView:view height:0.0f 
                               withConstraintMode:CNMConstraintFlexibleGreater]];
    
    return self;
}

- (instancetype)makeHeightLessThan:(CGFloat)height {
    
    [self prepareForAutoLayout];
    [self addConstraint:[NSLayoutConstraint constraintForView:self referenceView:nil height:height 
                                           withConstraintMode:CNMConstraintFlexibleLess]];
    
    return self;
}

- (instancetype)makeHeightLessThanView:(UIView *)view {
    
    [self prepareForAutoLayout];
    [[self viewForConstraints:view] addConstraint:[NSLayoutConstraint constraintForView:self referenceView:view height:0.0f 
                               withConstraintMode:CNMConstraintFlexibleLess]];
    
    return self;
}

- (instancetype)makeHeightSameAs:(UIView *)view {
    
    [self prepareForAutoLayout];
    NSArray *constraints = [NSLayoutConstraint flexibleHeightConstraintsForView:self inView:view];
    [[self viewForConstraints:view] addConstraints:constraints];
    
    return self;
}

- (instancetype)makeSizeConstant {
    
    [self makeWidthConstant];
    [self makeHeightConstant];
    
    return self;
}

- (instancetype)makeSizeSameAs:(UIView *)view {
    
    if ([view isKindOfClass:[UIScrollView class]]) {
        
        CGRect frame = self.frame;
        frame.size.width = view.superview.frame.size.width;
        self.frame = frame;
        [self makeWidthConstant];
    }
    else {
        
        [self makeWidthSameAs:view];
    }
    [self makeHeightSameAs:view];
    
    return self;
}

- (instancetype)alignTopIn:(UIView *)view withOffset:(CGFloat)offset {

    return [self alignTopIn:view withOffset:offset constraint:CNMConstraintFixed];
}

- (instancetype)alignTopIn:(UIView *)view withOffset:(CGFloat)offset
                constraint:(CNMConstraintMode)mode {
    
    [self prepareForAutoLayout];
    NSLayoutConstraint *constraint = [NSLayoutConstraint topAligningConstraintForView:self
                                      inView:view withOffset:offset constraint:mode];
    [[self viewForConstraints:view] addConstraint:constraint];
    
    return self;
}

- (instancetype)alignTopCenterIn:(UIView *)view withOffset:(CGPoint)offset {
    
    return [self alignTopCenterIn:view withOffset:offset
                       constraint:CNMConstraintMake(CNMConstraintFixed, CNMConstraintFixed)];
}

- (instancetype)alignTopCenterIn:(UIView *)view withOffset:(CGPoint)offset
                      constraint:(CNMConstraint)mode {
    
    [self alignTopIn:view withOffset:offset.y constraint:mode.vertical];
    NSLayoutConstraint *constraint = [NSLayoutConstraint horizontalCenterAligningConstraintForView:self
                                      inView:view withOffset:offset.x constraint:mode.horizontal];
    [[self viewForConstraints:view] addConstraint:constraint];
    
    return self;
}

- (instancetype)alignRightIn:(UIView *)view withOffset:(CGFloat)offset {
    
    return [self alignRightIn:view withOffset:offset constraint:CNMConstraintFixed];
}

- (instancetype)alignRightIn:(UIView *)view withOffset:(CGFloat)offset
                  constraint:(CNMConstraintMode)mode {
    
    [self prepareForAutoLayout];
    NSLayoutConstraint *constraint = [NSLayoutConstraint rightAligningConstraintForView:self
                                      inView:view withOffset:offset constraint:mode];
    [[self viewForConstraints:view] addConstraint:constraint];
    
    return self;
}

- (instancetype)alignRightCenterIn:(UIView *)view withOffset:(CGPoint)offset {
    
    return [self alignRightCenterIn:view withOffset:offset
                         constraint:CNMConstraintMake(CNMConstraintFixed, CNMConstraintFixed)];
}

- (instancetype)alignRightCenterIn:(UIView *)view withOffset:(CGPoint)offset
                        constraint:(CNMConstraint)mode {
    
    [self alignRightIn:view withOffset:offset.x constraint:mode.horizontal];
    NSLayoutConstraint *constraint = [NSLayoutConstraint verticalCenterAligningConstraintForView:self
                                      inView:view withOffset:offset.y constraint:mode.vertical];
    [[self viewForConstraints:view] addConstraint:constraint];
    
    return self;
}

- (instancetype)alignBottomIn:(UIView *)view withOffset:(CGFloat)offset {
    
    return [self alignBottomIn:view withOffset:offset constraint:CNMConstraintFixed];
}

- (instancetype)alignBottomIn:(UIView *)view withOffset:(CGFloat)offset
                   constraint:(CNMConstraintMode)mode {
    
    [self prepareForAutoLayout];
    NSLayoutConstraint *constraint = [NSLayoutConstraint bottomAligningConstraintForView:self
                                      inView:view withOffset:offset constraint:mode];
    [[self viewForConstraints:view] addConstraint:constraint];
    
    return self;
}

- (instancetype)alignBottomCenterIn:(UIView *)view withOffset:(CGPoint)offset {
    
    return [self alignBottomCenterIn:view withOffset:offset
                          constraint:CNMConstraintMake(CNMConstraintFixed, CNMConstraintFixed)];
}

- (instancetype)alignBottomCenterIn:(UIView *)view withOffset:(CGPoint)offset
                         constraint:(CNMConstraint)mode {
    
    [self alignBottomIn:view withOffset:offset.y constraint:mode.vertical];
    NSLayoutConstraint *constraint = [NSLayoutConstraint horizontalCenterAligningConstraintForView:self
                                      inView:view withOffset:offset.x constraint:mode.horizontal];
    [[self viewForConstraints:view] addConstraint:constraint];
    
    return self;
}

- (instancetype)alignLeftIn:(UIView *)view withOffset:(CGFloat)offset {
    
    return [self alignLeftIn:view withOffset:offset constraint:CNMConstraintFixed];
}

- (instancetype)alignLeftIn:(UIView *)view withOffset:(CGFloat)offset
                 constraint:(CNMConstraintMode)mode {
    
    [self prepareForAutoLayout];
    NSLayoutConstraint *constraint = [NSLayoutConstraint leftAligningConstraintForView:self
                                      inView:view withOffset:offset constraint:mode];
    [[self viewForConstraints:view] addConstraint:constraint];
    
    return self;
}

- (instancetype)alignLeftCenterIn:(UIView *)view withOffset:(CGPoint)offset {
    
    return [self alignLeftCenterIn:view withOffset:offset
                        constraint:CNMConstraintMake(CNMConstraintFixed, CNMConstraintFixed)];
}

- (instancetype)alignLeftCenterIn:(UIView *)view withOffset:(CGPoint)offset
                       constraint:(CNMConstraint)mode {
    
    [self alignLeftIn:view withOffset:offset.x constraint:mode.horizontal];
    NSLayoutConstraint *constraint = [NSLayoutConstraint verticalCenterAligningConstraintForView:self
                                      inView:view withOffset:offset.y constraint:mode.vertical];
    [[self viewForConstraints:view] addConstraint:constraint];
    
    return self;
}

- (instancetype)alignHorizontalCenterIn:(UIView *)view withOffset:(CGFloat)offset {
    
    return [self alignHorizontalCenterIn:view withOffset:offset constraint:CNMConstraintFixed];
}

- (instancetype)alignHorizontalCenterIn:(UIView *)view withOffset:(CGFloat)offset
                             constraint:(CNMConstraintMode)mode {
    
    [self prepareForAutoLayout];
    NSLayoutConstraint *constraint = [NSLayoutConstraint horizontalCenterAligningConstraintForView:self
                                      inView:view withOffset:offset constraint:mode];
    [[self viewForConstraints:view] addConstraint:constraint];
    
    return self;
}

- (instancetype)alignVerticalCenterIn:(UIView *)view withOffset:(CGFloat)offset {
    
    return [self alignVerticalCenterIn:view withOffset:offset constraint:CNMConstraintFixed];
}

- (instancetype)alignVerticalCenterIn:(UIView *)view withOffset:(CGFloat)offset
                           constraint:(CNMConstraintMode)mode {
    
    [self prepareForAutoLayout];
    NSLayoutConstraint *constraint = [NSLayoutConstraint verticalCenterAligningConstraintForView:self
                                      inView:view withOffset:offset constraint:mode];
    [[self viewForConstraints:view] addConstraint:constraint];
    
    return self;
}

- (instancetype)alignCenterIn:(UIView *)view withOffset:(CGPoint)offset {
    
    return [self alignCenterIn:view withOffset:offset
                    constraint:CNMConstraintMake(CNMConstraintFixed, CNMConstraintFixed)];
}

- (instancetype)alignCenterIn:(UIView *)view withOffset:(CGPoint)offset
                   constraint:(CNMConstraint)mode {
    
    [self prepareForAutoLayout];
    NSArray *constraints = [NSLayoutConstraint centerAligningConstraintsForView:self inView:view
                            withOffset:offset constraint:mode];
    [[self viewForConstraints:view] addConstraints:constraints];
    
    return self;
}


#pragma mark - Autolayout relative alignment

- (instancetype)alignTopFrom:(UIView *)view withOffset:(CGFloat)offset {
    
    return [self alignTopFrom:view withOffset:offset constraint:CNMConstraintFixed];
}

- (instancetype)alignTopFrom:(UIView *)view withOffset:(CGFloat)offset
                  constraint:(CNMConstraintMode)mode {
    
    [self prepareForAutoLayout];
    NSLayoutConstraint *constraint = [NSLayoutConstraint topAligningConstraintForView:self
                                      fromView:view withOffset:offset constraint:mode];
    [[self viewForConstraints:view] addConstraint:constraint];
    
    return self;
}

- (instancetype)alignTopCenterFrom:(UIView *)view withOffset:(CGPoint)offset {
    
    return [self alignTopCenterFrom:view withOffset:offset
                         constraint:CNMConstraintMake(CNMConstraintFixed, CNMConstraintFixed)];
}

- (instancetype)alignTopCenterFrom:(UIView *)view withOffset:(CGPoint)offset
                        constraint:(CNMConstraint)mode {
    
    [self alignTopFrom:view withOffset:offset.y constraint:mode.vertical];
    NSLayoutConstraint *constraint = [NSLayoutConstraint horizontalCenterAligningConstraintForView:self
                                      inView:view withOffset:offset.x constraint:mode.horizontal];
    [[self viewForConstraints:view] addConstraint:constraint];
    
    return self;
}

- (instancetype)alignRightFrom:(UIView *)view withOffset:(CGFloat)offset {
    
    return [self alignRightFrom:view withOffset:offset constraint:CNMConstraintFixed];
}

- (instancetype)alignRightFrom:(UIView *)view withOffset:(CGFloat)offset
                    constraint:(CNMConstraintMode)mode {
    
    [self prepareForAutoLayout];
    NSLayoutConstraint *constraint = [NSLayoutConstraint rightAligningConstraintForView:self
                                      fromView:view withOffset:offset constraint:mode];
    [[self viewForConstraints:view] addConstraint:constraint];
    
    return self;
}

- (instancetype)alignRightCenterFrom:(UIView *)view withOffset:(CGPoint)offset {
    
    return [self alignRightCenterFrom:view withOffset:offset
                           constraint:CNMConstraintMake(CNMConstraintFixed, CNMConstraintFixed)];
}

- (instancetype)alignRightCenterFrom:(UIView *)view withOffset:(CGPoint)offset
                          constraint:(CNMConstraint)mode {
    
    [self alignRightFrom:view withOffset:offset.x constraint:mode.horizontal];
    NSLayoutConstraint *constraint = [NSLayoutConstraint verticalCenterAligningConstraintForView:self
                                      inView:view withOffset:offset.y constraint:mode.vertical];
    [[self viewForConstraints:view] addConstraint:constraint];
    
    return self;
}

- (instancetype)alignBottomFrom:(UIView *)view withOffset:(CGFloat)offset {
    
    return [self alignBottomFrom:view withOffset:offset constraint:CNMConstraintFixed];
}

- (instancetype)alignBottomFrom:(UIView *)view withOffset:(CGFloat)offset
                     constraint:(CNMConstraintMode)mode {
    
    [self prepareForAutoLayout];
    NSLayoutConstraint *constraint = [NSLayoutConstraint bottomAligningConstraintForView:self
                                      fromView:view withOffset:offset constraint:mode];
    [[self viewForConstraints:view] addConstraint:constraint];
    
    return self;
}

- (instancetype)alignBottomCenterFrom:(UIView *)view withOffset:(CGPoint)offset {
    
    return [self alignBottomCenterFrom:view withOffset:offset
                            constraint:CNMConstraintMake(CNMConstraintFixed, CNMConstraintFixed)];
}

- (instancetype)alignBottomCenterFrom:(UIView *)view withOffset:(CGPoint)offset
                           constraint:(CNMConstraint)mode {
    
    [self alignBottomFrom:view withOffset:offset.y constraint:mode.vertical];
    NSLayoutConstraint *constraint = [NSLayoutConstraint horizontalCenterAligningConstraintForView:self
                                      inView:view withOffset:offset.x constraint:mode.horizontal];
    [[self viewForConstraints:view] addConstraint:constraint];
    
    return self;
}

- (instancetype)alignLeftFrom:(UIView *)view withOffset:(CGFloat)offset {
    
    return [self alignLeftFrom:view withOffset:offset constraint:CNMConstraintFixed];
}

- (instancetype)alignLeftFrom:(UIView *)view withOffset:(CGFloat)offset
                   constraint:(CNMConstraintMode)mode {
    
    [self prepareForAutoLayout];
    NSLayoutConstraint *constraint = [NSLayoutConstraint leftAligningConstraintForView:self
                                      fromView:view withOffset:offset constraint:mode];
    [[self viewForConstraints:view] addConstraint:constraint];
    
    return self;
}

- (instancetype)alignLeftCenterFrom:(UIView *)view withOffset:(CGPoint)offset {
    
    return [self alignLeftCenterFrom:view withOffset:offset
                          constraint:CNMConstraintMake(CNMConstraintFixed, CNMConstraintFixed)];
}

- (instancetype)alignLeftCenterFrom:(UIView *)view withOffset:(CGPoint)offset
                         constraint:(CNMConstraint)mode {
    
    [self alignLeftFrom:view withOffset:offset.x constraint:mode.horizontal];
    NSLayoutConstraint *constraint = [NSLayoutConstraint verticalCenterAligningConstraintForView:self
                                      inView:view withOffset:offset.y constraint:mode.vertical];
    [[self viewForConstraints:view] addConstraint:constraint];
    
    return self;
}

#pragma mark -


@end
