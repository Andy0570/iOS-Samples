//
//  AppDelegate.h
//  HQLTableViewDemo
//
//  Created by ToninTech on 2016/12/20.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 TableView 学习 Demo
 */
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (copy) void (^backgroundURLSessionCompletionHandler)(void);

@end

