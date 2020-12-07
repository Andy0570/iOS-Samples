//
//  AppDelegate+CYLTabBar.h
//  CYLTabBarControllerDemo
//
//  Created by Qilin Hu on 2019/10/17.
//  Copyright © 2019 Tonintech. All rights reserved.
//


#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

/// 这是 AppDelegate 的分类，用于配置 CYLTabBarController
@interface AppDelegate (CYLTabBar)

/// 配置主窗口
- (void)hql_configureForTabBarController;

@end

NS_ASSUME_NONNULL_END
