//
//  AppDelegate+CYLTabBar.h
//  PersonalCenterDemo
//
//  Created by Qilin Hu on 2019/10/23.
//  Copyright © 2019 Tonintech. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

/**
 集成 CYLTabBarController 框架
 
 GitHub 地址: <https://github.com/ChenYilong/CYLTabBarController>
 */
@interface AppDelegate (CYLTabBar)

- (void)hql_configureForTabBarController;

@end

NS_ASSUME_NONNULL_END
