/*
 //  CYLTabBarController
 //  CYLTabBarController
 //
 //  Created by 微博@iOS程序犭袁 ( http://weibo.com/luohanchenyilong/ ) on 03/06/19.
 //  Copyright © 2019 https://github.com/ChenYilong . All rights reserved.
 */

#import "CYLBaseNavigationController.h"

@interface CYLBaseNavigationController ()

@end

@implementation CYLBaseNavigationController

/**
 功能：只有首页才不隐藏底部的 TabBar 标签页，进入下一个页面就自动隐藏标签页。
 
 应用的视图层次结构：
 UITabBarController - UINavigationController - UIViewController(首页)
                                             - ...
                    - UINavigationController - UIViewController(资讯)
                                             - ...
                    - UINavigationController - UIViewController(消息)
                                             - ...
                    - UINavigationController - UIViewController(我的)
                                             - ...
 
 方法原理：
  * 通过判断导航视图控制器的 viewControllers 数组中包含的视图控制器的数量进行设置。
  * 只有导航视图控制器的根视图控制器（rootViewController）不隐藏 TabBar 标签页。
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    } else {
        viewController.hidesBottomBarWhenPushed = NO;
    }
    [super pushViewController:viewController animated:animated];
}

@end
