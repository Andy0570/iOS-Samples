//
//  AppDelegate.m
//  UINavigationControllerDemo
//
//  Created by Qilin Hu on 2020/9/14.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "HQLBaseTabBarController.h"

// Frameworks
#import <Chameleon.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    HQLBaseTabBarController *tabBarController = [[HQLBaseTabBarController alloc] init];
    self.window.rootViewController = tabBarController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // !!!: 通过 Chameleon 设置全局主题色，全局导航栏按钮样式为白色
    [Chameleon setGlobalThemeUsingPrimaryColor:HexColor(@"#47c1b6")
                            withSecondaryColor:[UIColor whiteColor]
                               andContentStyle:UIContentStyleLight];
    
    return YES;
}

@end
