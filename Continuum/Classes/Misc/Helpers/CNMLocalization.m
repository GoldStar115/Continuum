/**
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
#import "CNMLocalization.h"


#pragma mark Interface implementation

@implementation CNMLocalization


#pragma mark - Strings localization

+ (NSString *)localizedStringByKey:(NSString *)key {
    
    return [self localizedStringByKey:key fromTable:@"Localizable"];
}

+ (NSString *)localizedStringByKey:(NSString *)key fromTable:(NSString *)table {
    
    return [[NSBundle mainBundle] localizedStringForKey:key value:key table:table];
}

#pragma mark -


@end
