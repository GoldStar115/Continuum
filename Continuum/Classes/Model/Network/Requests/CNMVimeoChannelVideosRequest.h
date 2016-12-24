#import "CNMVimeoRequest.h"


NS_ASSUME_NONNULL_BEGIN

/**
 @brief  Request model which describe way to retrieve list of video entries from remote data provider.
 
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
@interface CNMVimeoChannelVideosRequest : CNMVimeoRequest


///------------------------------------------------
/// @name Initialization and Configuration
///------------------------------------------------

/**
 @brief  Construct and configure request which will allow to retrieve fixed amount of entries from remote data
         provider.
 
 @param identifier      Unique remote video channel identifier.
 @param numberOfEntries Maximum number of entries which should be retrieved from remote data provider per 
                        request.
 @param page            Offset in pages count.
 
 @return Configured and ready to use request model instance.
 */
+ (instancetype)requestForChannel:(NSString *)identifier toFetch:(NSUInteger)numberOfEntries 
                   withPageOffset:(NSUInteger)page;

#pragma mark -


@end

NS_ASSUME_NONNULL_END
