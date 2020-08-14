//
//  AppDelegate.m
//  CYLTabBarControllerDemo
//
//  Created by Qilin Hu on 2019/10/17.
//  Copyright © 2019 Tonintech. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+CYLTabBar.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 配置主窗口
    /* 💡
     *  如果你查看 CYLTabBarController 框架的 README.md 文档，作者会让你把很多配置方法写在 AppDelegate 这个文件中。
     *  但实际应用场景中，有很多配置方法都要写在这个文件里面，比如日志框架的配置、推送通知框架、第三方支付回调配置...还有一大堆工具类配置。
     *  所以我习惯上会把不同的配置文件单独写在各自的分类（Category）中。
     *  具体原因可以去看看《Effective Objective-C 2.0 编写高质量 iOS 与 OS X 代码的 52 个有效方法 》一书中的第 24 条建议。
     *  因此，所有与初始化 CYLTabBarController 框架相关的代码都在 <AppDelegate+CYLTabBar> 文件里面，保持代码整洁，方便修改。
     */
    [self hql_configureForTabBarController];
    
    return YES;
}

@end
