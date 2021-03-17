//
//  CustomVCTransitionViewController.m
//  POPDemo
//
//  Created by Qilin Hu on 2020/5/9.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "CustomVCTransitionViewController.h"

// Frameworks
#import <POP.h>

// Controllers
#import "DismissingAnimationController.h"
#import "PresentingAnimationController.h"
#import "CustomModalViewController.h"

@interface CustomVCTransitionViewController () <UIViewControllerTransitioningDelegate>

@end

@implementation CustomVCTransitionViewController


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - Actions

- (IBAction)didClickOnPresent:(id)sender {
    CustomModalViewController *modalVC = [self.storyboard instantiateViewControllerWithIdentifier:@"customModal"];
    
    // 设置当前视图控制器实现「转场过渡动画」
    modalVC.transitioningDelegate = self;
    modalVC.modalPresentationStyle = UIModalPresentationCustom;
    
    [self.navigationController presentViewController:modalVC animated:YES completion:nil];
}


#pragma mark - UIViewControllerTransitionDelegate

// 用于展现 modal view controller 的转场动画
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[PresentingAnimationController alloc] init];
}

// 页面消失的动画
 - (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[DismissingAnimationController alloc] init];
}

@end
