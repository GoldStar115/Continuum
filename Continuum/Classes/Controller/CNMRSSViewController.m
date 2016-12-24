/**
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
#import "CNMRSSViewController.h"


#pragma mark Private interface declaration

@interface CNMRSSViewController () <UIWebViewDelegate>


#pragma mark - Properties

/**
 @brief  Stores reference on view which will be used to represent web-page.
 */
@property (nonatomic, weak) IBOutlet UIWebView *webView;

/**
 @brief  Stores reference on page loader elements.
 */
@property (nonatomic, weak) IBOutlet UIView *pageLoaderView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *progressView;

/**
 @brief  Stores reference on URL which should be presented in web-view.
 */
@property (nonatomic, copy) IBInspectable NSString *url;


#pragma mark - Interface customization

/**
 @brief  Complete view controller layout configuration.
 */
- (void)prepareLayout;


#pragma mark - Misc

/**
 @brief  Ask web-view to load page from passed \c url.
 
 @param url Reference on URL of page which should be loaded by web-view.
 */
- (void)showPageWithURL:(NSURL *)url;

#pragma mark -


@end


#pragma mark - Interface implementation

@implementation CNMRSSViewController


#pragma mark - Controller life-cycle methods

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return UIInterfaceOrientationPortrait;
}

- (BOOL)prefersStatusBarHidden {
    
    return YES;
}

- (void)viewDidLoad {
    
    // Forward method call to the super class.
    [super viewDidLoad];
    
    [self prepareLayout];
    [self showPageWithURL:[NSURL URLWithString:self.url]];
}


#pragma mark - Interface customization

- (void)prepareLayout {
    
//    self.webView.hidden = YES;
    [self.progressView startAnimating];
    self.pageLoaderView.alpha = 1.0f;
}


#pragma mark - WebView delegate methods

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    webView.hidden = NO;
    [UIView animateWithDuration:0.3f animations:^{ self.pageLoaderView.alpha = 0.0f; }
                     completion:^(BOOL finished) { [self.progressView stopAnimating]; }];
}


#pragma mark - Misc

- (void)showPageWithURL:(NSURL *)url {
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

#pragma mark - 


@end
