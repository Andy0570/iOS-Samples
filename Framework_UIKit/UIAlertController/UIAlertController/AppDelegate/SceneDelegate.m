//
//  SceneDelegate.m
//  UIAlertController
//
//  Created by Qilin Hu on 2020/4/21.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "SceneDelegate.h"
#import <Harpy.h>

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    
    /**
     检查应用版本更新的弹窗
     集成 Harpy 框架：<https://github.com/ArtSabintsev/Harpy>
     
     FIXME: 实际测试时连接失败，控制台错误内容如下：
     [connection] nw_resolver_start_query_timer_block_invoke [C1] Query fired: did not receive all answers in time for itunes.apple.com:443
     */
    if (@available(iOS 13.0, *)) {
        
        // 设置要显示 UIAlertController 的视图控制器实例
        [[Harpy sharedInstance] setPresentingViewController:_window.rootViewController];
        
        // (可选项)当设置此功能时，只有在当前版本已经发布 x 天的情况下，才会显示警报。
        // 默认情况下，该值设置为 1（天），以避免出现 Apple 更新 JSON 的速度快于应用程序二进制文件上传到 App Store 的问题。
        [[Harpy sharedInstance] setShowAlertAfterCurrentVersionHasBeenReleasedForDays:3];
        
        // (可选项)设置 alertController 的 tintColor 属性
        //[[Harpy sharedInstance] setAlertControllerTintColor:@"<#alert_controller_tint_color#>"];
        
        // (可选项)设置应用程序名称
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *appName = [infoDic objectForKey:@"CFBundleDisplayName"];
        [[Harpy sharedInstance] setAppName:appName];
        
        // (可选项)设置应用更新的 alert 可选类型
        [[Harpy sharedInstance] setAlertType:HarpyAlertTypeOption];
        
        // (可选项)如果您的应用程序在美国 App Store 中不可用，您必须指定您的应用程序所在地区的双字母国家代码。
        //[[Harpy sharedInstance] setCountryCode:HarpyLanguageChineseSimplified];
        
        // 开启调试模式
        // [[Harpy sharedInstance] setDebugEnabled:YES];
        
        // 检查应用程序最新版本号
        [[Harpy sharedInstance] checkVersion];
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
    
    // 执行每日检查
    // [[Harpy sharedInstance] checkVersionDaily];
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
