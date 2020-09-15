//
//  HQLBaseNavigationController.h
//  UINavigationControllerDemo
//
//  Created by Qilin Hu on 2020/9/14.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 导航视图控制器基类
 
 1. 统一设置导航栏返回按钮为：< 返回
 2. 推入下一个视图控制器时，隐藏 TabBar 标签栏；
 3. 让各个视图控制器各自设置状态栏样式，通过 preferredStatusBarStyle 方法设置；
 4. 原生方式实现，删除导航栏底部线条
 */
@interface HQLBaseNavigationController : UINavigationController

@end

NS_ASSUME_NONNULL_END
