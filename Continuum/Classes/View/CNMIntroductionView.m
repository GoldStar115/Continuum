/**
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
#import "CNMIntroductionView.h"
#import "UIView+CNMAdditions.h"
#import "CNMLocalization.h"
#import "CNMPageControl.h"
#import "CNMLabel.h"


#pragma mark Private interface declaration

@interface CNMIntroductionView () <UIScrollViewDelegate>


#pragma mark - Properties

/**
 @brief  Stores reference on scroll view which is used to present introduction pages.
 */
@property (nonatomic, weak) IBOutlet UIScrollView *pagesScrollView;

/**
 @brief  Stores reference on controller which is used to show how far user scrolled from the start.
 */
@property (nonatomic, weak) IBOutlet CNMPageControl *pageControl;

/**
 @brief  Stores reference on button which is shown at the end of introduction course.
 */
@property (nonatomic, weak) IBOutlet UIButton *continuumButton;

/**
 @brief  Stores reference on page starting from which pages should be on the right side of it.
 */
@property (nonatomic, weak) IBOutlet UIView *lastPageView;

/**
 @brief      Stores reference on name of the file which store pages text.
 @discussion All texts stored in localized property list file.
 */
@property (nonatomic, copy) IBInspectable NSString *textsFileName;

/**
 @brief  Stores reference on names of the fonts which should be used for introduction pages title and 
         description labels.
 */
@property (nonatomic, copy) IBInspectable NSString *titleFontName;
@property (nonatomic, copy) IBInspectable NSString *descriptionFontName;

/**
 @brief  Stores reference on JSON which is use to describe labels layout behavior on introduction page.
 */
@property (nonatomic, copy) IBInspectable NSString *titleInstruction;
@property (nonatomic, copy) IBInspectable NSString *descriptionInstruction;
@property (nonatomic, copy) IBInspectable NSString *spacingInstruction;


#pragma mark - Interface customization

/**
 @brief  Read texts for introduction screen from passed file and build pages to show it.
 */
- (void)addIntroductionPages;

/**
 @brief      Make sure what Continuum button shown correctly.
 @discussion For proper button layout it's holder should upate height to the height of passed view.
 */
- (void)upateContinuumButtonLayoutRelativeTo:(UIView *)view;

/**
 @brief      Make sure what page control shown correctly.
 @discussion For proper page control layout it should use view under which holder's top borer should be 
             attached.
 */
- (void)upatePageControlLayoutRelativeTo:(UIView *)view;


#pragma mark - Misc

/**
 @brief  Retrieve array of dictionaries which contain text for pages.
 
 @return Array with dictionaries which contain text for pages.
 */
- (NSArray *)textForPages;

/**
 @brief  Construct introduction page with specified title and description.
 
 @param title   Page title which will be shown in bold at the top of the page.
 @param details Details message which goes after page title label.
 */
- (UIView *)pageWithTitle:(NSString *)title details:(NSString *)details;

/**
 @brief  Construct label explicitly for page title layout.
 
 @param title Reference on text which should be shown inside of label.
 
 @return Configured and ready to use label instance.
 */
- (CNMLabel *)titleLabelWithText:(NSString *)title;

/**
 @brief  Construct label explicitly for page details layout.
 
 @param details Reference on text which should be shown inside of label.
 
 @return Configured and ready to use label instance.
 */
- (CNMLabel *)etailsLabelWithText:(NSString *)details;

/**
 @brief  Construct label for specified text. 
 
 @param text               Reference on text for which label is created.
 @param isAttributedString Whether label should present text as attributed string or not.
 
 @return Configured and ready to use label instance.
 */
- (CNMLabel *)labelForText:(NSString *)text attributedString:(BOOL)isAttributedString;

#pragma mark - 


@end


#pragma mark - Interface implementation

@implementation CNMIntroductionView

- (void)awakeFromNib {
    
    // Forwar method call to the super class.
    [super awakeFromNib];
    
    [self addIntroductionPages];
}


#pragma mark - Interface customization

- (void)addIntroductionPages {
    
    self.hidden = YES;
    NSArray *pageTexts = [self textForPages];
    
    // Will store reference on view for first page which will tage whole
    // free space under text block and used to calculate page control
    // position
    __block UIView *bottomSpaceView = nil;
    
    __block UIView *previousPage = self.lastPageView;
    __block UIView *previousTextBlock = nil;
    
    [pageTexts enumerateObjectsWithOptions:NSEnumerationReverse 
                                usingBlock:^(NSDictionary *pageData, NSUInteger pageDataIdx, 
                                             BOOL *pagesDataEnumeratorStop) {
        
        NSString *pageTitle = [CNMLocalization localizedStringByKey:pageData[@"title"] 
                                                          fromTable:self.textsFileName];
        NSString *pageDetails = [CNMLocalization localizedStringByKey:pageData[@"details"]
                                                            fromTable:self.textsFileName];
        UIView *page = [self pageWithTitle:pageTitle details:pageDetails];
        UIView *textBlock = page.subviews[0];
        [self.pagesScrollView addSubview:page];
        [page alignLeftCenterFrom:previousPage withOffset:CGPointZero];
        if (pageDataIdx == 0) { 
            
            [page alignLeftCenterIn:self.pagesScrollView withOffset:CGPointZero]; 
            bottomSpaceView = [[UIView alloc] initWithFrame:(CGRect){.size = page.frame.size}];
            bottomSpaceView.backgroundColor = page.backgroundColor;
            [bottomSpaceView setViewAdditionHandlerBlock:^(UIView *superview, UIView *view) {
                
                [[view makeWidthSameAs:superview] alignBottomCenterFrom:textBlock withOffset:CGPointZero];
                [view alignBottomCenterIn:superview withOffset:CGPointZero];
            }];
            [page addSubview:bottomSpaceView];
        }
        if (previousTextBlock) { [textBlock makeHeightSameAs:previousTextBlock]; }
        previousPage = page;
        previousTextBlock = page.subviews[0];
    }];
    
    [self upateContinuumButtonLayoutRelativeTo:previousTextBlock];
    [self upatePageControlLayoutRelativeTo:bottomSpaceView];
    self.hidden = NO;
}

- (void)upateContinuumButtonLayoutRelativeTo:(UIView *)view {
    
    UIView *buttonHolder = self.continuumButton.superview;
    [buttonHolder makeHeightSameAs:view];
}

- (void)upatePageControlLayoutRelativeTo:(UIView *)view {
    
    UIView *pageControlHolder = self.pageControl.superview;
    [pageControlHolder makeHeightSameAs:view];
    
    NSArray *pageTexts = [self textForPages];
    self.pageControl.numberOfPages = pageTexts.count + 1;
    self.pageControl.currentPage = 0.0f;
    self.pageControl.dotsHorizontalStep = 8.0f;
    self.pageControl.inactiveDotImage = [UIImage imageNamed:@"splash-pager-inactive"];
    self.pageControl.activeDotImage = [UIImage imageNamed:@"splash-pager-active"];
}


#pragma mark - Misc

- (NSArray *)textForPages {
    
    // Compose path to the file which store texts
    NSString *filePath = [[NSBundle mainBundle] pathForResource:self.textsFileName ofType:@"plist"];
    
    return [NSArray arrayWithContentsOfFile:filePath];
}

- (UIView *)pageWithTitle:(NSString *)title details:(NSString *)details {
    
    UIView *page = [[UIView alloc] initWithFrame:(CGRect){.size = self.frame.size}];
    page.hidden = YES;
    page.backgroundColor = [UIColor clearColor];
    UIView *textBlockView = [[UIView alloc] initWithFrame:page.frame];
    textBlockView.backgroundColor = page.backgroundColor;
    [textBlockView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [textBlockView setViewAdditionHandlerBlock:^(UIView *superview, UIView *view) {

        [[[view makeWidthSameAs:superview] makeHeightGreaterThan:100.0f] makeHeightLessThanView:superview];
        [view alignCenterIn:superview withOffset:CGPointZero];
    }];
    
    CNMLabel *titleLabel = [self titleLabelWithText:title];
    [titleLabel setViewAdditionHandlerBlock:^(UIView *superview, UIView *view) {
        
        [[view makeWidthSameAs:superview] alignTopCenterIn:superview withOffset:CGPointZero];
    }];
    
    CNMLabel *detailsLabel = [self etailsLabelWithText:details];
    [detailsLabel setViewAdditionHandlerBlock:^(UIView *superview, UIView *view) {
        
        [[view makeWidthSameAs:superview] alignBottomCenterFrom:titleLabel withOffset:CGPointMake(0.0f, 10.0f)];
        [view alignBottomCenterIn:superview withOffset:CGPointZero
                       constraint:CNMConstraintMake(CNMConstraintFixed, CNMConstraintFlexibleLess)];
    }];
    [textBlockView addSubviews:@[titleLabel, detailsLabel]];
    [page addSubview:textBlockView];
    
    __block __weak UIView *weakPage = page;
    [page setViewAdditionHandlerBlock:^(UIView *superview, UIView *view) {
        
        __block __strong UIView *strongPage = weakPage;
        [view makeSizeSameAs:self.lastPageView];
        strongPage.hidden = NO;
    }];
    
    return page;
}

- (CNMLabel *)titleLabelWithText:(NSString *)title {
    
    CNMLabel *label = [self labelForText:title attributedString:NO];
    label.sizeInstruction = self.titleInstruction;
    label.font = [UIFont fontWithName:self.titleFontName size:6.0f];
    
    return label;
}

- (CNMLabel *)etailsLabelWithText:(NSString *)details {
    
    CNMLabel *label = [self labelForText:details attributedString:YES];
    label.sizeInstruction = self.descriptionInstruction;
    label.spacingInstruction = self.spacingInstruction;
    label.font = [UIFont fontWithName:self.descriptionFontName size:6.0f];
    
    return label;
}

- (CNMLabel *)labelForText:(NSString *)text attributedString:(BOOL)isAttributedString {
    
    CNMLabel *label = [[CNMLabel alloc] initWithFrame:(CGRect){.size = self.frame.size}];
    [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 100;
    label.text = text;
    label.attributeString = isAttributedString;
    
    return label;
}

#pragma mark -


@end
