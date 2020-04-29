//
//  AppDelegate.h
//  HQLHyponsister
//
//  Created by ToninTech on 16/8/15.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

/*
 任何一个应用都有且只有一个 UIWindow 对象。
 UIWindow 对象就像一个容器，负责包含应用中的所有视图。
 应用需要在启动时创建并设置 UIWindow 对象，然后为其添加其他视图。
 */
@property (strong, nonatomic) UIWindow *window;

@end

