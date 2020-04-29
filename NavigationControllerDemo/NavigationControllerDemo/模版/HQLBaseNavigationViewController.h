//
//  HQLBaseNavigationViewController.h
//  NavigationControllerDemo
//
//  Created by Qilin Hu on 2020/4/16.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 UINavigationController 导航视图控制器基类
 
 1. 系统原生实现，统一设置导航栏返回按钮为文字：返回
 2. 推入下一个视图控制器时，隐藏 TabBar 标签栏
 2. 原生方式实现，删除导航栏底部线条
 */
@interface HQLBaseNavigationViewController : UINavigationController

@end

NS_ASSUME_NONNULL_END
