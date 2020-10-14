//
//  HQLTabBarController.h
//  PersonalCenterDemo
//
//  Created by Qilin Hu on 2019/10/23.
//  Copyright © 2019 Tonintech. All rights reserved.
//

#import "CYLTabBarController.h"

NS_ASSUME_NONNULL_BEGIN

/**
 该标签页视图控制器是 CYLTabBarController 的子类对象。
 
 在此基类中集成 EAIntroView 框架，实现显示启动引导页功能。
 
 该对象中使用的两个框架：
 1. [CYLTabBarController](https://github.com/ChenYilong/CYLTabBarController) 自定义 TabBar
 2. [EAIntroView](https://github.com/ealeksandrov/EAIntroView) 显示启动引导页
 */
@interface HQLTabBarController : CYLTabBarController

@end

NS_ASSUME_NONNULL_END
