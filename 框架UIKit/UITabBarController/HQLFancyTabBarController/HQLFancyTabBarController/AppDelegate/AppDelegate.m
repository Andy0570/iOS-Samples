//
//  AppDelegate.m
//  HQLTabBarController
//
//  Created by Qilin Hu on 2021/3/19.
//

#import "AppDelegate.h"

#import "HQLTabBarController.h"
#import "HQLTabBarItem.h"

#import "First_RootViewController.h"
#import "Second_RootViewController.h"
#import "Third_RootViewController.h"

@interface AppDelegate () <HQLTabBarControllerDelegate>
@property (strong, nonatomic) HQLTabBarController *viewController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 设置和初始化应用窗口的根视图控制器
    // 初始化应用窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 设置窗口根视图控制器
    [self setupViewControllers];
    self.window.rootViewController = self.viewController;
    self.window.backgroundColor = UIColor.whiteColor;
    [self.window makeKeyAndVisible];
    
    [self customizeInterface];
    
    return YES;
}

- (void)setupViewControllers {
    UIViewController *firstViewController = [[First_RootViewController alloc] init];
    UIViewController *firstNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:firstViewController];
    
    UIViewController *secondViewController = [[Second_RootViewController alloc] init];
    UIViewController *secondNavigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:secondViewController];
    
    UIViewController *thirdViewController = [[Third_RootViewController alloc] init];
    UIViewController *thirdNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:thirdViewController];
    
    HQLTabBarController *tabBarController = [[HQLTabBarController alloc] init];
    tabBarController.viewControllers = @[firstNavigationController, secondNavigationController, thirdNavigationController];
    tabBarController.delegate = self;
    self.viewController = tabBarController;
    
    [self customizeTabBarForController:tabBarController];
}

- (void)customizeTabBarForController:(HQLTabBarController *)tabBarController {
    // tabBar
    tabBarController.tabBar.backgroundImage = [UIImage imageNamed:@"tab_background"];
    tabBarController.tabBar.contentEdgeInsets = UIEdgeInsetsMake(0, 19.0f, 0, 19.0f);
    // tabBarItem
    [tabBarController.tabBar.items enumerateObjectsUsingBlock:^(HQLTabBarItem *item, NSUInteger idx, BOOL * _Nonnull stop) {
        
        item.imagePositionAdjustment = UIOffsetMake(0.0f, 5.0f);
        item.titlePositionAdjustment = UIOffsetMake(0.0f, 5.0f);
        item.unselectedTitleAttributes = @{
            NSFontAttributeName: [UIFont systemFontOfSize:10.0f],
            NSForegroundColorAttributeName: [UIColor blackColor],
        };
        item.selectedTitleAttributes =@{
            NSFontAttributeName: [UIFont systemFontOfSize:10.0f],
            NSForegroundColorAttributeName: [UIColor blueColor],
        };
        
        if (idx == 0) {
            [item setSelectedImage:[UIImage imageNamed:@"tab_home_selected"] withUnselectedImage:[UIImage imageNamed:@"tab_home_normal"]];
            item.title = @"首页";

        } else if (idx == 1) {
            item.imagePositionAdjustment = UIOffsetMake(0.0f, 2.0f);
            [item setSelectedImage:[UIImage imageNamed:@"publish"] withUnselectedImage:[UIImage imageNamed:@"publish"]];
            item.title = nil;
        } else if (idx == 2) {
            [item setSelectedImage:[UIImage imageNamed:@"tab_market_selected"] withUnselectedImage:[UIImage imageNamed:@"tab_market_normal"]];
            item.title = @"去逛街";
        }
    }];
}

- (void)customizeInterface {
    UINavigationBar *navigationBarApperance = [UINavigationBar appearance];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationbar_background_tall"];
    NSDictionary *textAttributes = @{
        NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
        NSForegroundColorAttributeName: [UIColor blackColor],
    };
    
    [navigationBarApperance setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    [navigationBarApperance setTitleTextAttributes:textAttributes];
    
}

- (BOOL)tabBarController:(HQLTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (viewController == self.viewController.viewControllers[1]) {
        // 实现你自己想要的呈现
        
        return NO;
    }
    return YES;
}

@end
