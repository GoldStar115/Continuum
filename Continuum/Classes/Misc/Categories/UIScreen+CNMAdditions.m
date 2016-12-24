/**
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum Luxury, LLC.
 */
#import "UIScreen+CNMAdditions.h"
#import <objc/runtime.h>


#pragma mark Private interface declaration

@interface UIScreen (CNMAdditionsPrivate)


#pragma mark - Misc

/**
 @brief  Calculate screen size (diagonal) basing on it's resolution.
 
 @param size Screen resolution for which calculations should be done.
 */
- (NSNumber *)diagonalForSize:(CGSize)size;

#pragma mark -


@end


#pragma mark - Interface implementation

@implementation UIScreen (CNMAdditions)


#pragma mark - Information

- (NSNumber *)diagonal {
    
    NSNumber *diagonal = objc_getAssociatedObject(self, "cnm_screenDiagonal");
    if (!diagonal) {
        
        diagonal = [self diagonalForSize:self.bounds.size];
        objc_setAssociatedObject(self, "cnm_screenDiagonal", diagonal, OBJC_ASSOCIATION_RETAIN);
    }
    
    return diagonal;
}


#pragma mark - Misc

- (NSNumber *)diagonalForSize:(CGSize)size {
    
    NSNumber *diagonal = nil;
    // iPhone 4
    if ((int)size.height == 480) { diagonal = @(3.5); }
    // iPhone 5
    else if ((int)size.height == 568) { diagonal = @(4); }
    // iPhone 6
    else if ((int)size.width == 375) { diagonal = @(4.7); }
    // iPhone 6 Plus
    else if ((int)size.width == 414) { diagonal = @(5.5); }
    
    return diagonal;
}

#pragma mark -


@end
