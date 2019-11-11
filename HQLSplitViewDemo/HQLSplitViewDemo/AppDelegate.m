//
//  AppDelegate.m
//  HQLSplitViewDemo
//
//  Created by ToninTech on 2016/12/20.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "AppDelegate.h"
#import "HQLMasterTableViewController.h"
#import "HQLDetailTableViewController.h"
#import "HQLSplitViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // 主列表
    HQLMasterTableViewController *masterTableViewController = [[HQLMasterTableViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:masterTableViewController];
    // 从列表
    HQLDetailTableViewController *detailTableViewController = [[HQLDetailTableViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *secondNavigationController = [[UINavigationController alloc] initWithRootViewController:detailTableViewController];
    // 创建UISplitViewController对象
    HQLSplitViewController *splitViewController = [[UISplitViewController alloc] init];
    //  配置分屏视图界面外观
    splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    // 调整masterViewController的宽度，按百分比调整
    splitViewController.preferredPrimaryColumnWidthFraction = 0.5;
    // 手势识别器，让用户使用滑动动作更改显示模式
    splitViewController.presentsWithGesture = YES;
    splitViewController.delegate = detailTableViewController;
    splitViewController.viewControllers = @[masterTableViewController,detailTableViewController];
    
    self.window.rootViewController = splitViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
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
