/**
 @author Sergey Mamontov
 @since 1.0.1
 @copyright © 2015 Continuum Luxury, LLC.
 */
#import "NSArray+CNMAdditions.h"


#pragma mark - Category interface implementation

@implementation NSArray (CNMAdditions)


#pragma mark - Content management

- (NSArray *)cnm_shuffledArray {
    
    NSMutableArray *mutableSelf = [self mutableCopy];    
    for (NSUInteger elementIdx = self.count - 1; elementIdx > 0; elementIdx--) {
        
        NSUInteger targetElementIdx = (NSUInteger)arc4random_uniform((u_int32_t)elementIdx + 1);
        [mutableSelf exchangeObjectAtIndex:elementIdx withObjectAtIndex:targetElementIdx];
    }
    
    return [mutableSelf copy];
}

#pragma mark -


@end
