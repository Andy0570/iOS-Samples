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
#import "MainTableViewController.h"
#import "MineTableViewController.h"

@interface HQLBaseTabBarController ()

@end

@implementation HQLBaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewControllers];
}

- (void)setupViewControllers {
    // 首页
    UIViewController *mainVC = [self renderTabBarItem:[[MainTableViewController alloc] initWithStyle:UITableViewStylePlain]  title:@"首页" normalImage:@"home_normal" selectedImage:@"home_select"];
    HQLBaseNavigationController *mainNav = [[HQLBaseNavigationController alloc] initWithRootViewController:mainVC];
    
    // 我的
    UIViewController *mineVC = [self renderTabBarItem:[[MineTableViewController alloc] initWithStyle:UITableViewStylePlain] title:@"我的" normalImage:@"mine_normal" selectedImage:@"mine_select"];
    HQLBaseNavigationController *mineNav = [[HQLBaseNavigationController alloc] initWithRootViewController:mineVC];
    
    self.viewControllers = @[mainNav, mineNav];
}


- (UIViewController *)renderTabBarItem:(UIViewController *)viewController
                                 title:(NSString *)title
                           normalImage:(NSString *)normalImageName
                         selectedImage:(NSString *)selectedImageName {
    
    // 设置导航栏的标题为 TabBar 标题
    viewController.title = title;
    
    // 设置 tabBar 图片
    UIImage *normalImage = [[UIImage imageNamed:normalImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
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
