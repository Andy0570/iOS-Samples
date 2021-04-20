//
//  HQLCoordinatorViewController.h
//  SeaTao
//
//  Created by Qilin Hu on 2020/8/21.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 根容器视图控制器
 
 功能特性：
 1. 在该页面中初始化各业务模块的视图控制器；
 2. 集成 EAIntroView 框架，显示启动引导页；
 
 FIXME: 跳转到「我的」页面后，通过全屏手势返回到一半，会显示浮动 TabBar 的 Bug！
 */
@interface HQLCoordinatorViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
