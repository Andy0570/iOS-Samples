//
//  SceneDelegate.m
//  NavigationControllerDemo
//
//  Created by Qilin Hu on 2020/4/16.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "SceneDelegate.h"
#import "FirstViewController.h"
#import "HQLMainViewController.h"
#import "HQLBaseNavigationController.h"



@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // 使用此方法可以有选择地配置 UIWindow 窗口并将其附加到提供的 UIWindowScene 场景中。
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // 如果使用 storyboard，window 属性将会自动初始化并附加到场景中
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    // 该委托并不意味着连接场景或会话是新的（请参见 `application：configurationForConnectingSceneSession`）
    

    if (@available(iOS 13.0, *)) {
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.window setWindowScene:windowScene];
        
        // 1.1 首页
        // FirstViewController *vc = [[FirstViewController alloc] init];
        
        // 1.2 自定义导航栏
        HQLMainViewController *mainVC = [[HQLMainViewController alloc] init];
        
        HQLBaseNavigationController *nav = [[HQLBaseNavigationController alloc] initWithRootViewController:mainVC];
        
        [self.window setBackgroundColor:[UIColor whiteColor]];
        [self.window setRootViewController:nav];
        [self.window makeKeyAndVisible];
    }
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // 当场景被系统释放时调用
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
