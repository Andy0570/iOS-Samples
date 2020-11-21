//
//  HQLBaseNavigationController.h
//  SeaTao
//
//  Created by Qilin Hu on 2020/4/27.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 此导航视图控制器是 UINavigationController 的基类。

 功能特性：
 1. 全局设置导航栏返回按钮为向左箭头 <
 2. 推入下一个视图控制器时，自动隐藏底部 TabBar 标签栏；
 3. 让各个视图控制器各自设置状态栏样式，通过 preferredStatusBarStyle 方法设置；
 */
@interface HQLBaseNavigationController : UINavigationController

@end

NS_ASSUME_NONNULL_END
