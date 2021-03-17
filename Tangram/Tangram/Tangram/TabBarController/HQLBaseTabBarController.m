//
//  HQLBaseTabBarController.m
//  UICollectionView
//
//  Created by Qilin Hu on 2020/8/25.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLBaseTabBarController.h"

// Controller
#import "HQLBaseNavigationController.h"
#import "TangramViewController.h"
#import "VirtualViewViewController.h"
#import "ScrollViewController.h"

@interface HQLBaseTabBarController ()

@end

@implementation HQLBaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewControllers];
}

- (void)setupViewControllers {
    // 首页
    UIViewController *mainVC = [self renderTabBarItem:[[TangramViewController alloc] initWithStyle:UITableViewStylePlain]  title:@"首页" normalImage:@"a.circle" selectedImage:@"a.circle.fill"];
    HQLBaseNavigationController *mainNav = [[HQLBaseNavigationController alloc] initWithRootViewController:mainVC];
    
    // 发现
    UIViewController *findVC = [self renderTabBarItem:[[VirtualViewViewController alloc] initWithStyle:UITableViewStylePlain]  title:@"发现" normalImage:@"b.circle" selectedImage:@"b.circle.fill"];
    HQLBaseNavigationController *findNav = [[HQLBaseNavigationController alloc] initWithRootViewController:findVC];
    
    // 我的
    UIViewController *mineVC = [self renderTabBarItem:[[ScrollViewController alloc] initWithStyle:UITableViewStylePlain] title:@"我的" normalImage:@"c.circle" selectedImage:@"c.circle.fill"];
    HQLBaseNavigationController *mineNav = [[HQLBaseNavigationController alloc] initWithRootViewController:mineVC];
    
    self.viewControllers = @[mainNav, findNav, mineNav];
}

- (UIViewController *)renderTabBarItem:(UIViewController *)viewController
                                 title:(NSString *)title
                           normalImage:(NSString *)normalImageName
                         selectedImage:(NSString *)selectedImageName {
    
    // 设置导航栏的标题为 TabBar 标题
    viewController.title = title;
    
    // 设置 tabBar 图片
//    UIImage *normalImage = [[UIImage imageNamed:normalImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIImage *selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *normalImage = [UIImage systemImageNamed:normalImageName];
    UIImage *selectedImage = [UIImage systemImageNamed:selectedImageName];
    viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:normalImage selectedImage:selectedImage];
    
    // 设置 tabBar 标题默认颜色：黑色
    [viewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}
                                             forState:UIControlStateNormal];
    // 设置 tabBar 标题被选中时的颜色：主题色
    UIColor *themeColor = [UIColor blackColor];
    [viewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:themeColor}
                                             forState:UIControlStateSelected];
    
    // 修复 TabBar 文字选中时颜色变蓝
    self.tabBar.tintColor = themeColor;
    
    return viewController;
}

@end
