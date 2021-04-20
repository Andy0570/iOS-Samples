//
//  HQLCoordinatorViewController.m
//  FloatingTabBarDemo_V2
//
//  Created by Qilin Hu on 2020/9/1.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLCoordinatorViewController.h"
#import "HQLCoordinatorViewController+EAIntroView.h"

// Framework
#import <POP.h>
#import <YYKit.h>

// Controller
#import "HQLBaseNavigationController.h"
#import "MainViewController.h"
#import "SecondViewController.h"

// Manager
#import "HQLFloatingTabBarManager.h"

@interface HQLCoordinatorViewController () <UINavigationControllerDelegate, HQLFloatingTabBarManagerDelegate>
@property (nonatomic, strong) HQLBaseNavigationController *mainNavigationViewController;
@property (nonatomic, strong) HQLBaseNavigationController *secondNavigationViewController;
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

// MARK: 将 HQLFloatingTabBar 添加到根视图控制器上
- (void)addFloatingTabBar {
    HQLFloatingTabBarManager *manager = [HQLFloatingTabBarManager sharedFloatingTabBarManager];
    manager.delegate = self;
    [manager createFloatingTabBar];
    [manager showFloatingTabBar];
    
    manager.publishButtonActionBlock = ^{
        // TODO: 发布功能
    };
}

/**
 视图控制器层级架构

 HQLCoordinatorViewController - HQLBaseNavigationController - MainViewController   // 首页
                              - HQLBaseNavigationController - SecondViewController // 次页
*/
- (void)setupViewControllers {
    MainViewController *mainVC = [[MainViewController alloc] init];
    self.mainNavigationViewController = [[HQLBaseNavigationController alloc] initWithRootViewController:mainVC];
    self.mainNavigationViewController.delegate = self;
    
    SecondViewController *secondVC = [[SecondViewController alloc] init];
    self.secondNavigationViewController = [[HQLBaseNavigationController alloc] initWithRootViewController:secondVC];
    self.secondNavigationViewController.delegate = self;
    
    [self displayContentController:self.mainNavigationViewController];
}

/// 显示被包含的视图控制器
/// @param content 要显示的视图控制器
- (void)displayContentController:(UIViewController *)content {
    [self addChildViewController:content];
    content.view.frame = self.view.bounds;
    [self.view addSubview:content.view];
    [content didMoveToParentViewController:self];
}

/// 隐藏被包含的视图控制器
/// @param content 要隐藏的视图控制器
- (void)hideContentController:(UIViewController *)content {
    [content willMoveToParentViewController:nil];
    [content.view removeFromSuperview];
    [content removeFromParentViewController];
}

/// 切换视图控制器，从当前视图控制器页面切换到要显示的视图控制器页面
/// @param fromViewController 当前视图控制器
/// @param toViewController 要显示的视图控制器
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
        [self performTransitionFromViewController:self.secondNavigationViewController
                                 toViewController:self.mainNavigationViewController];
    } else {
        if (self.childViewControllers.firstObject == self.secondNavigationViewController) {
            return;
        }
        [self performTransitionFromViewController:self.mainNavigationViewController
                                 toViewController:self.secondNavigationViewController];
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
