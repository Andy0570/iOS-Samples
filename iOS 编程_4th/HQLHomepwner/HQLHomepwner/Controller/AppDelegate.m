//
//  AppDelegate.m
//  HQLHomepwner
//
//  Created by ToninTech on 16/8/30.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "AppDelegate.h"
#import "HQLItemsViewController.h"
#import "HQLItemStore.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - 启用状态恢复

- (nullable UIViewController *) application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder {
    
    // 创建一个新的 UINavigationController 对象
    UIViewController *vc = [[UINavigationController alloc] init];
    // 恢复标识路径中的最后一个对象就是 UINavigationController 对象的恢复标识
    vc.restorationIdentifier = [identifierComponents lastObject];
    // 如果恢复标识路径中只有一个对象
    // 就将 UINavigationController 对象设置为 UIWindow 的 rootViewController
    if ([identifierComponents count] ==1) {
        self.window.rootViewController = vc;
    }
    return vc;
}

- (BOOL) application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder {
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder {
    return YES;
}



// 系统恢复应用状态之前调用
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 如果应用没有触发状态恢复，就创建并设置各个视图控制器
    if (!self.window.rootViewController) {
        // 创建 HQLItemsViewController 对象
        HQLItemsViewController *itemsViewController = [[HQLItemsViewController alloc] init];
        // 创建 UINavigationController 对象
        // 将 HQLItemsViewController 对象设置为 UINavigationController 对象的根视图控制器
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:itemsViewController];
        // 将 UINavigationController 对象的类名设置为恢复标识
        navigationController.restorationIdentifier =
        NSStringFromClass([navigationController class]);
        // 将 UINavigationController 对象设置为 UIWindow 对象的根视图控制器
        self.window.rootViewController = navigationController;
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //保存用户数据
    BOOL success = [[HQLItemStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"Saved all of the HQLItem");
    }else {
        NSLog(@"Could not save any of the HQLItem");
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
