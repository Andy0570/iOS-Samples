//
//  SceneDelegate.m
//  MathMonsters
//
//  Created by Qilin Hu on 2020/5/28.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "SceneDelegate.h"
#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Monster.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {

    if (@available(iOS 13.0, *)) {
        // 获取主-从视图控制器，并配置初始状态时，详细视图控制器的 Monster 数据源
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        // 设置分体视图控制器的显示样式
        // splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
        // 调整 masterViewController 的宽度，按百分比调整
        // splitViewController.preferredPrimaryColumnWidthFraction = 0.5;

        // UISplitViewController - UINavigationController - MasterViewController
        UINavigationController *leftNavController = splitViewController.viewControllers.firstObject;
        MasterViewController *masterViewController = leftNavController.viewControllers.firstObject;

        // UISplitViewController - UINavigationController - DetailViewController
        UINavigationController *detailNavController = splitViewController.viewControllers.lastObject;
        DetailViewController *detailViewController = detailNavController.viewControllers.firstObject;
        
        // 设置详情页导航按钮
        detailViewController.navigationItem.leftItemsSupplementBackButton = YES;
        detailViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
        
        // 将 DetailViewController 设置为 MasterViewController 的代理
        // 通过 Delegate 的方式在 Master-Detail 之间传递 Monster 数据
        masterViewController.delegate = detailViewController;
        
        Monster *firstMonster = masterViewController.monsters.firstObject;
        detailViewController.monster = firstMonster;
    }
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
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
