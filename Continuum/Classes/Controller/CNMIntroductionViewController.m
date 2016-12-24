/**
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
#import "CNMIntroductionViewController.h"
#import "CNMPageControl.h"


#pragma mark Private interface declaration

@interface CNMIntroductionViewController () <UIScrollViewDelegate>


#pragma mark - Properties

/**
 @brief  Stores reference on controller which is used to show how far user scrolled from the start.
 */
@property (nonatomic, weak) IBOutlet CNMPageControl *pageControl;

#pragma mark -


@end


#pragma mark - Interface implementation

@implementation CNMIntroductionViewController


#pragma mark - Controller life-cycle methods

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return UIInterfaceOrientationPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}


#pragma mark - UIScrollView handler

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    self.pageControl.currentPage = (scrollView.contentOffset.x / scrollView.frame.size.width);
}

#pragma mark -

@end
