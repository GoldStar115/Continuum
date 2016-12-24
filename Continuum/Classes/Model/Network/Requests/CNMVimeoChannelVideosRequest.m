/**
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
#import "CNMVimeoChannelVideosRequest.h"
#import "CNMBaseRequest+Private.h"


#pragma mark Private interface declaration

@interface CNMVimeoChannelVideosRequest ()


#pragma mark - Initialization and Configuration

/**
 @brief  Initialize request which will allow to retrieve fixed amount of entries from remote data provider.
 
 @param identifier      Unique remote video channel identifier.
 @param numberOfEntries Maximum number of entries which should be retrieved from remote data provider per
                        request.
 @param page            Offset in pages count.
 
 @return Initialized and ready to use request model instance.
 */
- (instancetype)initWithChannel:(NSString *)identifier toFetch:(NSUInteger)numberOfEntries
                 withPageOffset:(NSUInteger)page;


#pragma mark - Misc

/**
 @brief  Compose remote resource request path.
 
 @param identifier Unique remote video channel identifier.
 
 @return Request path which can be used to access video entries from remote data provider channel.
 */
- (NSString *)pathForChannel:(NSString *)identifier;

/**
 @brief  Compose query dictionary which will have information to request required portion of data.
 
 @param page  Offset in pages at which entries should be retrieved.
 @param count Number of entries which should be pulled out.
 
 @return Configured and ready to use query dictionary.
 */
- (NSDictionary *)queryForEntriesAtPage:(NSUInteger)page count:(NSUInteger)count;

#pragma mark -


@end


#pragma mark - Interface implementation

@implementation CNMVimeoChannelVideosRequest


#pragma mark - Initialization and Configuration

+ (instancetype)requestForChannel:(NSString *)identifier toFetch:(NSUInteger)numberOfEntries
                   withPageOffset:(NSUInteger)page {
    
    return [[self alloc] initWithChannel:identifier toFetch:numberOfEntries withPageOffset:page];
}

- (instancetype)initWithChannel:(NSString *)identifier toFetch:(NSUInteger)numberOfEntries 
                 withPageOffset:(NSUInteger)page {
    
    // Check whether initialization was successful or not.
    if ((self = [super init])) {
        
        self.path = [self pathForChannel:identifier];
        self.query = [self queryForEntriesAtPage:page count:numberOfEntries];
    }
    
    return self;
}


#pragma mark - Misc

- (NSString *)pathForChannel:(NSString *)identifier {
    
    return [NSString stringWithFormat:@"/channels/%@/videos", identifier];
}

- (NSDictionary *)queryForEntriesAtPage:(NSUInteger)page count:(NSUInteger)count {
    
    return @{@"direction": @"desc", @"page": @(page), @"per_page": @(count), @"sort": @"added",
             @"fields": @"link,name,created_time,description,duration,pictures.sizes,files.quality,"
                         "files.width,files.height,files.link_secure,files.quality.size"};
}

#pragma mark -


@end
