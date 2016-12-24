/**
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
#import "CNMButton.h"
#import "UIScreen+CNMAdditions.h"
#import "UIView+CNMAdditions.h"


#pragma mark Private interface declaration

@interface CNMButton ()


#pragma mark - Properties

/**
 @brief  Stores whether additional user information has been passed for size configuration or not.
 */
@property (nonatomic, assign) BOOL sizeShouldBeSet;

/**
 @brief  Stores size of button which should be used when interface presented in different orientations.
 */
@property (nonatomic, assign) CGSize sizeForPortrait;
@property (nonatomic, assign) CGSize sizeForLandscape;

/**
 @brief  Stores whether additional user information has been passed for image edge insets configuration or not.
 */
@property (nonatomic, assign) BOOL imageEdgeInsetsShouldBeSet;

/**
 @brief  Stores reference on image insets which has been set for button to show.
 */
@property (nonatomic, assign) UIEdgeInsets imageEdgeInsetsForPortrait;
@property (nonatomic, assign) UIEdgeInsets imageEdgeInsetsForLandscape;


#pragma mark - Layout customization

/**
 @brief  Upate button layout basing on latest information about state.
 */
- (void)upateLayout;

/**
 @brief  Retrieve all user-provided lauyout options.
 */
- (void)readLayoutInstructions;

/**
 @brief  Apply all user-provided lauyout options.
 */
- (void)applyLayoutInstructions;


#pragma mark - Misc

/**
 @brief  Decode JSON instruction and return value which is suitable for current device size (diagonal).
 
 @param instructions Reference on stringified JSON which store instructions.
 
 @return Array which store values which can be used for different orientations.
 */
- (NSArray *)orientationBasedInstructionsFrom:(NSString *)instructionsJSON;

/**
 @brief  Calculate size which should be set to button when presented in \c orientation.
 
 @param orientation Interface orientation for which size should be calculated.
 
 @return Size which should be applied for button.
 */
- (CGSize)sizeForInterfaceOrientation:(UIInterfaceOrientation)orientation;

/**
 @brief  Perform calculations based on passed values for image edge inset.
 
 @param portraitData  Width and height which should be used by image and used during edge insets calculations
                      for portrait orientation.
 @param landscapeData Width and height which should be used by image and used during edge insets calculations
                      for landscape orientation.
 */
- (void)calculateImageEdgeInsetsWith:(NSArray<NSNumber *> *)portraitData 
                        andLandscape:(NSArray<NSNumber *> *)landscapeData;

/**
 @brief  Choose image inset which should be used for image (centered) layout basing on \c orientation.
 
 @param orientation Interface orientation for which inset should be calculated.
 
 @return Image edge inset hich should be applied for displayed image.
 */
- (UIEdgeInsets)imageEdgeInsetsForOrientation:(UIInterfaceOrientation)orientation;

#pragma mark -


@end


#pragma mark - Interface implementation

@implementation CNMButton


#pragma mark - View life-cycle

- (void)awakeFromNib {
    
    // Forwar method call to the super class.
    [super awakeFromNib];
    
    [self upateLayout];
}

- (void)didMoveToSuperview {
    
    [super didMoveToSuperview];
    [self upateLayout];
}


#pragma mark - Layout customization

- (void)upateLayout {
    
    [self readLayoutInstructions];
    [self applyLayoutInstructions];
}

- (void)readLayoutInstructions {
    
    self.sizeForPortrait = self.frame.size;
    self.sizeForLandscape = self.frame.size;
    self.imageEdgeInsetsForPortrait = UIEdgeInsetsZero;
    self.imageEdgeInsetsForLandscape = UIEdgeInsetsZero;
    if (self.sizeInstruction.length) {
        
        NSArray<NSArray *> *sizeForOrientation = [self orientationBasedInstructionsFrom:self.sizeInstruction];
        NSArray<NSNumber *> *portraitData = sizeForOrientation.firstObject;
        NSArray<NSNumber *> *landscapeData = sizeForOrientation.lastObject;
        self.sizeForPortrait = CGSizeMake(portraitData.firstObject.floatValue, portraitData.lastObject.floatValue);
        self.sizeForLandscape = CGSizeMake(landscapeData.firstObject.floatValue, landscapeData.lastObject.floatValue);
        self.sizeShouldBeSet = (sizeForOrientation.count > 0);
        
        if (self.imageSizeInstruction.length) {
            
            NSArray<NSArray *> *sizeForOrientation = [self orientationBasedInstructionsFrom:self.imageSizeInstruction];
            [self calculateImageEdgeInsetsWith:sizeForOrientation.firstObject 
                                  andLandscape:sizeForOrientation.lastObject];
            self.imageEdgeInsetsShouldBeSet = (sizeForOrientation.count > 0);
        }
    }
}

- (void)applyLayoutInstructions {
    
    if (self.sizeShouldBeSet) {
        
        [self removeConstraints:self.constraints];
        CGSize buttonSize = [self sizeForInterfaceOrientation:UIInterfaceOrientationPortrait];
        [self setSize:buttonSize keepOrigin:NO];
        [self makeSizeConstant];
    }
    
    if (self.imageEdgeInsetsShouldBeSet) {
        
        UIEdgeInsets insets = [self imageEdgeInsetsForOrientation:UIInterfaceOrientationPortrait];
        [self setImageEdgeInsets:insets];
    }
}


#pragma mark - Misc

- (NSArray *)orientationBasedInstructionsFrom:(NSString *)instructionsJSON {
    
    NSString *key = [NSString stringWithFormat:@"%@", UIScreen.mainScreen.diagonal];
    NSDictionary *instructions = nil;
    if (instructionsJSON.length) {
        
        NSData *instructionsData = [instructionsJSON dataUsingEncoding:NSUTF8StringEncoding];
        instructions = [NSJSONSerialization JSONObjectWithData:instructionsData
                                                       options:NSJSONReadingAllowFragments
                                                         error:nil];
    }
    
    return (instructions[key]?: nil);
}

- (CGSize)sizeForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    
    CGSize size = CGSizeZero;
    if (UIInterfaceOrientationIsPortrait(orientation)) { size = self.sizeForPortrait; }
    else if (UIInterfaceOrientationIsLandscape(orientation)) { size = self.sizeForLandscape; }
    
    return size;
}

- (void)calculateImageEdgeInsetsWith:(NSArray<NSNumber *> *)portraitData 
                        andLandscape:(NSArray<NSNumber *> *)landscapeData {
    
    CGSize sizeInPortrait = CGSizeMake(portraitData.firstObject.floatValue, portraitData.lastObject.floatValue);
    CGSize sizeInLandscape = CGSizeMake(landscapeData.firstObject.floatValue, landscapeData.lastObject.floatValue);
    
    CGFloat leftRightMargin = ceilf((self.sizeForPortrait.width - sizeInPortrait.width) * 0.5f);
    CGFloat topBottomMargin = ceilf((self.sizeForPortrait.height - sizeInPortrait.height) * 0.5f);
    self.imageEdgeInsetsForPortrait = UIEdgeInsetsMake(topBottomMargin, leftRightMargin, topBottomMargin, leftRightMargin);
    
    leftRightMargin = ceilf((self.sizeForLandscape.width - sizeInLandscape.width) * 0.5f);
    topBottomMargin = ceilf((self.sizeForLandscape.height - sizeInLandscape.height) * 0.5f);
    self.imageEdgeInsetsForLandscape = UIEdgeInsetsMake(topBottomMargin, leftRightMargin, topBottomMargin, leftRightMargin);
}

- (UIEdgeInsets)imageEdgeInsetsForOrientation:(UIInterfaceOrientation)orientation {
    
    UIEdgeInsets inset = UIEdgeInsetsZero;
    if (UIInterfaceOrientationIsPortrait(orientation)) { inset = self.imageEdgeInsetsForPortrait; }
    else if (UIInterfaceOrientationIsLandscape(orientation)) { inset = self.imageEdgeInsetsForLandscape; }
    
    return inset;
}

#pragma mark -


@end
