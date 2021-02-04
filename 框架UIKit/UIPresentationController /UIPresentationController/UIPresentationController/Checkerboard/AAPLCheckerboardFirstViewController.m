//
//  AAPLCheckerboardFirstViewController.m
//  UIPresentationController
//
//  Created by Qilin Hu on 2020/7/3.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "AAPLCheckerboardFirstViewController.h"
#import "AAPLCheckerboardTransitionAnimator.h"

@interface AAPLCheckerboardFirstViewController () <UINavigationControllerDelegate>

@end

@implementation AAPLCheckerboardFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
}

#pragma mark -
#pragma mark UINavigationControllerDelegate

//| ----------------------------------------------------------------------------
//  The navigation controller tries to invoke this method on its delegate to
//  retrieve an animator object to be used for animating the transition to the
//  incoming view controller.  Your implementation is expected to return an
//  object that conforms to the UIViewControllerAnimatedTransitioning protocol,
//  or nil if the transition should use the navigation controller's default
//  push/pop animation.
//
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    return [AAPLCheckerboardTransitionAnimator new];
}

@end
