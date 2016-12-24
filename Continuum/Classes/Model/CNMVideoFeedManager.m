/**
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
#import "CNMVideoFeedManager.h"
#import "CNMVimeoChannelVideosRequest.h"
#import "CNMVimeoVideoCreditsRequest.h"
#import "CNMVimeoVideoRequest.h"
#import "NSArray+CNMAdditions.h"
#import "CNMVideo+Private.h"
#import "CNMNetorkManager.h"


#pragma mark Static

/**
 @brief  Stores how many entries should be fecthed at once.
 */
static NSInteger const kCNMMaximumEntriesPerRequest = 5;


#pragma mark - Private interface declaration

@interface CNMVideoFeedManager ()


#pragma mark - Properties

/**
 @brief  Stores reference on string which is used to authorize with remote service.
 */
@property (nonatomic, copy) NSString *clientAccessToken;

/**
 @brief  Stores reference on client which is used to communicate with remote data provider.
 */
@property (nonatomic) CNMNetorkManager *networkManager;

/**
 @brief  Stores reference on identifier of channel on remote data provider which contains data which should be
         shown.
 */
@property (nonatomic, copy) NSString *channelIdentifier;

/**
 @brief  Stores reference on current page for which data has been fetched or will be fetched with next 
         request.
 */
@property (nonatomic, assign) NSUInteger currentPage;

/**
 @brief  Stores whether client requesting first page with latest video entries.
 */
@property (nonatomic, assign) BOOL fetchingFreshPage;

/**
 @brief  Stores reference on currently active network request.
 */
@property (nonatomic) CNMVimeoChannelVideosRequest *currentRequest;

/**
 @brief  Stores whether remote data provider is able to provide more pages with data or not.
 */
@property (nonatomic, assign) BOOL hasMorePages;

/**
 @brief  Stores information about how many entries remote data provider is able to return.
 */
@property (nonatomic, assign) NSUInteger totalEntriesCount;

/**
 @brief  Stores reference on dictionary where each entry is video identifier and value is video model 
         instance.
 */
@property (nonatomic) NSMutableDictionary<NSString *, CNMVideo *> *entries;


#pragma mark - Initialization and Configuration

/**
 @brief  Initialize manager instance to operate with predefined configuration.

 @param token Reference on service-generated persistent access token with required access rights.
 
 @return Configured and ready to use viedeo feed manager.
 */
- (instancetype)initWithClientAccessToken:(NSString *)token;


#pragma mark - Feed data

/**
 @brief  Retrieve list of vieo entries which is available at current page.
 
 @param identifier Reference on ientifier of the channel from which list of videos should be downloaded. This
                   also can be URI from user's information request.
 @param block      Reference on block which will be called as soon as all videos will be retrieved.
 */
- (void)fetchFeedWithCompletion:(void(^)(NSArray<CNMVideo *> *feed, NSError *error))block;

/**
 @brief  Handle data fetch request completion.
 
 @param data  Reference on instance which store remote data provider response.
 @param error Stores reference on request processing error.
 @param block Reference on block which will be called as soon as all videos will be retrieved.
 */
- (void)handleFeedResponse:(NSDictionary *)data withError:(NSError *)error 
                completion:(void(^)(NSArray<CNMVideo *> *feed, NSError *error))block;

/**
 @brief  Handle data parsing completion.
 
 @param videos Reference on list of entries which has been parsed and stored in local cache.
 @param block  Reference on block which will be called as soon as all videos will be retrieved.
 */
- (void)handleParseCompletion:(NSArray<CNMVideo *> *)videos 
               withCompletion:(void(^)(NSArray<CNMVideo *> *feed, NSError *error))block;

/**
 @brief  Handle video data fetch request completion.
 
 @param data  Reference on instance which store remote data provider response.
 @param error Stores reference on request processing error.
 @param block Reference on block which will be called as soon as video data will be retrieved.
 */
- (void)handleVideoResponse:(NSDictionary *)data withError:(NSError *)error 
                 completion:(void(^)(CNMVideo *video))block;


#pragma mark - Misc

/**
 @brief  Use gathered video entries information to create sorted list of entries.
 
 @return List of \b CNMVideo entries sorted by \c idx field.
 */
- (NSArray<CNMVideo *> *)sortedEntries;

/**
 @brief  Calculate next request page basing on information stored in cache.
 
 @return Index of next page for which data should be retrieved.
 */
- (NSUInteger)nextPageIndex;

#pragma mark -


@end


#pragma mark - Interface implementation

@implementation CNMVideoFeedManager


#pragma mark - Initialization and Configuration

+ (instancetype)managerWithClientAccessToken:(NSString *)token {
    
    return [[self alloc] initWithClientAccessToken:token];
}

- (instancetype)initWithClientAccessToken:(NSString *)token {
    
    // Check whether initialization was successful or not.
    if ((self = [super init])) {
        
        _clientAccessToken = [token copy];
        _entries = [NSMutableDictionary new];
        _hasMorePages = YES;
        [CNMVimeoChannelVideosRequest setAccessToken:token];
        [CNMVimeoRequest setAccessToken:token];
        self.networkManager = [CNMNetorkManager new];
    }
    
    return self;
}


#pragma mark - Feed data

- (void)setChannelIentifier:(NSString *)identifier {
    
    self.channelIdentifier = identifier;
}

- (void)fetchNewestFeedWithCompletion:(void(^)(NSArray<CNMVideo *> *feed, NSError * _Nullable error))block {

    if (!self.fetchingFreshPage && self.currentRequest) {
        
        [self.networkManager cancelRequest:self.currentRequest];
        self.currentRequest = nil;
    }
    
    if (!self.currentRequest) {
        
        self.currentPage = 1;
        [self fetchFeedWithCompletion:block];
    }
}

- (void)fetchNextFeedPageWithCompletion:(void(^)(NSArray<CNMVideo *> *feed, NSError * _Nullable error))block {
    
    if (self.hasMorePages) {
        
        self.currentPage = [self nextPageIndex];
        [self fetchFeedWithCompletion:block];
    }
    else { dispatch_async(dispatch_get_main_queue(), ^{ block([self sortedEntries], nil); }); }
}

- (void)fetchFeedWithCompletion:(void(^)(NSArray<CNMVideo *> *feed, NSError *error))block {
    
    CNMVimeoChannelVideosRequest *request = [CNMVimeoChannelVideosRequest requestForChannel:self.channelIdentifier
                                             toFetch:kCNMMaximumEntriesPerRequest withPageOffset:self.currentPage];
    self.fetchingFreshPage = (self.currentPage == 1);

    __block __weak typeof(self) weakSelf = self;
    self.currentRequest = [self.networkManager fetchJSONWithRequest:request 
                                                    completionBlock:^(id JSONObject, NSError *error) {

        __block __strong typeof(self) strongSelf = weakSelf;
        strongSelf.currentRequest = nil;
        [strongSelf handleFeedResponse:JSONObject withError:error completion:block];
        strongSelf.fetchingFreshPage = NO;
    }];
}

- (void)fetchAndUpdateDataForVideo:(CNMVideo *)video withCompletion:(dispatch_block_t)block {
    
    CNMVimeoVideoRequest *request = [CNMVimeoVideoRequest requestForVideo:video];
    
    __weak __typeof__(self) weakSelf = self;
    [self.networkManager fetchJSONWithRequest:request completionBlock:^(id JSONObject, NSError *error) {
        
        __typeof__(weakSelf) strongSelf = weakSelf;
        [strongSelf handleVideoResponse:JSONObject withError:error completion:^(CNMVideo *upatedVideo) {
            
            if (upatedVideo) { [video updateWithVideo:upatedVideo]; }
            block();
        }];
    }];
}

- (void)handleFeedResponse:(NSDictionary *)data withError:(NSError *)error 
                completion:(void(^)(NSArray<CNMVideo *> *feed, NSError *error))block {
    
    if (((NSArray *)data[@"data"]).count) {
        
        NSArray *videoEntries = [(NSArray *)data[@"data"] cnm_shuffledArray];
        self.totalEntriesCount = ((NSNumber *)data[@"total"]).unsignedIntegerValue;
        self.hasMorePages = (data[@"paging"][@"next"] != nil); 
        NSUInteger currentIndex = self.totalEntriesCount;
        if (self.entries.count > 0 && !self.fetchingFreshPage) {
            
            currentIndex = [self sortedEntries].lastObject.idx.unsignedIntegerValue - 1;
        }
        
        NSMutableArray *videos = [NSMutableArray new];
        for (NSDictionary *videoInformation in videoEntries) {
            
            CNMVideo *video = [CNMVideo new];
            [video mapDataFromDictionary:videoInformation];
            video.idx = @(currentIndex);
            currentIndex--;
            [videos addObject:video];
        }
        [self handleParseCompletion:videos withCompletion:block];
    }
    else { dispatch_async(dispatch_get_main_queue(), ^{ block([self sortedEntries], error); }); }
}

- (void)handleParseCompletion:(NSArray<CNMVideo *> *)videos 
               withCompletion:(void(^)(NSArray<CNMVideo *> *feed, NSError *error))block {

    dispatch_group_t processingGroup = dispatch_group_create();
    
    // Store fetched objects.
    for (CNMVideo *video in videos) { 
        
        if (!self.entries[video.identifier]) {
            
            if (self.entries[video.identifier].author.length == 0) {
                
                dispatch_group_enter(processingGroup);
                CNMVimeoVideoCreditsRequest *request = [CNMVimeoVideoCreditsRequest requestForVideo:video];
                
                __weak __typeof__(self) weakSelf = self;
                [self.networkManager fetchJSONWithRequest:request
                                          completionBlock:^(id JSONObject, NSError *error) {
                    
                    __typeof__(weakSelf) strongSelf = weakSelf;
                    [video updateCredits:((NSDictionary *)JSONObject)[@"data"]];
                    strongSelf.entries[video.identifier] = video;
                    dispatch_group_leave(processingGroup);
                }];
            }
            else { self.entries[video.identifier] = video; }
        }
    }
    
    dispatch_group_notify(processingGroup, dispatch_get_main_queue(), ^{
        
        block([self sortedEntries], nil);
    });
}

- (void)handleVideoResponse:(NSDictionary *)data withError:(NSError *)error 
                 completion:(void(^)(CNMVideo *video))block {
    
    CNMVideo *video = nil;
    if (data[@"link"]) {
        
        video = [CNMVideo new];
        [video mapDataFromDictionary:data];
    }
    dispatch_async(dispatch_get_main_queue(), ^{ block(video); });
}


#pragma mark - Misc

- (NSArray<CNMVideo *> *)sortedEntries {
    
    static NSSortDescriptor *_sortDescriptor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"idx" ascending:NO];
    });
    
    return [self.entries.allValues sortedArrayUsingDescriptors:@[_sortDescriptor]];
}

- (NSUInteger)nextPageIndex {
    
    NSUInteger nextPageIndex = 1;
    if (self.entries.count) {
        
        double lastCachedIdx = (double)(self.sortedEntries.lastObject.idx.unsignedIntegerValue - 1);
        double indexOffset = (double)self.totalEntriesCount - lastCachedIdx;
        double lastCachedPage = indexOffset / kCNMMaximumEntriesPerRequest;
        if (lastCachedIdx > 1.0f) { nextPageIndex = (NSUInteger)lastCachedPage + 1; }
    }
    
    return nextPageIndex;
}

#pragma mark - 


@end
