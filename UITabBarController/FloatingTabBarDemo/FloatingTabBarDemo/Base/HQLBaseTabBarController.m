//
//  HQLBaseTabBarController.m
//  SeaTao
//
//  Created by Qilin Hu on 2020/4/28.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLBaseTabBarController.h"

// Frameworks
#import <YYKit.h>

// Controllers
#import "HQLBaseNavigationController.h"
#import "MainViewController.h"
#import "SecondViewController.h"

@interface HQLBaseTabBarController ()

@end

@implementation HQLBaseTabBarController

#pragma mark - Initialize

- (instancetype)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        
        // 添加并管理视图控制器
        [self setupViewControllers];
    }
    return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

}

#pragma mark - Privite

/**
 视图控制器层级架构
 
 HQLBaseTabBarController - HQLBaseNavigationController - MainViewController   // 首页
                         - HQLBaseNavigationController - SecondViewController // 去逛街
 */
- (void)setupViewControllers {
//    // 首页
//    UIViewController *mainVC = [self renderTabBarItem:[[MainViewController alloc] init]
//                                                title:@"首页"
//                                           imageNamed:@"tab_home_normal"
//                                   selectedImageNamed:@"tab_home_selected"];
//    HQLBaseNavigationController *mainNav = [[HQLBaseNavigationController alloc] initWithRootViewController:mainVC];
//
//    // 去逛街
//    UIViewController *marketVC = [self renderTabBarItem:[[SecondViewController alloc] init]
//                                                  title:@"去逛街"
//                                             imageNamed:@"tab_market_normal"
//                                     selectedImageNamed:@"tab_market_selected"];
//    HQLBaseNavigationController *marketNav = [[HQLBaseNavigationController alloc] initWithRootViewController:marketVC];
    
    MainViewController *mainVC = [[MainViewController alloc] init];
    HQLBaseNavigationController *mainNav = [[HQLBaseNavigationController alloc] initWithRootViewController:mainVC];
    SecondViewController *marketVC = [[SecondViewController alloc] init];
    HQLBaseNavigationController *marketNav = [[HQLBaseNavigationController alloc] initWithRootViewController:marketVC];
    
    self.viewControllers = @[mainNav, marketNav];
}

- (UIViewController *)renderTabBarItem:(UIViewController *)viewController
                                 title:(NSString *)title
                            imageNamed:(NSString *)normalImgName
                    selectedImageNamed:(NSString *)selectedImgName {
    
    // 设置导航栏的标题为 TabBar 标题
    viewController.title = title;
    
    // 设置 tabBar 图片
    UIImage *normalImage = [[UIImage imageNamed:normalImgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage = [[UIImage imageNamed:selectedImgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:normalImage selectedImage:selectedImage];
    
    // 设置 tabBar 标题默认颜色：黑色
    [viewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}
                                             forState:UIControlStateNormal];
    // 设置 tabBar 标题被选中时的颜色：主题色
    UIColor *themeColor = [UIColor colorWithRed:71/255.0f green:193/255.0f blue:182/255.0f alpha:1.0];
    [viewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:themeColor}
                                             forState:UIControlStateSelected];
    
    // 修复 TabBar 文字选中时颜色变蓝
    self.tabBar.tintColor = themeColor;
    
    return viewController;
}

@end
