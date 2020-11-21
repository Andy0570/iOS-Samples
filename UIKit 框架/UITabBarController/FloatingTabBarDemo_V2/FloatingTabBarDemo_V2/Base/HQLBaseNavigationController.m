//
//  HQLBaseNavigationController.m
//  SeaTao
//
//  Created by Qilin Hu on 2020/4/27.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLBaseNavigationController.h"

@implementation HQLBaseNavigationController

#pragma mark - Override

/// 让各个视图控制器各自设置状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    UIViewController *topVC = self.topViewController;
    return [topVC preferredStatusBarStyle];
}

/// 执行此方法时，统一设置下一个视图控制器的返回按钮
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // 自定义导航栏返回按钮
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
    viewController.navigationItem.backBarButtonItem = backBarButtonItem;
        
    [super pushViewController:viewController animated:animated];
}

@end
