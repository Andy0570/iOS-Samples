//
//  AppDelegate.m
//  TLTabBarController
//
//  Created by 李伯坤 on 2017/9/15.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import "AppDelegate.h"
#import "TLTabBarController.h"
#import "TLDemoTableViewController.h"
#import "SVProgressHUD.h"
#import "TLPublishViewController.h"
#import "TLMessageViewController.h"
#import "TLMineViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMaximumDismissTimeInterval:0.5];
    
    [self loadUI];
    return YES;
}

#pragma mark - # Load UI
- (void)loadUI
{
    
    // 接入方式
//    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    TLTabBarController *tabBarController = [[TLTabBarController alloc] init];
    
    __weak TLTabBarController *weakTabBarController = tabBarController;
    
    TLDemoTableViewController *vc1 = [[TLDemoTableViewController alloc] init];
    UINavigationController *navC1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    [vc1 setTitle:@"首页"];
    [vc1.tabBarItem setImage:[UIImage imageNamed:@"home"]];
    [vc1.tabBarItem setSelectedImage:[UIImage imageNamed:@"homeHL"]];
    [tabBarController addChildViewController:navC1];
    
    
    TLDemoTableViewController *vc2 = [[TLDemoTableViewController alloc] init];
    UINavigationController *navC2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    [tabBarController addChildViewController:navC2];
    [vc2 setTitle:@"分类"];
    [vc2.tabBarItem setImage:[UIImage imageNamed:@"cate"]];
    [vc2.tabBarItem setSelectedImage:[UIImage imageNamed:@"cateHL"]];

    
    // 发布按钮
    UITabBarItem *addItem = [[UITabBarItem alloc] initWithTitle:@"发布" image:[UIImage imageNamed:@"publish"] selectedImage:[UIImage imageNamed:@"publish"]];
    [tabBarController addPlusItemWithSystemTabBarItem:addItem actionBlock:^{
        TLPublishViewController *publishVC = [[TLPublishViewController alloc] init];
        UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:publishVC];
        [weakTabBarController.selectedViewController presentViewController:navC animated:YES completion:nil];
    }];
    
    // 消息页面，with跳转判断逻辑
    
    // 1、创建一个vc
    TLMessageViewController *vc3 = [[TLMessageViewController alloc] init];
    UINavigationController *navC3 = [[UINavigationController alloc] initWithRootViewController:vc3];
    
    // 2、将vc添加到tabBarController中，并设置自定义的响应时间
    [tabBarController addChildViewController:navC3 actionBlock:^BOOL {
        // 3、点击响应block，弹出一个alertView
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"允许切换到消息界面吗" message:@"此处可做登录判断等需求" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"不允许" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"允许" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakTabBarController setSelectedIndex:3];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [weakTabBarController.selectedViewController presentViewController:alertController animated:YES completion:nil];
        
        // 返回NO代表，点击该item时，不允许直接跳转
        return NO;
    }];
    
    [vc3 setTitle:@"消息"];
    [vc3.tabBarItem setImage:[UIImage imageNamed:@"msg"]];
    [vc3.tabBarItem setSelectedImage:[UIImage imageNamed:@"msgHL"]];
    [vc3.tabBarItem setBadgeValue:@"3"];
    
    TLMineViewController *vc4 = [[TLMineViewController alloc] init];
    UINavigationController *navC4 = [[UINavigationController alloc] initWithRootViewController:vc4];
    [tabBarController addChildViewController:navC4 actionBlock:^BOOL{
        [SVProgressHUD showSuccessWithStatus:@"进入我的界面"];
        return YES;
    }];
    [vc4 setTitle:@"我的"];
    [vc4.tabBarItem setImage:[UIImage imageNamed:@"mine"]];
    [vc4.tabBarItem setSelectedImage:[UIImage imageNamed:@"mineHL"]];
    [vc4.tabBarItem setBadgeValue:@""];
    
    
    // 选中
    [tabBarController setSelectedIndex:1];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setRootViewController:tabBarController];
    [self.window addSubview:tabBarController.view];
    [self.window makeKeyAndVisible];
}



@end
