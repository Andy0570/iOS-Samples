//
//  AppDelegate.m
//  NavigationControllerDemo
//
//  Created by Qilin Hu on 2020/4/16.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if (@available(iOS 13.0, *)) {
        
    } else {
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        // 实例化第一个视图控制器对象
        FirstViewController *vc = [[FirstViewController alloc] init];
        // 初始化导航视图控制器对象
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.window setBackgroundColor:[UIColor whiteColor]];
        // 将导航视图控制器对象设置为当前窗口的根视图控制器对象
        [self.window setRootViewController:nav];
        [self.window makeKeyAndVisible];
    }
    return YES;
}


#pragma mark - UISceneSession lifecycle

/*
1. 如果没有在 APP 的 Info.plist 文件中包含 Scene 的配置数据，或者要动态更改场景配置数据，需要实现此方法。
   UIKit 会在创建新 Scene 前调用此方法。
2. 方法会返回一个 UISceneConfiguration 对象，其中包含场景详细信息，
   包括要创建的场景类型，用于管理场景的委托对象以及包含要显示的初始视图控制器的 storyboard。
   如果未实现此方法，则必须在应用程序的 Info.plist 文件中提供场景配置数据。

总结：默认在 Info.plist 中进行了配置，不用实现该方法也没有关系。
     如果没有配置就需要实现此方法并返回一个 UISceneConfiguration 对象。
 
 配置参数中 Application Session Role 是个数组，每一项有三个参数:
 * Configuration Name: 当前配置的名字;
 * Delegate Class Name: 与哪个 Scene 代理对象关联;
 * StoryBoard name: 这个 Scene 使用的哪个 storyboard。

 注意：代理方法中调用的是配置名为 Default Configuration 的 Scene，则系统就会自动去调用 SceneDelegate 这个类。
      这样 SceneDelegate 和 AppDelegate 产生了关联。
*/
- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}

// 在分屏中关闭其中一个或多个 Scene 的时候回调用
- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // 当用户放弃场景会话时调用。
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // 如果在应用程序未运行时丢弃了任何会话，则会在 application:didFinishLaunchingWithOptions 方法执行过后不久就会调用此方法
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    // 使用此方法可以释放（所有特定于丢弃场景的）资源，因为它们不会返回。
}


@end
