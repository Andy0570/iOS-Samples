//
//  HQLNavigationController.m
//  HQLRiseTabBarDemo
//
//  Created by Qilin Hu on 2019/10/14.
//  Copyright © 2019 Tonintech. All rights reserved.
//

#import "HQLNavigationController.h"

@interface HQLNavigationController ()

@end

@implementation HQLNavigationController

#pragma mark - Controller life cycle

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (!self) { return nil; }
    
    // 设置根视图的背景颜色和大小
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    return self;
}

#pragma mark - Public

- (void)removeUnderline {
    [self.navigationBar setShadowImage:[UIImage new]];
}

#pragma mark - Override

// 执行此方法时，统一设置下一个视图控制器的返回按钮
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 第一个控制器的左 button 不确定，其他控制器的左 button 为特定样式
    if (self.viewControllers.count > 0) {
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
        viewController.navigationItem.backBarButtonItem = backBarButtonItem;
        // 推入下一个视图控制器时，隐藏底部的 TabBar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

@end
