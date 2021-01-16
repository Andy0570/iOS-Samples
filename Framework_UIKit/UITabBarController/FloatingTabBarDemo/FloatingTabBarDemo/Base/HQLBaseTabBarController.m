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

#pragma mark - Privite

/**
 视图控制器层级架构
 
 HQLBaseTabBarController - HQLBaseNavigationController - MainViewController   // 首页
                         - HQLBaseNavigationController - SecondViewController // 次页
 */
- (void)setupViewControllers {
    MainViewController *mainVC = [[MainViewController alloc] init];
    HQLBaseNavigationController *mainNav = [[HQLBaseNavigationController alloc] initWithRootViewController:mainVC];
    
    SecondViewController *marketVC = [[SecondViewController alloc] init];
    HQLBaseNavigationController *marketNav = [[HQLBaseNavigationController alloc] initWithRootViewController:marketVC];
    
    self.viewControllers = @[mainNav, marketNav];
}

@end
