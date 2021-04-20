//
//  HQLCoordinatorViewController.m
//  SeaTao
//
//  Created by Qilin Hu on 2020/8/21.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLCoordinatorViewController.h"
#import "HQLCoordinatorViewController+EAIntroView.h"

// Framework
#import <POP.h>

// Controller
#import "HQLBaseNavigationController.h"
#import "HQLMainViewController.h"
#import "HQLStrollViewController.h"
#import "HQLPublishFormViewController.h"

// Manager
#import "HQLFloatingTabBarManager.h"

@interface HQLCoordinatorViewController () <UINavigationControllerDelegate, HQLFloatingTabBarManagerDelegate>

@property (nonatomic, strong) HQLBaseNavigationController *mainNavigationViewController;
@property (nonatomic, strong) HQLBaseNavigationController *strollNavigationViewController;

@end

@implementation HQLCoordinatorViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupViewControllers];
    [self addFloatingTabBar];
    [self hql_showIntroWithCrossDissolve];
}

#pragma mark - Private

- (void)addFloatingTabBar {
    HQLFloatingTabBarManager *manager = [HQLFloatingTabBarManager sharedFloatingTabBarManager];
    manager.delegate = self;
    [manager createFloatingTabBar];
    [manager showFloatingTabBar];
    
    __weak __typeof(self)weakSelf = self;
    manager.publishButtonActionBlock = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        // MARK: 弹出发布页面
        HQLPublishFormViewController *publishFormVC = [[HQLPublishFormViewController alloc] init];
        HQLBaseNavigationController *baseNavController = [[HQLBaseNavigationController alloc] initWithRootViewController:publishFormVC];
        baseNavController.modalPresentationStyle = UIModalPresentationFullScreen;
        [strongSelf presentViewController:baseNavController animated:YES completion:NULL];
    };
}

/**
视图控制器层级架构

HQLCoordinatorViewController - HQLBaseNavigationController - HQLMainViewController  // 首页
                             - HQLBaseNavigationController - HQLStrollViewController // 去逛街
*/
- (void)setupViewControllers {
    HQLMainViewController *mainVC = [[HQLMainViewController alloc] init];
    self.mainNavigationViewController = [[HQLBaseNavigationController alloc] initWithRootViewController:mainVC];
    self.mainNavigationViewController.delegate = self;
    
    HQLStrollViewController *strollVC = [[HQLStrollViewController alloc] init];
    self.strollNavigationViewController = [[HQLBaseNavigationController alloc] initWithRootViewController:strollVC];
    self.strollNavigationViewController.delegate = self;
    
    [self displayContentController:self.mainNavigationViewController];
}

- (void)displayContentController:(UIViewController *)content {
    [self addChildViewController:content];
    content.view.frame = self.view.bounds;
    [self.view addSubview:content.view];
    [content didMoveToParentViewController:self];
}

- (void)hideContentController:(UIViewController *)content {
    [content willMoveToParentViewController:nil];
    [content.view removeFromSuperview];
    [content removeFromParentViewController];
}

- (void) performTransitionFromViewController:(UIViewController*)fromViewController toViewController:(UIViewController*)toViewController {
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];

    UIView *toView = toViewController.view;
    UIView *fromView = fromViewController.view;
    [self.view addSubview:toView];

    POPBasicAnimation *fromViewAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    fromViewAnimation.duration = 0.25;
    
    POPBasicAnimation *toViewAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    toViewAnimation.duration = 0.25;
    
    if (fromViewController == self.mainNavigationViewController) {
        fromViewAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(-kScreenWidth, 0, kScreenWidth, kScreenHeight)];

        toViewAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight)];
        toViewAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    } else {
        fromViewAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight)];
        
        toViewAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(-kScreenWidth, 0, kScreenWidth, kScreenHeight)];
        toViewAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    
    fromViewAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        [fromView removeFromSuperview];
        [fromViewController removeFromParentViewController];
    };
    [fromView pop_addAnimation:fromViewAnimation forKey:@"FromView_POPViewFrame"];
    
    toViewAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        [toViewController didMoveToParentViewController:self];
    };
    [toView pop_addAnimation:toViewAnimation forKey:@"ToView_POPViewFrame"];
}

#pragma mark - <HQLFloatingTabBarManagerDelegate>

- (void)selectBarButtonAtIndex:(NSUInteger)index {
    if (index == 0) {
        if (self.childViewControllers.firstObject == self.mainNavigationViewController) {
            return;
        }
        [self performTransitionFromViewController:self.strollNavigationViewController
                                 toViewController:self.mainNavigationViewController];
    } else {
        if (self.childViewControllers.firstObject == self.strollNavigationViewController) {
            return;
        }
        [self performTransitionFromViewController:self.mainNavigationViewController
                                 toViewController:self.strollNavigationViewController];
    }
}

#pragma mark - <UINavigationControllerDelegate>

//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    if (navigationController.viewControllers.count == 1) {
//        [[HQLFloatingTabBarManager sharedFloatingTabBarManager] showFloatingTabBar];
//    } else {
//        [[HQLFloatingTabBarManager sharedFloatingTabBarManager] hideFloatingTabBar];
//    }
//}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (navigationController.viewControllers.count == 1) {
        [[HQLFloatingTabBarManager sharedFloatingTabBarManager] showFloatingTabBar];
    } else {
        [[HQLFloatingTabBarManager sharedFloatingTabBarManager] hideFloatingTabBar];
    }
}

@end
