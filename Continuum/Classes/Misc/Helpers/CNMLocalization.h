#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

/**
 @brief      Localization usage helper.
 @discussion Helper make it easier to use localizable resources.
 
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
@interface CNMLocalization : NSObject


///------------------------------------------------
/// @name Strings localization
///------------------------------------------------

/**
 @brief  Retrieve localized string which is stored under specified \c key.
 
 @param key Reference on key under which in \c Localizable.strings file stored localized representation.
 
 @return Localized string from \c Localizable.strings.
 */
+ (NSString *)localizedStringByKey:(NSString *)key;

/**
 @brief  Retrieve localized string which is stored under specified \c key.
 
 @param key   Reference on key under which in \c <table>.strings file stored localized representation.
 @param table Name of the localization table inside of which corresponding \c key store value.
 
 @return Localized string from \c <table>.strings.
 */
+ (NSString *)localizedStringByKey:(NSString *)key fromTable:(NSString *)table;

#pragma mark -


@end

NS_ASSUME_NONNULL_END
