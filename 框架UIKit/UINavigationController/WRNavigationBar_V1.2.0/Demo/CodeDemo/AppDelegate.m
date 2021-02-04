//
//  AppDelegate.m
//  CodeDemo
//
//  Created by wangrui on 2017/4/11.
//  Copyright © 2017年 wangrui. All rights reserved.
//
//  Github地址：https://github.com/wangrui460/WRNavigationBar

#import "AppDelegate.h"

// Framework
#import <IQKeyboardManager/IQKeyboardManager.h>

#import "BaseNavigationController.h" // 导航视图控制器基类

#import "NormalListController.h"    // 1.常用
#import "CustomListController.h"    // 2.自定义导航栏
#import "MoveListController.h"      // 3.移动导航栏
#import "SixthViewController.h"
#import "CustomNavBarController.h"
#import "WRNavigationBar.h"         // WRNavigationBar

UIColor *MainNavBarColor = nil;
UIColor *MainViewColor = nil;


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [IQKeyboardManager sharedManager].enable = YES;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    BaseNavigationController *firstNav = [[BaseNavigationController alloc] initWithRootViewController:[NormalListController new]];
    BaseNavigationController *secondNav = [[BaseNavigationController alloc] initWithRootViewController:[CustomListController new]];
    BaseNavigationController *thirdNav = [[BaseNavigationController alloc] initWithRootViewController:[MoveListController new]];
    UITabBarController *tabBarVC = [UITabBarController new];
    tabBarVC.viewControllers = @[firstNav, secondNav, thirdNav];
    [self setTabBarItems:tabBarVC];
    
    self.window.rootViewController = tabBarVC;
    [self setNavBarAppearence];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)setTabBarItems:(UITabBarController*)tabBarVC
{
    NSArray *titles = @[@"常用", @"自定义导航栏", @"3.导航栏浮动效果"];
    NSArray *normalImages = @[@"mine", @"mine", @"mine"];
    NSArray *highlightImages = @[@"mineHighlight", @"mineHighlight", @"mineHighlight"];
    [tabBarVC.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.title = titles[idx];
        obj.image = [[UIImage imageNamed:normalImages[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        obj.selectedImage = [[UIImage imageNamed:highlightImages[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }];
}

- (void)setNavBarAppearence
{
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor purpleColor]}];
//    [UINavigationBar appearance].tintColor = [UIColor yellowColor];
//    [UINavigationBar appearance].barTintColor = [UIColor redColor];
    
    MainNavBarColor = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    MainViewColor   = [UIColor colorWithRed:126/255.0 green:126/255.0 blue:126/255.0 alpha:1];
    
    // !!!: 初始化设置 WRNavigationBar
    // 设置是 广泛使用WRNavigationBar，还是局部使用WRNavigationBar，目前默认是广泛使用
    [WRNavigationBar wr_widely];
    [WRNavigationBar wr_setBlacklist:@[@"SpecialController",
                                       @"TZPhotoPickerController",
                                       @"TZGifPhotoPreviewController",
                                       @"TZAlbumPickerController",
                                       @"TZPhotoPreviewController",
                                       @"TZVideoPlayerController"]];
    
    // 设置导航栏默认的背景颜色
    [WRNavigationBar wr_setDefaultNavBarBarTintColor:MainNavBarColor];
    // 设置导航栏所有按钮的默认颜色，白色
    [WRNavigationBar wr_setDefaultNavBarTintColor:[UIColor whiteColor]];
    // 设置导航栏标题默认颜色，白色
    [WRNavigationBar wr_setDefaultNavBarTitleColor:[UIColor whiteColor]];
    // 统一设置状态栏样式，明亮样式
    [WRNavigationBar wr_setDefaultStatusBarStyle:UIStatusBarStyleLightContent];
    // 如果需要设置导航栏底部分割线隐藏，可以在这里统一设置
    [WRNavigationBar wr_setDefaultNavBarShadowImageHidden:NO];
}


@end
