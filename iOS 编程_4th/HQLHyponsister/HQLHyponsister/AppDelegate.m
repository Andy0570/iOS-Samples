//
//  AppDelegate.m
//  HQLHyponsister
//
//  Created by ToninTech on 16/8/15.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "AppDelegate.h"
#import "myViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //初始化窗口
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //设置根视图控制器
    myViewController *mvc = [[myViewController alloc] init];
    self.window.rootViewController = mvc;
    
    //设置窗口背景色
    self.window.backgroundColor = [UIColor whiteColor];
    
    //使窗口可见
    [self.window makeKeyAndVisible];
    
    //设置启动页面延时
    [NSThread sleepForTimeInterval:1.0];
    
    return YES;
}

@end
