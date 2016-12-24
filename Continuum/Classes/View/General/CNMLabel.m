/**
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
#import "CNMLabel.h"
#import "UIScreen+CNMAdditions.h"


#pragma mark Private interface declaration

@interface CNMLabel ()


#pragma mark - Properties

/**
 @brief  Stores size of label font which should be used when interface presented in different orientations.
 */
@property (nonatomic, assign) CGFloat fontSizeForPortrait;
@property (nonatomic, assign) CGFloat fontSizeForLandscape;

/**
 @brief  Stores vertical line spacing which should be used when interface presented in different orientations.
 */
@property (nonatomic, assign) CGFloat lineSpacingForPortrait;
@property (nonatomic, assign) CGFloat lineSpacingForLandscape;

/**
 @brief  Stores reference on original text which has been shown in label.
 */
@property (nonatomic, copy) NSString *originalLabelText;


#pragma mark - Layout customization

/**
 @brief  Upate label layout basing on latest information about state.
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
 @brief  Construct font instance which should be used by label when presented in \c orientation.
 
 @param orientation Interface orientation for which font instance should be constructed.
 
 @return Constructed and ready to use font instance.
 */
- (UIFont *)fontForInterfaceOrientation:(UIInterfaceOrientation)orientation;

/**
 @brief  Construct attributes string which should be used by label when presented in \c orientation.
 
 @param orientation Interface orientation for which attributed string should be constructed.
 
 @return Constructed and ready to use attributes string.
 */
- (NSAttributedString *)attributedStringForInterfaceOrientation:(UIInterfaceOrientation)orientation;

#pragma mark -


@end


#pragma mark - Interface implementation

@implementation CNMLabel


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


#pragma mark - Instance methods

- (void)setText:(NSString *)text {
    
    // Forwar method call to the super class.
    [super setText:text];
    
    BOOL shouldUpdateLayout = !self.originalLabelText;
    self.originalLabelText = text;
    if (shouldUpdateLayout) { [self applyLayoutInstructions]; }
}

- (void)setFont:(UIFont *)font {
    
    BOOL shouldUpdateLayout = ![self.font isEqual:font];
    
    // Forwar method call to the super class.
    [super setFont:font];
    
    if (shouldUpdateLayout) { [self upateLayout]; }
}

- (void)setSizeInstruction:(NSString *)sizeInstruction {
    
    _sizeInstruction = sizeInstruction;
    [self upateLayout];
}

- (void)setAttributeString:(BOOL)attributeString {
    
    _attributeString = attributeString;
    [self upateLayout];
}

- (void)setSpacingInstruction:(NSString *)spacingInstruction {
    
    _spacingInstruction = spacingInstruction;
    [self upateLayout];
}


#pragma mark - Layout customization

- (void)upateLayout {
    
    [self readLayoutInstructions];
    [self applyLayoutInstructions];
}

- (void)readLayoutInstructions {
    
    if (self.sizeInstruction.length) {
        
        NSArray *sizeForOrientation = [self orientationBasedInstructionsFrom:self.sizeInstruction];
        self.fontSizeForPortrait = ((NSNumber *)sizeForOrientation.firstObject).floatValue;
        self.fontSizeForLandscape = ((NSNumber *)sizeForOrientation.lastObject).floatValue;
    }
    
    if (self.attributeString && self.spacingInstruction.length) {
        
        NSArray *spacingForOrientation = [self orientationBasedInstructionsFrom:self.spacingInstruction];
        self.lineSpacingForPortrait = ((NSNumber *)spacingForOrientation.firstObject).floatValue;
        self.lineSpacingForLandscape = ((NSNumber *)spacingForOrientation.lastObject).floatValue;
    }
    self.originalLabelText = self.text;
}

- (void)applyLayoutInstructions {
    
    if (self.sizeInstruction.length) {
        
        self.font = [self fontForInterfaceOrientation:UIInterfaceOrientationPortrait];
    }
    
    if (self.attributeString && self.spacingInstruction.length) {
        
        self.attributedText = [self attributedStringForInterfaceOrientation:UIInterfaceOrientationPortrait];
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

- (UIFont *)fontForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    
    CGFloat fontSize = 0.0f;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        
        fontSize = self.fontSizeForPortrait;
    }
    else if (UIInterfaceOrientationIsLandscape(orientation)) {
        
        fontSize = self.fontSizeForLandscape;
    }
    
    return (fontSize > 0.0f ? [UIFont fontWithName:self.font.fontName size:fontSize] : nil);
}

- (NSAttributedString *)attributedStringForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    
    NSUInteger lineSpacing = self.lineSpacingForPortrait;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        
        lineSpacing = self.lineSpacingForLandscape;
    }
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName: self.textColor,
                                 NSFontAttributeName: [self fontForInterfaceOrientation:orientation]
                                 };
    NSMutableAttributedString *attributedString = nil;
    attributedString = [[NSMutableAttributedString alloc] initWithString:self.originalLabelText
                                                              attributes:attributes];
    if (lineSpacing > 0) {
        
        NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
        style.lineSpacing = lineSpacing;
        style.alignment = self.textAlignment;
        [attributedString addAttribute:NSParagraphStyleAttributeName value:style
                                 range:NSMakeRange(0, self.originalLabelText.length)];
    }
    
    return attributedString;
}

#pragma mark -


@end
