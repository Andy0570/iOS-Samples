//
//  HQLTabBarController.m
//  HQLRiseTabBarDemo
//
//  Created by Qilin Hu on 2019/10/14.
//  Copyright © 2019 Tonintech. All rights reserved.
//

#import "HQLTabBarController.h"

// Controllers
#import "HQLNavigationController.h"

#import "HomeViewController.h"
#import "MyCityViewController.h"
#import "MessageViewController.h"
#import "AccountViewController.h"

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
    // 首页
    UIViewController *homeVC = [self renderTabBarItem:[[HomeViewController alloc] init]
                                                title:@"首页"
                                           imageNamed:@"home_normal"
                                   selectedImageNamed:@"home_highlight"];
    HQLNavigationController *homeNC = [[HQLNavigationController alloc] initWithRootViewController:homeVC];
    
    // 同城
    UIViewController *myCityVC = [self renderTabBarItem:[[MyCityViewController alloc] init]
                                                  title:@"同城"
                                             imageNamed:@"mycity_normal"
                                     selectedImageNamed:@"mycity_highlight"];
    HQLNavigationController *myCityNC = [[HQLNavigationController alloc] initWithRootViewController:myCityVC];
    
    // 消息
    UIViewController *messageVC = [self renderTabBarItem:[[MessageViewController alloc] init]
                                                   title:@"消息"
                                              imageNamed:@"message_normal"
                                      selectedImageNamed:@"message_highlight"];
    HQLNavigationController *messageNC = [[HQLNavigationController alloc] initWithRootViewController:messageVC];
    
    // 我的
    UIViewController *accountVC = [self renderTabBarItem:[[AccountViewController alloc] init]
                                                   title:@"我的"
                                              imageNamed:@"account_normal"
                                      selectedImageNamed:@"account_highlight"];
    HQLNavigationController *accountNC = [[HQLNavigationController alloc] initWithRootViewController:accountVC];
    
    // 占位视图控制器
    UIViewController *placeHolderVC = [[UIViewController alloc] init];
    placeHolderVC.tabBarItem.enabled = NO;
    placeHolderVC.tabBarItem.title = nil;
    
    self.viewControllers = @[homeNC, myCityNC, placeHolderVC, messageNC, accountNC];
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
    
    // 设置 tabBar 标题默认颜色：灰色
    [viewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}
                                             forState:UIControlStateNormal];
    // 设置 tabBar 标题被选中时的颜色：黑色
    UIColor *themeColor = [UIColor blackColor];
    [viewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: themeColor}
                                             forState:UIControlStateSelected];
    
    // 修复 tabBar 文字选中时颜色变蓝
    self.tabBar.tintColor = themeColor;
    return viewController;
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
