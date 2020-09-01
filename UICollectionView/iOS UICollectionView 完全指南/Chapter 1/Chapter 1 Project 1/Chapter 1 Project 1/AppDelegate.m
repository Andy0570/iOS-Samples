//
//  AppDelegate.m
//  Chapter 1 Project 1
//
//  Created by Qilin Hu on 2020/8/31.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "AFViewController.h"

@interface AppDelegate ()
@property (strong, nonatomic) AFViewController *viewController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    self.viewController = [[AFViewController alloc] initWithNibName:NSStringFromClass(AFViewController.class) bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
