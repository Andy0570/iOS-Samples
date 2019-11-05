//
//  AppDelegate.h
//  1.1 Quiz
//
//  Created by ToninTech on 16/8/11.
//  Copyright © 2016年 ToninTech. All rights reserved.
//


#import <UIKit/UIKit.h>

/**
 【控制器对象】
 
 AppDelegate 应用程序委托，是每一个iOS应用都必须具备的启动入口。
 应用程序委托负责管理应用的 UIWindow 对象。
 UIWindow 对象表示应用唯一的主窗口。
 */
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

