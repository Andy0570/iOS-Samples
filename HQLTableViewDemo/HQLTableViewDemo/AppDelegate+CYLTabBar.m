//
//  AppDelegate+CYLTabBar.m
//  PersonalCenterDemo
//
//  Created by Qilin Hu on 2019/10/23.
//  Copyright © 2019 Tonintech. All rights reserved.
//

#import "AppDelegate+CYLTabBar.h"

// Framework
#import <UIKit/UIKit.h>
#import <CYLTabBarController.h>
#import <ChameleonFramework/Chameleon.h>

// Controller
#import "HQLTabBarController.h"
#import "HQLMainTableViewController.h"
#import "HQLSearchViewController.h"
#import "HQLMessageViewController.h"
#import "HQLMeTableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate (CYLTabBar)

#pragma mark - Public

- (void)hql_configureForTabBarController {
    // 设置主窗口，并设置根视图控制器
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // 初始化 CYLTabBarController 对象
    HQLTabBarController *tabBarController =
        [HQLTabBarController tabBarControllerWithViewControllers:[self viewControllers]
                                               tabBarItemsAttributes:[self tabBarItemsAttributes]];
    self.window.rootViewController = tabBarController;
    
    // 自定义 TabBar 字体、背景、阴影
    [self customizeTabBarInterface];
}

#pragma mark - Private

/// 控制器数组
- (NSArray *)viewControllers {
    // 首页
    HQLMainTableViewController *mainTableVC = [[HQLMainTableViewController alloc] initWithStyle:UITableViewStylePlain];
    mainTableVC.navigationItem.title = @"首页";
    CYLBaseNavigationController *homeNC = [[CYLBaseNavigationController alloc] initWithRootViewController:mainTableVC];
    //[mainNC cyl_setHideNavigationBarSeparator:YES];
    
    // 搜索
    HQLSearchViewController *searchVC = [[HQLSearchViewController alloc] initWithStyle:UITableViewStyleGrouped];
    searchVC.navigationItem.title = @"搜索";
    CYLBaseNavigationController *searchNC = [[CYLBaseNavigationController alloc] initWithRootViewController:searchVC];
    //[newsNC cyl_setHideNavigationBarSeparator:YES];
    
    // 消息
    HQLMessageViewController *messageVC = [[HQLMessageViewController alloc] init];
    messageVC.navigationItem.title = @"消息";
    CYLBaseNavigationController *messageNC = [[CYLBaseNavigationController alloc] initWithRootViewController:messageVC];
    //[qrCodeNC cyl_setHideNavigationBarSeparator:YES];
    
    // 我的
    HQLMeTableViewController *meVC = [[HQLMeTableViewController alloc] initWithStyle:UITableViewStylePlain];
    meVC.navigationItem.title = @"我的";
    CYLBaseNavigationController *meNC = [[CYLBaseNavigationController alloc] initWithRootViewController:meVC];
    //[mineNC cyl_setHideNavigationBarSeparator:YES];
    
    NSArray *viewControllersArray = @[homeNC, searchNC, messageNC, meNC];
    return viewControllersArray;
}

/// tabBar 属性数组
- (NSArray *)tabBarItemsAttributes {
    NSDictionary *mainTabBarItemsAttributes = @{
        CYLTabBarItemTitle: @"首页",
        CYLTabBarLottieURL : [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tab_home_animate" ofType:@"json"]],
        CYLTabBarLottieSize: [NSValue valueWithCGSize:CGSizeMake(33, 33)],
    };
    NSDictionary *newsTabBarItemsAttributes = @{
        CYLTabBarItemTitle: @"搜索",
        CYLTabBarLottieURL : [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tab_search_animate" ofType:@"json"]],
        CYLTabBarLottieSize: [NSValue valueWithCGSize:CGSizeMake(33, 33)],
    };
    NSDictionary *lawTabBarItemsAttributes = @{
        CYLTabBarItemTitle: @"消息",
        CYLTabBarLottieURL : [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tab_message_animate" ofType:@"json"]],
        CYLTabBarLottieSize: [NSValue valueWithCGSize:CGSizeMake(33, 33)],
    };
    NSDictionary *mineTabBarItemsAttributes = @{
        CYLTabBarItemTitle: @"我的",
        CYLTabBarLottieURL : [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tab_me_animate" ofType:@"json"]],
        CYLTabBarLottieSize: [NSValue valueWithCGSize:CGSizeMake(33, 33)],
    };
    
    NSArray *tabBarItemsAttributes = @[
        mainTabBarItemsAttributes,
        newsTabBarItemsAttributes,
        lawTabBarItemsAttributes,
        mineTabBarItemsAttributes
    ];
    return tabBarItemsAttributes;
}

- (void)customizeTabBarInterface {
    // 设置文字属性
    if (@available(iOS 10.0, *)) {
        // [self cyl_tabBarController].tabBar.unselectedItemTintColor = [UIColor blackColor];
        [self cyl_tabBarController].tabBar.tintColor = [UIColor blackColor];
    } else {
        UITabBarItem *tabBar = [UITabBarItem appearance];
        // 普通状态下的文字属性
        [tabBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor lightTextColor]}
                              forState:UIControlStateNormal];
        // 选中状态下的文字属性
        [tabBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}
                              forState:UIControlStateSelected];
    }
    
//    // 设置 TabBar 背景颜色：白色
//    // 使用 YYKit 框架中的 imageWithColor: 方法，通过颜色生成图片
//    [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]];
//
//    // 去除 TabBar 自带的顶部阴影
//    [[self cyl_tabBarController] hideTabBarShadowImageView];
//
//    // 设置 TabBar 阴影
//    CYLTabBarController *tabBarController = [self cyl_tabBarController];
//    tabBarController.tabBar.layer.shadowColor = [UIColor blackColor].CGColor;
//    tabBarController.tabBar.layer.shadowRadius = 15.0;
//    tabBarController.tabBar.layer.shadowOpacity = 0.2;
//    tabBarController.tabBar.layer.shadowOffset = CGSizeMake(0, 3);
//    tabBarController.tabBar.layer.masksToBounds = NO;
//    tabBarController.tabBar.clipsToBounds = NO;
}

@end
