//
//  DCNavigationController.m
//  CDDMall
//
//  Created by apple on 2017/5/26.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCNavigationController.h"

@implementation DCNavigationController

+ (void)load {
    // 设置导航栏
    UINavigationBar *bar = [UINavigationBar appearance];
    // 设置导航栏背景颜色
    bar.barTintColor = [UIColor whiteColor];
    // 设置导航栏 item 项颜色
    bar.tintColor = [UIColor darkGrayColor];
    // 设置导航栏背景是否透明
    bar.translucent = YES;
    [bar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    // 导航栏字体：18号黑色字体
    [bar setTitleTextAttributes:@{
        NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
        NSForegroundColorAttributeName: [UIColor blackColor],
    }];
}

#pragma mark - IBActions

// 点击导航栏返回按钮
- (void)backButtonTapClick {
    [self popViewControllerAnimated:YES];
}

#pragma mark - UINavigationControllerDelegate

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.childViewControllers.count >= 1) {
        
        // 统一自定义导航栏返回按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 33, 33);
        
        // 图片尺寸 22*22
        [button setImage:[UIImage imageNamed:@"navBar_back_normal"]
                forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"navBar_back_highlight"]
                forState:UIControlStateHighlighted];
        
        if (@available(ios 11.0,*)) {
            // 按钮向左移动 15 point
            button.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
            // 图片向左移动 10 point
            button.imageEdgeInsets = UIEdgeInsetsMake(0, -10 ,0, 0);
        }
        
        [button addTarget:self
                   action:@selector(backButtonTapClick)
         forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        viewController.navigationItem.leftBarButtonItems = @[backButton];
        
        // 推入下一个视图控制器时，隐藏 TabBar 标签栏
        viewController.hidesBottomBarWhenPushed = YES;
        // 自定义返回按钮后，需要修复滑动返回功能
        self.interactivePopGestureRecognizer.delegate = nil;
    }
    
    // 跳转
    [super pushViewController:viewController animated:animated];
}

@end
