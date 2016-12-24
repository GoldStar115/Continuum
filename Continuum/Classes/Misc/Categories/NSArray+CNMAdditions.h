#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

/**
 @brief  Useful \a NSArray class extensions for application.
 
 @author Sergey Mamontov
 @since 1.0.1
 @copyright © 2015 Continuum Luxury, LLC.
 */
@interface NSArray (CNMAdditions)


///------------------------------------------------
/// @name Content management
///------------------------------------------------

/**
 @brief  Shuffle receiver's content.
 
 @return Array with receiver's content which has been randonmly shuffled.
 */
- (NSArray *)cnm_shuffledArray;

#pragma mark -


@end

NS_ASSUME_NONNULL_END
