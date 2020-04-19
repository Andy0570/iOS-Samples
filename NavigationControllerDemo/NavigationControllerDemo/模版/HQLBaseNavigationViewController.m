//
//  HQLBaseNavigationViewController.m
//  NavigationControllerDemo
//
//  Created by Qilin Hu on 2020/4/16.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLBaseNavigationViewController.h"

@interface HQLBaseNavigationViewController ()

@end

@implementation HQLBaseNavigationViewController


/*
 删除导航栏底部线条
 
 推荐替代方法：位于 ChameleonDemo：该方法会把所有页面的底部线条删除
 self.navigationController.hidesNavigationBarHairline = YES;
 */
- (void)removeUnderline {
    [self.navigationBar setShadowImage:[UIImage new]];
}

// 执行此方法时，统一设置下一个视图控制器的返回按钮
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 第一个 controller 左 button 不确定, 其他 controller 左 button 为特定样式
    if (self.viewControllers.count > 0) {
        // 自定义导航栏返回按钮文字，统一设置为“返回”，默认是上一个视图控制器的标题
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
        viewController.navigationItem.backBarButtonItem = backBarButtonItem;
        // 推入下一个视图控制器时，隐藏 TabBar 标签栏
        viewController.hidesBottomBarWhenPushed = YES;
    } else {
        viewController.hidesBottomBarWhenPushed = NO;
    }
    [super pushViewController:viewController animated:animated];
}

@end
