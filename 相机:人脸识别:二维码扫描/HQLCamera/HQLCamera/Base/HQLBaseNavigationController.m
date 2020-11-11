//
//  HQLBaseNavigationController.m
//  iOS Project
//
//  Created by Qilin Hu on 2020/9/14.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLBaseNavigationController.h"

@implementation HQLBaseNavigationController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 将返回按钮的标题向左偏移 100 pt，以隐藏返回按钮上的文字
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-100, 0) forBarMetrics:UIBarMetricsDefault];
}

/*
 删除导航栏底部线条
 
 推荐替代方法：位于 ChameleonDemo：该方法会把所有页面的底部线条删除
 self.navigationController.hidesNavigationBarHairline = YES;
 */
- (void)removeUnderline {
    [self.navigationBar setShadowImage:[UIImage new]];
}

#pragma mark - Override

/// 让各个视图控制器各自设置状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    UIViewController *topViewController = self.topViewController;
    return [topViewController preferredStatusBarStyle];
}

/**
 执行此方法时，统一设置下一个视图控制器的返回按钮
 
 方法原理：
  * 通过判断导航视图控制器的 viewControllers 数组中包含的视图控制器的数量进行设置。
  * 只有导航视图控制器的根视图控制器（rootViewController）不隐藏 TabBar 标签页。
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // 自定义导航栏返回按钮文字，统一设置为“返回”，默认是上一个视图控制器的标题
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
    viewController.navigationItem.backBarButtonItem = backBarButtonItem;
    
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    } else {
        viewController.hidesBottomBarWhenPushed = NO;
    }
    
    [super pushViewController:viewController animated:animated];
}

@end
