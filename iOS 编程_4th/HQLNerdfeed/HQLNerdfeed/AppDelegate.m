//
//  AppDelegate.m
//  HQLNerdfeed
//
//  Created by ToninTech on 16/8/29.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "AppDelegate.h"
#import "HQLCoursesViewController.h"
#import "HQLWebViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    HQLCoursesViewController *cvc = [[HQLCoursesViewController alloc] initWithStyle:UITableViewStylePlain];
    
    UINavigationController *masterNav = [[UINavigationController alloc] initWithRootViewController:cvc];
    
    HQLWebViewController *wvc = [[HQLWebViewController alloc] init];
    cvc.webViewController = wvc;
    
//    self.window.rootViewController = masterNav;
    
    //检查当前设备是否是iPad
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        //必须将webViewController包含在导航视图控制器中
        UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:wvc];
        
        UISplitViewController *svc = [[UISplitViewController alloc] init];
        //将从视图控制器设置为UISplitViewController对象的委托对象
        svc.delegate = wvc;
        
        svc.viewControllers = @[masterNav,detailNav];
        
        //隐藏视图可以通过一个滑动的手势来呈现和解除
        svc.presentsWithGesture = YES;
        
        //将UISplitViewController对象设置为UIWindow对象的根视图控制器
        self.window.rootViewController = svc;
        
    }else {
        
        //对于非iPad设备，仍然使用导航控制器
        self.window.rootViewController = masterNav;
        
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
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
