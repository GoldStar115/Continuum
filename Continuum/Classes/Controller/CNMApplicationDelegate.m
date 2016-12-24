#import "CNMApplicationDelegate.h"
#import <MessageUI/MessageUI.h>
#import "CNMVideoFeedManager.h"
#import "Mixpanel.h"


#pragma mark Static

/**
 @brief  Stores reference on tracking ientifier which is used by MixPanel.
 */
static NSString * const kCNMMixPanelToken = @"de020e9b125f767e365459f4d2865781";


#pragma mark - Private interface declaration

@interface CNMApplicationDelegate () <UITabBarControllerDelegate, MFMailComposeViewControllerDelegate>

/**
 @brief  Stores reference on manager which provide access to the video feed.
 */
@property (nonatomic) CNMVideoFeedManager *manager;


#pragma mark - Flow customization

/**
 @brief  Complete user interface customization.
 */
- (void)prepareInterface;

/**
 @brief  Allow to define required view controller which should be shown.
 
 @return Basing on whether application launched for first time after installation or not intro screen can be 
         shown or main application interface.
 */
- (UIViewController *)rootViewController;

/**
 @brief  Show user for email composition.
 */
- (void)showEmailComposerController;

/**
 @brief  Notify user what email can't be sent from his device.
 */
- (void)showInabilityToSendEmail;


#pragma mark - Misc

/**
 @brief  Configure tracking toolchain.
 */
- (void)setupTrackingTools;

/**
 @brief  Perform required setups to receive Apple's push notifications.
 */
- (void)setupPushNotifications;

#pragma mark -


@end


#pragma mark - Interface implementation

@implementation CNMApplicationDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Setup tracking tools.
    [self setupTrackingTools];
    
    // Prepare user interface.
    [self prepareInterface];
    
    // Setup push notifications.
    [self setupPushNotifications];
     
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
#if !TARGET_IPHONE_SIMULATOR    
    [[Mixpanel sharedInstance].people addPushDeviceToken:deviceToken];
#endif
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"Registration failed with error: %@", error);
}


#pragma mark - Flow customization

- (void)prepareInterface {
    
    // Configure base appearance.
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setItemWidth:25.0f];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tab-button-glow"]];
    
    // Present target screen to the user.
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = [self rootViewController];
    if ([self.window.rootViewController isKindOfClass:UITabBarController.class]) {
        
        ((UITabBarController *)self.window.rootViewController).delegate = self;
    }
    [self.window makeKeyAndVisible];
}

- (UIViewController *)rootViewController {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NSString *controllerID = @"CNMMainViewController";
    if (![defaults boolForKey:NSStringFromSelector(_cmd)]) {
        
        controllerID = @"CNMIntroViewController";
        [defaults setBool:YES forKey:NSStringFromSelector(_cmd)];
        [defaults synchronize];
        
        // Track application installation.
#if !TARGET_IPHONE_SIMULATOR
        [[Mixpanel sharedInstance] track:@"Install"];
#endif
    }
    else {
        
        // Track application installation.
#if !TARGET_IPHONE_SIMULATOR
        [[Mixpanel sharedInstance] track:@"Open"];
#endif
    }
    
    return [storyboard instantiateViewControllerWithIdentifier:controllerID];
}

- (void)showEmailComposerController {
    
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *composerController = [MFMailComposeViewController new];
        composerController.mailComposeDelegate = self;
        [composerController setSubject:@"I have a great idea to share with the world..."];
        [composerController setToRecipients:@[@"submissions@makemecontinuum.com"]];
        [composerController setMessageBody:@"Please upload your video to the service of your choice (YouTube, Vimeo, etc.) and provide us the following information. \nYour name:\nVideo title:\nVideo description:\nVideo link:\n\nIf your video is private, please provide a password to access it." isHTML:NO];
        [self.window.rootViewController presentViewController:composerController animated:YES completion:nil];
    }
    else { [self showInabilityToSendEmail]; }
}

- (void)showInabilityToSendEmail {
    
    NSString *message = @"It looks like you don't have a mail client configured. If you want to submit a video, please contact us at submissions@makemecontinuum.com";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Email Client Issue"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault 
                                                   handler:NULL];
    [alert addAction:action];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}


#pragma mark - Misc

- (void)setupTrackingTools {

#if !TARGET_IPHONE_SIMULATOR
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSMutableString *identity = [infoDictionary[@"CFBundleName"] mutableCopy];
    [identity appendFormat:@"-%@", infoDictionary[@"CFBundleShortVersionString"]];
    [Mixpanel sharedInstanceWithToken:kCNMMixPanelToken];
    Mixpanel *mixPanel = [Mixpanel sharedInstance];
    [mixPanel identify:mixPanel.distinctId];
    [mixPanel.people set:@"first_name" to:identity];
#endif
}

- (void)setupPushNotifications {
    
    UIUserNotificationType types = (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | 
                                    UIUserNotificationTypeAlert);
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}


#pragma mark - UITabBarController delegate methods

- (BOOL)    tabBarController:(UITabBarController *)tabBarController 
  shouldSelectViewController:(UIViewController *)viewController {
    
    BOOL shouldSelectViewController = YES;
    if ([tabBarController.viewControllers indexOfObject:viewController] == 1) {
        
        shouldSelectViewController = NO;
        [self showEmailComposerController];
    }
    
    return shouldSelectViewController;
}


#pragma mark - Message composer delegate methods

- (void)mailComposeController:(MFMailComposeViewController *)controller 
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -


@end
