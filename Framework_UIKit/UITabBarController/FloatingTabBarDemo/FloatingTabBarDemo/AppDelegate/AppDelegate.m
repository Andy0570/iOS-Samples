//
//  AppDelegate.m
//  FloatingTabBarDemo
//
//  Created by Qilin Hu on 2020/8/11.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "HQLBaseTabBarController.h"
#import "HQLFloatingTabBarManager.h"

@interface AppDelegate () <HQLFloatingTabBarManagerDelegate>

@property (nonatomic, strong) HQLBaseTabBarController *tabBarController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.tabBarController = [[HQLBaseTabBarController alloc] init];
    // !!!: 因为要显示自定义的浮动 TabBar，所以这里始终隐藏 UITabBarController 的默认 tabBar。
    self.tabBarController.tabBar.hidden = YES;
    self.window.rootViewController = self.tabBarController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self addFloatingTabBar];
    return YES;
}


- (void)addFloatingTabBar {
    HQLFloatingTabBarManager *manager = [HQLFloatingTabBarManager sharedFloatingTabBarManager];
    manager.delegate = self;
    [manager createFloatingTabBar];
    [manager displayFloatingTabBar];
    
    manager.publishButtonActionBlock = ^{
        NSLog(@"%s",__PRETTY_FUNCTION__);
    };
}

#pragma mark - <HQLFloatingTabBarManagerDelegate>

// 点击自定义浮动 TabBar 上的按钮时，根据索引选中 UITabBarController 中的 tabBar index
- (void)selectBarButtonAtIndex:(NSUInteger)index {
    self.tabBarController.selectedIndex = index;
}


@end
