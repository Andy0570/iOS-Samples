//
//  UIViewController+Extension.h
//  XuZhouSS
//
//  Created by Qilin Hu on 2017/6/22.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Extension)

/**
 设置导航栏返回按钮
 */
- (void)setNavigationBarBackButton;

/**
 设置导航栏返回按钮+关闭按钮
 
 使用场景：视图控制器导航堆栈最后一项
 */
- (void)setNavigationBarBackButtonAndCloseButton;

@end
