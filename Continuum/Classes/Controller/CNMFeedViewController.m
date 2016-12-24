/**
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
#import "CNMFeedViewController.h"
#import "CNMVideoEntryCollectionViewCell.h"
#import "CNMVideoEntryInformationView.h"
#import "CNMVideoViewController.h"
#import "CNMVideoFeedManager.h"
#import "Mixpanel.h"
#import "CNMVideo.h"


#pragma mark Static


/**
 @brief  Static constants store reference on keys which is required for access to remote data provider.
 */
#if PRODUCTION == 1
    static NSString * const kCNMClientAccessToken = @"5b23a847f79be228166e208b2ba19bea";
#else
    static NSString * const kCNMClientAccessToken = @"935b0b6effb212e8b2c526243d950563";
#endif

/**
 @brief  Stores reference on channel identifier which should be used to fetch feed.
 */
#if PRODUCTION == 1
    static NSString * const kCNMContinuumChannelIdentifier = @"1030991";
#else
    static NSString * const kCNMContinuumChannelIdentifier = @"979125";
#endif

/**
 @brief  Static constant which store video cell identifier which should be used for entries layout.
 */
static NSString * const kCNMVideoCellViewIdentifier = @"CNMVideoCellIdentifier";

/**
 @brief  Static constant which store video loading cell identifier which should be used for entries layout.
 */
static NSString * const kCNMVideoLoadCellViewIdentifier = @"CNMVideoLoadCellIdentifier";


#pragma mark - Private interface declaration

@interface CNMFeedViewController () <UICollectionViewDelegate, UICollectionViewDataSource, 
                                     UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>


#pragma mark - Propeties

/**
 @brief  Stores reference on collection view which is responsible for video feed entries layout.
 */
@property (nonatomic, weak) IBOutlet UICollectionView *feedsCollectionView;

/**
 @brief  Stores reference on view which is responsible for video information layout.
 */
@property (nonatomic, weak) IBOutlet CNMVideoEntryInformationView *informationView;

/**
 @brief  Stores reference on page loader elements.
 */
@property (nonatomic, weak) IBOutlet UIView *pageLoaderView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *progressView;

/**
 @brief  Stores reference on controller which is used to show fresh feed loading.
 */
@property (nonatomic) UIRefreshControl *latestFeedRefreshControl;

/**
 @brief  Stores list of video entries from remote data provier which should be shown to the user.
 */
@property (nonatomic, strong) NSArray<CNMVideo *> *feed;

/**
 @brief  Stores reference on manager which handle communication with remote data provier.
 */
@property (nonatomic) CNMVideoFeedManager *feedManager;

/**
 @brief  Stores whether there is some data which can be pulled out from history or remote data provider.
 */
@property (nonatomic, assign) BOOL hasOlderEntriesToLoad;

/**
 @brief  Stores whether application currently fetch older records or not.
 */
@property (nonatomic, assign) BOOL fetchingOlderEntries;


#pragma mark - Interface customization

/**
 @brief  Prepare user interface layout.
 */
- (void)prepareLayout;

/**
 @brief  Construct and configure refresh controller to be used as pull-to-fetch more.
 
 @return Configured and ready to use refresh control.
 */
- (UIRefreshControl *)pullToFetchNewControl;

/**
 @brief  Update video information block.
 
 @param video Reference on video model instance which should be used for data layout.
 */
- (void)upateVideoInformation:(CNMVideo *)video;


#pragma mark - Data provier

/**
 @brief  Initialize and configure data stack.
 */
- (void)prepareDataProvider;

/**
 @brief  Retrieve latest video entries from remoted data provider.
 
 @param prefetchFromCache Whether data has been pre-fetched from local cache.
 @param block             Reference on block which should be called after new portion of data will be 
                          retrieved.
 */
- (void)fetchLatestEntries:(BOOL)prefetchFromCache withCompletion:(dispatch_block_t)block;

/**
 @brief  Retrieve older video entries from cache or remoted data provider.
 */
- (void)fetchOlderEntries;


#pragma mark - Handlers

/**
 @brief  Handle new feeds download completion.
 
 @param videos List with video entries.
 */
- (void)handleInitialFeedDidLoad:(NSArray<CNMVideo *> *)videos;

/**
 @brief  Handle refresh control pull.
 
 @param control Reference on controller which triggered update
                event.
 */
- (void)handlePullForNewData:(UIRefreshControl *)control;


#pragma mark - Misc

/**
 @brief  Present to the user message about feed request error.
 */
- (void)showRequestError;

#pragma mark -


@end


#pragma mark - Interface implementation

@implementation CNMFeedViewController


#pragma mark - Controller life-cycle methos

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return UIInterfaceOrientationPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    
    return NO;
}

- (void)viewDidLoad {
    
    // Forard method call to the super class.
    [super viewDidLoad];
    
    [self prepareLayout];
    [self prepareDataProvider];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    CGPoint feedOffset = self.feedsCollectionView.contentOffset;
    CGSize feedViewSize = self.feedsCollectionView.frame.size;
    NSUInteger page = feedOffset.y / feedViewSize.height;
    CNMVideo *video = self.feed[page];
    
    CNMVideoViewController *videoController = (CNMVideoViewController *)segue.destinationViewController;
    [videoController prepareForVideo:video withManager:self.feedManager];
#if !TARGET_IPHONE_SIMULATOR
    [[Mixpanel sharedInstance] track:@"Play video" properties:@{@"Title": video.name, 
                                                                @"Identifier": video.identifier}];
#endif
}


#pragma mark - Interface customization

- (void)prepareLayout {
    
    self.latestFeedRefreshControl = [self pullToFetchNewControl];
    [self.feedsCollectionView addSubview:self.latestFeedRefreshControl];
}

- (UIRefreshControl *)pullToFetchNewControl {
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor whiteColor];
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Checking for new videos..."
                                                                     attributes:attributes];
    [refreshControl addTarget:self action:@selector(handlePullForNewData:)
             forControlEvents:UIControlEventValueChanged];
    
    return refreshControl;
}

- (void)upateVideoInformation:(CNMVideo *)video {
    
    [self.informationView upateForVideo:video];
#if !TARGET_IPHONE_SIMULATOR
    [[Mixpanel sharedInstance] track:@"View video cover" 
                          properties:@{@"Title": video.name, @"Identifier": video.identifier}];
#endif
}


#pragma mark - Data provier

- (void)prepareDataProvider {
    
    self.feedManager = [CNMVideoFeedManager managerWithClientAccessToken:kCNMClientAccessToken];
    [self.feedManager setChannelIentifier:kCNMContinuumChannelIdentifier];
    
    __weak __typeof__(self) weakSelf = self;
    [self.feedManager fetchNewestFeedWithCompletion:^(NSArray<CNMVideo *> *feed, NSError *error) {
        
        [weakSelf handleInitialFeedDidLoad:feed];
    }];
}

- (void)fetchLatestEntries:(BOOL)prefetchFromCache withCompletion:(dispatch_block_t)block {
    
    __block __weak typeof(self) weakSelf = self;
    [self.feedManager fetchNewestFeedWithCompletion:^(NSArray<CNMVideo *> *feed, NSError *error) {
        
        __block __strong typeof(self) strongSelf = weakSelf;
        if (!error) {
            
            if (!prefetchFromCache) {
                
                strongSelf.feed = feed;
                [strongSelf upateVideoInformation:strongSelf.feed[0]];
                [strongSelf.feedsCollectionView reloadData];
                if (block) { block(); }
            }
            else { [strongSelf handleInitialFeedDidLoad:feed];}
        }
        else { 
            
            [strongSelf showRequestError]; 
            if (block) { block(); }
        }
    }];
}

- (void)fetchOlderEntries {
    
    if (!self.fetchingOlderEntries) {
        
        self.fetchingOlderEntries = YES;
        __block __weak typeof(self) weakSelf = self;
        [self.feedManager fetchNextFeedPageWithCompletion:^(NSArray<CNMVideo *> *feed, NSError *error) {
            
            __block __strong typeof(self) strongSelf = weakSelf;
            strongSelf.fetchingOlderEntries = NO;
            if (!error) {
                
                if (strongSelf.hasOlderEntriesToLoad) {
                    
                    strongSelf.hasOlderEntriesToLoad = (feed.lastObject.idx.unsignedIntegerValue > 1);
                }
                
                if (feed) {
                    
                    strongSelf.feed = feed;
                    [strongSelf.feedsCollectionView reloadData];
                }
            }
            else { [strongSelf showRequestError]; }
        }];
    }
}


#pragma mark - UICollectionView delegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return (self.feed.count + (self.hasOlderEntriesToLoad ? 1 : 0));
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView 
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *targetIdentifier = (indexPath.row < self.feed.count ? kCNMVideoCellViewIdentifier :
                                  kCNMVideoLoadCellViewIdentifier);
    id cell = [collectionView dequeueReusableCellWithReuseIdentifier:targetIdentifier
                                                         forIndexPath:indexPath];
    if (indexPath.row < self.feed.count) {
        
        [(CNMVideoEntryCollectionViewCell *)cell upateForVideo:self.feed[indexPath.row]];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout 
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = collectionView.bounds.size;
    if (indexPath.row == self.feed.count) { size.height = 80.0f; }
    
    return size;
}


#pragma mark- UIScrollView delegate methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.informationView.alpha = 0.0f;
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSUInteger page = scrollView.contentOffset.y / scrollView.frame.size.height;
    CNMVideo *video = self.feed[page];
    [self upateVideoInformation:video];
    [UIView animateWithDuration:0.3f animations:^{
        
        self.informationView.alpha = 1.0f;
    }];
    
    if (self.hasOlderEntriesToLoad && scrollView.contentOffset.y > scrollView.frame.size.height &&
        scrollView.contentOffset.y + scrollView.frame.size.height ==scrollView.contentSize.height) {
        
        [self fetchOlderEntries];
    }
}


#pragma mark - Handlers

- (void)handleInitialFeedDidLoad:(NSArray<CNMVideo *> *)videos {
    
    self.hasOlderEntriesToLoad = (videos.count > 0);
    if (self.hasOlderEntriesToLoad) {
        
        self.hasOlderEntriesToLoad = (videos.lastObject.idx.unsignedIntegerValue > 1);
    }
    
    if (videos.count > 0) {
        
        self.feed = videos;
        [self upateVideoInformation:self.feed[0]];
        self.informationView.hidden = NO;
        
        if (self.pageLoaderView.alpha > 0.0f) {
            
            [UIView animateWithDuration:0.3f animations:^{ self.pageLoaderView.alpha = 0.0f; }
                             completion:^(BOOL finished) { [self.progressView stopAnimating]; }];
        }
        [self.feedsCollectionView reloadData];
    }
}

- (void)handlePullForNewData:(UIRefreshControl *)control {
    
    [self fetchLatestEntries:(control == nil) withCompletion:^{
        
        [control endRefreshing];
    }];
}


#pragma mark - Misc

- (void)showRequestError {
    
    NSString *message = @"We're having trouble refreshing the feed. It's not you, it's us.";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Video Issue"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault 
                                                   handler:NULL];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -


@end
