/**
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
#import "CNMImageView.h"
#import "UIScreen+CNMAdditions.h"
#import "UIImage+CNMAdditions.h"
#import "UIView+CNMAdditions.h"
#import <Haneke/Haneke.h>


#pragma mark Private interface declaration

@interface CNMImageView ()


#pragma mark - Properties

/**
 @brief  Stores size of view which should be used when interface presented in different orientations.
 */
@property (nonatomic, assign) CGSize sizeForPortrait;
@property (nonatomic, assign) CGSize sizeForLandscape;


#pragma mark - Layout customization

/**
 @brief  Upate view layout basing on latest information about state.
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
 @brief  Construct image cache format which should be applied an used with specific interface orientation.

 @param orientation Interface orientation for which cache format should be created.
 
 @return Configured and ready to use image cache format.
 */
- (HNKCacheFormat *)cacheFormatForInterfaceOrientation:(UIInterfaceOrientation)orientation;

/**
 @brief  Decode JSON instruction and return value which is suitable for current device size (diagonal).
 
 @param instructions Reference on stringified JSON which store instructions.
 
 @return Array which store values which can be used for different orientations.
 */
- (NSArray *)orientationBasedInstructionsFrom:(NSString *)instructionsJSON;

/**
 @brief  Calculate size which should be set to view when presented in \c orientation.
 
 @param orientation Interface orientation for which size should be calculated.
 
 @return Size which should be applied for view.
 */
- (CGSize)sizeForInterfaceOrientation:(UIInterfaceOrientation)orientation;

#pragma mark -


@end


@implementation CNMImageView


#pragma mark - View life-cycle

- (void)awakeFromNib {
    
    // Forwar method call to the super class.
    [super awakeFromNib];
    
    [self upateLayout];
}


#pragma mark - Layout customization

- (void)upateLayout {
    
    [self readLayoutInstructions];
    [self applyLayoutInstructions];
}

- (void)readLayoutInstructions {
    
    if (self.sizeInstruction.length) {
        
        NSArray<NSArray *> *sizeForOrientation = [self orientationBasedInstructionsFrom:self.sizeInstruction];
        NSArray<NSNumber *> *portraitData = sizeForOrientation.firstObject;
        NSArray<NSNumber *> *landscapeData = sizeForOrientation.lastObject;
        self.sizeForPortrait = CGSizeMake(portraitData.firstObject.floatValue, portraitData.lastObject.floatValue);
        self.sizeForLandscape = CGSizeMake(landscapeData.firstObject.floatValue, landscapeData.lastObject.floatValue);
    }
}

- (void)applyLayoutInstructions {
    
    self.hnk_cacheFormat = [self cacheFormatForInterfaceOrientation:UIInterfaceOrientationPortrait];
}


#pragma mark - Misc

- (HNKCacheFormat *)cacheFormatForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    
    CGSize imageSize = [self sizeForInterfaceOrientation:UIInterfaceOrientationPortrait];
    NSString *formatName = [NSString stringWithFormat:@"continuum-%@x%@", 
                            @(imageSize.width), @(imageSize.height)];
    HNKCacheFormat *cacheFormat = [[HNKCacheFormat alloc] initWithName:formatName];
    cacheFormat.diskCapacity = (10 * 1024 * 1024);
    cacheFormat.allowUpscaling = YES;
    cacheFormat.compressionQuality = 0.8f;
    cacheFormat.scaleMode = HNKScaleModeNone;
    cacheFormat.postResizeBlock = ^UIImage* (NSString *key, UIImage *image) {
        
        return [image resizedImageToSize:imageSize withCrop:YES];
    };
    
    return cacheFormat;
}

- (NSArray *)orientationBasedInstructionsFrom:(NSString *)instructionsJSON {
    
    NSString *key = [NSString stringWithFormat:@"%@", UIScreen.mainScreen.diagonal];
    NSDictionary *instructions = nil;
    if (instructionsJSON.length) {
        
        NSData *instructionsData = [instructionsJSON dataUsingEncoding:NSUTF8StringEncoding];
        instructions = [NSJSONSerialization JSONObjectWithData:instructionsData
                                                       options:NSJSONReadingAllowFragments
                                                         error:nil];
        if (!instructionsData || !instructions) {
            
            NSLog(@"Instruction decode error: %@", instructionsJSON);
        }
    }
    
    return (instructions[key]?: nil);
}

- (CGSize)sizeForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    
    CGSize size = CGSizeZero;
    if (UIInterfaceOrientationIsPortrait(orientation)) { size = self.sizeForPortrait; }
    else if (UIInterfaceOrientationIsLandscape(orientation)) { size = self.sizeForLandscape; }
    
    return size;
}

#pragma mark -


@end
