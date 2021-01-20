//
//  HQLTabBarController.m
//  HQLRiseTabBarDemo
//
//  Created by Qilin Hu on 2019/10/14.
//  Copyright © 2019 Tonintech. All rights reserved.
//

#import "HQLTabBarController.h"

// Controller
#import "HQLNavigationController.h"

#import "HomeViewController.h"
#import "MyCityViewController.h"
#import "MessageViewController.h"
#import "AccountViewController.h"

// Model
#import "HQLTabBarItem.h"

// Category
#import "UIButton+AdjustImageAndTitle.h"
#import "UIImage+LYColor.h"

@interface HQLTabBarController ()

@end

@implementation HQLTabBarController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewControllers];
    [self configTabBarAppearance];
}

#pragma mark - Private

/// 将要添加到 TabBar 中的 UIViewController 用 UINavigationController 封装后再添加
- (void)setupViewControllers {
    UIColor *normalTitleColor = [UIColor grayColor];
    UIColor *selectedTitleColor = [UIColor blackColor];
    
    // 修复 tabBar 选中时颜色变蓝
    self.tabBar.tintColor = selectedTitleColor;

    // 首页
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    HQLTabBarItem *homeTabBarItem = [[HQLTabBarItem alloc] initWithNormalTitle:@"首页" selectedTitle:@"首页" normalTitleColor:normalTitleColor selectedTitleColor:selectedTitleColor normalImageName:@"home_normal" selectedImageName:@"home_highlight"];
    [self configController:homeVC withTabBarItem:homeTabBarItem];
    HQLNavigationController *homeNC = [[HQLNavigationController alloc] initWithRootViewController:homeVC];
    
    // 同城
    MyCityViewController *myCityVC = [[MyCityViewController alloc] init];
    HQLTabBarItem *myCityTabBarItem = [[HQLTabBarItem alloc] initWithNormalTitle:@"同城" selectedTitle:@"同城" normalTitleColor:normalTitleColor selectedTitleColor:selectedTitleColor normalImageName:@"mycity_normal" selectedImageName:@"mycity_highlight"];
    [self configController:myCityVC withTabBarItem:myCityTabBarItem];
    HQLNavigationController *myCityNC = [[HQLNavigationController alloc] initWithRootViewController:myCityVC];
    
    // 消息
    MessageViewController *messageVC = [[MessageViewController alloc] init];
    HQLTabBarItem *messageTabBarItem = [[HQLTabBarItem alloc] initWithNormalTitle:@"消息" selectedTitle:@"消息" normalTitleColor:normalTitleColor selectedTitleColor:selectedTitleColor normalImageName:@"message_normal" selectedImageName:@"message_highlight"];
    [self configController:messageVC withTabBarItem:messageTabBarItem];
    HQLNavigationController *messageNC = [[HQLNavigationController alloc] initWithRootViewController:messageVC];
    
    // 我的
    AccountViewController *accountVC = [[AccountViewController alloc] init];
    HQLTabBarItem *accountTabBarItem = [[HQLTabBarItem alloc] initWithNormalTitle:@"我的" selectedTitle:@"消息" normalTitleColor:normalTitleColor selectedTitleColor:selectedTitleColor normalImageName:@"account_normal" selectedImageName:@"account_highlight"];
    [self configController:accountVC withTabBarItem:accountTabBarItem];
    HQLNavigationController *accountNC = [[HQLNavigationController alloc] initWithRootViewController:accountVC];
    
    // !!!: 占位视图控制器
    UIViewController *placeHolderVC = [[UIViewController alloc] init];
    placeHolderVC.tabBarItem.enabled = NO;
    placeHolderVC.tabBarItem.title = nil;
    
    self.viewControllers = @[homeNC, myCityNC, placeHolderVC, messageNC, accountNC];
}

- (void)configController:(UIViewController *)controller withTabBarItem:(HQLTabBarItem *)tabBarItem {
    // 设置导航栏标题为 TabBar 标题
    controller.title = tabBarItem.normalTitle;
    
    // 设置 tabBar 标题、图片
    UIImage *normalImage = [[UIImage imageNamed:tabBarItem.normalImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage = [[UIImage imageNamed:tabBarItem.selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem = [[UITabBarItem alloc] initWithTitle:tabBarItem.normalTitle image:normalImage selectedImage:selectedImage];
    
    // 设置 tabBar 标题默认颜色：灰色
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: tabBarItem.normalTitleColor} forState:UIControlStateNormal];
    
    // 设置 tabBar 标题被选中的颜色：黑色
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: tabBarItem.selectedTitleColor} forState:UIControlStateSelected];
}

- (void)configTabBarAppearance {
    
    // 去掉TabBar上部的黑色线条,设置TabBar透明背景
//    [[UITabBar appearance] setBackgroundImage:[UIImage imageWithLYColor:[UIColor clearColor]]];
//    [[UITabBar appearance] setShadowImage:[UIImage new]];
        
//    UIView *topLineView = [[UIView alloc] init];
//    topLineView.frame = CGRectMake(0, 0, CGRectGetWidth(self.tabBar.bounds), 1);
//    topLineView.backgroundColor = [UIColor colorWithWhite:0.966 alpha:1.000];
//    [self.tabBar addSubview:topLineView];
    
    // MARK: 设置中间的 tabBarItem
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((self.tabBar.bounds.size.width - 55) / 2, self.tabBar.bounds.size.height - 88, 55, 100)];
    // set button image
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    // 38 * 38
    [button setImage:[UIImage imageNamed:@"post_normal"] forState:UIControlStateNormal];
    // set button title
    [button setTitle:@"发布" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:10.0 weight:UIFontWeightBold];
    // adjust position
    [button hql_verticalCenterImageAndTitle:2.0];
    [button addTarget:self
               action:@selector(middleButtonDidClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    
    // 将自定义按钮添加到 tabBar
    [self.tabBar addSubview:button];
    [self.tabBar bringSubviewToFront:button];
}

#pragma mark - IBActions

- (void)middleButtonDidClicked:(id)sender {
    // 1.实例化UIAlertController对象
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"标准的Action Sheet样式"
                                                                   message:@"UIAlertControllerStyleActionSheet"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];

    // 2.1实例化UIAlertAction按钮:取消按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             NSLog(@"取消按钮被按下！");
                                                         }];
    [alert addAction:cancelAction];

    // 2.2实例化UIAlertAction按钮:拍照按钮
    UIAlertAction *takePhoneAction = [UIAlertAction actionWithTitle:@"拍照"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                NSLog(@"拍照按钮被按下！");
                                                            }];
    [alert addAction:takePhoneAction];

    // 2.3实例化UIAlertAction按钮:从相册选取按钮
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"从相册选取"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              NSLog(@"从相册选取按钮被按下");
                                                          }];
    [alert addAction:confirmAction];
    
    // 2.4实例化UIAlertAction按钮:淘宝一键转卖
    UIAlertAction *fastAction = [UIAlertAction actionWithTitle:@"从相册选取"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           NSLog(@"从相册选取按钮被按下");
                                                       }];
    [alert addAction:fastAction];
    
    //  3.显示alertController
    [self presentViewController:alert animated:YES completion:nil];
}

@end
