/**
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
#import "CNMPageControl.h"
#import "UIView+CNMAdditions.h"


#pragma mark Private interface declaration

@interface CNMPageControl ()


#pragma mark - Properties

/**
 @brief  Stores whether interface has been prepared for layout or not.
 */
@property (nonatomic, assign) BOOL prepared;

/**
 @brief  Stores reference on image view which is used to show set of inactive dots.
 */
@property (nonatomic) UIView *inactiveDots;

/**
 @brief  Stores reference on list of active pager dots.
 */
@property (nonatomic) NSMutableArray *activeDots;


#pragma mark - Interface customization

/**
 @brief  Depending on current controller state it will pass initial preparation or upate to represent latest 
         state.
 */
- (void)upateControllerLayout;

/**
 @brief  Complete page controller initialization when all required information will be set.
 */
- (void)prepare;

/**
 @brief  Update dots visual layout using current controller state.
 */
- (void)upateDots;

/**
 @brief  Prepare base image with inactive dots.
 */
- (void)prepareInactiveDots;
- (void)prepareActiveDots;


#pragma mark -


@end


#pragma mark - Interface implementation

@implementation CNMPageControl


#pragma mark - View life-cycle

- (void)didMoveToSuperview {
    
    [super didMoveToSuperview];
    if (self.superview) { [self upateControllerLayout]; }
}


#pragma mark - Information

- (void)setActiveDotImage:(UIImage *)activeDotImage {
    
    _activeDotImage = activeDotImage;
    [self upateControllerLayout];
}

- (void)setInactiveDotImage:(UIImage *)inactiveDotImage {
    
    _inactiveDotImage = inactiveDotImage;
    [self upateControllerLayout];
}

- (void)setCurrentPage:(CGFloat)currentPage {
    
    _currentPage = currentPage;
    [self upateControllerLayout];
}

- (void)setNumberOfPages:(NSUInteger)numberOfPages {
    
    _numberOfPages = numberOfPages;
    [self upateControllerLayout];
}

- (void)setDotsHorizontalStep:(CGFloat)dotsHorizontalStep {
    
    _dotsHorizontalStep = dotsHorizontalStep;
    [self upateControllerLayout];
}


#pragma mark - Interface customization

- (void)upateControllerLayout {
    
    if (self.prepared) { [self upateDots]; }
    else { [self prepare]; }
}

- (void)prepare {
    
    if (self.activeDotImage && self.inactiveDotImage && 
        self.numberOfPages > 0 && self.dotsHorizontalStep > 0.0f) {
        
        self.backgroundColor = [UIColor clearColor];
        [self prepareInactiveDots];
        [self prepareActiveDots];
        self.prepared = YES;
        [self upateControllerLayout];
    }
}

- (void)upateDots {
    
    [self.activeDots enumerateObjectsUsingBlock:^(UIView *dot, NSUInteger dotIdx, BOOL *dotsEnumeratorStop) {
        
        if (dotIdx < (NSUInteger)self.currentPage) { dot.alpha = 0.0f; }
        else if (dotIdx == (NSUInteger)self.currentPage) {
            
            dot.alpha = 1.0f - (self.currentPage - (NSUInteger)self.currentPage);
        }
        else if (dotIdx == (NSUInteger)self.currentPage + 1) {
            
            dot.alpha = (self.currentPage - (NSUInteger)self.currentPage);
        }
        else { dot.alpha = 0.0f; }
    }];
}

- (void)prepareInactiveDots {
    
    CGSize dotImageSize = self.inactiveDotImage.size;
    CGSize imageSize = (CGSize){.width = dotImageSize.width + self.dotsHorizontalStep, 
                                .height = self.frame.size.height};
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0f);
    CGPoint dotLocation = (CGPoint){.y = ceilf((imageSize.height - dotImageSize.height) * 0.5f)};
    [self.inactiveDotImage drawInRect:(CGRect){.origin = dotLocation, .size = dotImageSize}];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGSize dotsBlockSize = (CGSize){.width = imageSize.width * self.numberOfPages - self.dotsHorizontalStep, 
                                    .height = imageSize.height};
    self.inactiveDots = [[UIView alloc] initWithFrame:(CGRect){.size = dotsBlockSize}];
    self.inactiveDots.backgroundColor = [UIColor colorWithPatternImage:result];
    [self.inactiveDots setSize:dotsBlockSize keepOrigin:NO];
    [self.inactiveDots makeSizeConstant];
    [self.inactiveDots setViewAdditionHandlerBlock:^(UIView *superview, UIView *view) {
        
        [view alignCenterIn:superview withOffset:CGPointZero];
    }];
    [self addSubview:self.inactiveDots];
}

- (void)prepareActiveDots {
    
    self.activeDots = [NSMutableArray new];
    CGSize dotImageSize = self.activeDotImage.size;
    CGFloat dotPosition = (-self.inactiveDots.frame.size.width * 0.5f + dotImageSize.width * 0.5f);
    for (NSUInteger dotIdx = 0; dotIdx < self.numberOfPages; dotIdx++) {
        
        UIImageView *dotImageView = [[UIImageView alloc] initWithImage:self.activeDotImage];
        [dotImageView makeSizeConstant];
        dotImageView.layer.shadowOffset = CGSizeMake(0.0f, 0.5f);
        dotImageView.layer.shadowRadius = 0.8f;
        dotImageView.layer.shadowOpacity = 0.35f;
        dotImageView.layer.shadowColor = [UIColor colorWithRed:0.67f green:0.67f blue:0.67f alpha:1.0f].CGColor;
        [dotImageView setViewAdditionHandlerBlock:^(UIView *superview, UIView *view) {
            
            [view alignHorizontalCenterIn:superview withOffset:dotPosition];
            [view alignVerticalCenterIn:superview withOffset:0.5f];
        }];
        dotPosition += (dotImageSize.width + self.dotsHorizontalStep);
        dotImageView.alpha = 0.0f;
        [self.activeDots addObject:dotImageView];
        [self addSubview:dotImageView];
    }
}

#pragma mark -


@end
