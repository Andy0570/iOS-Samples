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


@interface AppDelegate ()
@property (strong, nonatomic) UIViewController *viewController;
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
    self.viewController = tabBarController;
    
    [self customizeTabBarForController:tabBarController];
}

- (void)customizeTabBarForController:(HQLTabBarController *)tabBarController {
    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];
    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    NSArray *tabBarItemImages = @[@"first", @"second", @"third"];
    
    NSInteger index = 0;
    for (HQLTabBarItem *item in [[tabBarController tabBar] items]) {
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setSelectedImage:selectedimage withUnselectedImage:unselectedimage];
        item.title = [tabBarItemImages objectAtIndex:index];
        
        index++;
    }
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

@end
