//
//  AAPLCrossDissolveFirstViewController.m
//  UIPresentationController
//
//  Created by Qilin Hu on 2020/7/3.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "AAPLCrossDissolveFirstViewController.h"
#import "AAPLCrossDissolveTransitionAnimator.h"

@interface AAPLCrossDissolveFirstViewController () <UIViewControllerTransitioningDelegate>

@end

@implementation AAPLCrossDissolveFirstViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Actions

- (IBAction)presentWithCustomTransitionAction:(id)sender {
    UIViewController *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SecondViewController"];
    
    secondViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    // transitioning 代理可以实现视图控制器之间切换的动画视图
    secondViewController.transitioningDelegate = self;
    
    [self presentViewController:secondViewController animated:YES completion:NULL];
}

#pragma mark -
#pragma mark UIViewControllerTransitioningDelegate

//| ----------------------------------------------------------------------------
//  The system calls this method on the presented view controller's
//  transitioningDelegate to retrieve the animator object used for animating
//  the presentation of the incoming view controller.  Your implementation is
//  expected to return an object that conforms to the
//  UIViewControllerAnimatedTransitioning protocol, or nil if the default
//  presentation animation should be used.
//
//  !!!: 返回 presentation 动画的实现对象
//  系统会在 presented view controller 的 transitioningDelegate 协议中检索用于呈现视图控制器动画的动画器。
//  你应该返回一个遵守 UIViewControllerAnimatedTransitioning 协议的对象，
//  如果你想要使用默认的动画，那么返回 nil
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [AAPLCrossDissolveTransitionAnimator new];
}


//| ----------------------------------------------------------------------------
//  The system calls this method on the presented view controller's
//  transitioningDelegate to retrieve the animator object used for animating
//  the dismissal of the presented view controller.  Your implementation is
//  expected to return an object that conforms to the
//  UIViewControllerAnimatedTransitioning protocol, or nil if the default
//  dismissal animation should be used.
//
//  !!!: 返回 dismissal 动画的实现对象
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [AAPLCrossDissolveTransitionAnimator new];
}


@end
