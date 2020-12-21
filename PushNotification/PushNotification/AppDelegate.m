//
//  AppDelegate.m
//  PushNotification
//
//  Created by Qilin Hu on 2020/12/21.
//

#import "AppDelegate.h"
#import "AppDelegate+APNsUpload.h"
#import "NotificationDelegate.h"

@interface AppDelegate ()
@property (nonatomic, strong) NotificationDelegate *notificationDelegate;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 注册推送通知
    [self hql_registerForPushNotifications];
    // 注册可交互式通知
    [self hql_registerNotificationCategory];
    
    // 这里独立设置一个对象来接收并处理 UNUserNotificationCenterDelegate 消息
    self.notificationDelegate = [[NotificationDelegate alloc] init];
    UNUserNotificationCenter.currentNotificationCenter.delegate = self.notificationDelegate;
    
    return YES;
}

// 注册 APNs 成功后，系统会通过该方法返回 Device Token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // 上传推送通知所需的设备标识符
    [self hql_sendPushNotificationDetails:deviceToken];
}

// 向 APNs 注册推送通知失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error {
    NSLog(@"Fail to register for remote notifications. error:%@",error);
    
    // Disable remote notification features.
}

// 一般需要在打开应用或者退出应用时，将 badge 数目清零。
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // 本地清空角标
    [application setApplicationIconBadgeNumber:0];
}

@end
