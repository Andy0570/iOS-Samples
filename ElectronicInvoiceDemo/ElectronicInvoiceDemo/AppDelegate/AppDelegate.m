//
//  AppDelegate.m
//  ElectronicInvoiceDemo
//
//  Created by Qilin Hu on 2018/1/18.
//  Copyright © 2018年 Qilin Hu. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self hql_configureForIQKeyboard];
    [self hql_configureForChameleon];
    
    return YES;
}

// 配置 IQKeyboardManager
- (void)hql_configureForIQKeyboard {
    // 添加手势，点击屏幕其他区域自动收起键盘
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    // 添加键盘工具栏
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].shouldShowToolbarPlaceholder = NO;
}

- (void)hql_configureForChameleon {
    
    /**
     UIContentStyleLight - 导航栏白色字体、状态栏黑色字体
     UIContentStyleDark  - 导航栏黑色字体、状态栏黑色字体
     UIContentStyleContrast - 导航栏黑色字体、状态栏黑色字体
     */
    
    // 通过 Chameleon 设置全局主题色，全局导航栏按钮样式为白色
//    [Chameleon setGlobalThemeUsingPrimaryColor:HexColor(@"#47c1b6")
//                            withSecondaryColor:[UIColor clearColor]
//                               andContentStyle:UIContentStyleContrast];
    
    /**
     如果只设置一种主题色，页面中的某个按钮元素也会是主题色。
     如果 SecondaryColor 设置成白色，那么某些按钮会是白块。
     如果 SecondaryColor 设置成透明色，work！
     */
//    [Chameleon setGlobalThemeUsingPrimaryColor:HexColor(@"#47c1b6")
//                              withContentStyle:UIContentStyleContrast];

}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
