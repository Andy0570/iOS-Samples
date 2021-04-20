### 注册推送通知

注册 APNs 获取推送所需的 token，以 User Notification 为例，具体步骤如下：

```objc
#import <UserNotifications/UserNotifications.h>

// ...

// 注册推送通知
- (void)hql_registerForPushNotifications {
    // 获取推送通知用户授权设置
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            switch ([settings authorizationStatus]) {
                case UNAuthorizationStatusAuthorized:
                    // 已同意授权，向 APNs 注册
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[UIApplication sharedApplication] registerForRemoteNotifications];
                    });
                    break;
                case UNAuthorizationStatusNotDetermined:
                    // 未决定，向用户申请授权，用户同意后再向 APNs 注册
                    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
                        if (granted) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[UIApplication sharedApplication] registerForRemoteNotifications];
                            });
                        }
                    }];
                    break;
                default:
                    break;
            }
    }];
}
```

### 获取并保存保存 Device Token

注册 APNs 成功后，系统会通过 `didRegisterForRemoteNotificationsWithDeviceToken` 函数返回 deviceToken。一般情况，在该函数里保存 deviceToken 和 apnsTeamId 即可。

```objc
// 注册 APNs 成功后，系统会通过该方法返回 Token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // 在该函数中保存 deviceToken 和 apnsTeamId
    // deviceToken
    // {length = 32, bytes = 0xb8e83b31 bbc1dac6 21359112 82df1ed0 ... dc0e011e 40aec24d }
    DDLogVerbose(@"deviceToken:%@",deviceToken);
}
```

iOS 系统重装、从备份恢复应用、在新设备上安装应用都会导致 device token 变化，因此 [Apple 推荐](https://developer.apple.com/documentation/usernotifications/registering_your_app_with_apns)在应用每次启动时都去请求 APNs 的 device token，获取 token 后进行设置并保存 token。



### 响应推送通知

```objc
#pragma mark - <UNUserNotificationCenterDelegate>

// 这是点击推送通知后，进入 APP 执行的函数
// 当用户通过打开应用程序，关闭通知或执行 UNNotificationAction 响应通知时，将在委托上调用该方法。
// 必须在应用程序从 application:didFinishLaunchingWithOptions: 委托方法返回之前设置。
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge; // 推送消息的角标
    NSString *body = content.body;   // 推送消息体
    UNNotificationSound *sound = content.sound; // 推送消息的声音
    NSString *title = content.title; // 推送消息的标题
    NSString *subtitle = content.subtitle; // 推送消息的副标题
    
    if ([response.notification.request.trigger isKindOfClass:UNPushNotificationTrigger.class]) {
        // TODO: 处理远程推送内容
        
        NSLog(@"收到远程推送通知：%@", userInfo);
    } else {
        // 判断为本地通知
        NSLog(@"收到本地通知:{body:%@,title:%@,subtitle:%@,badge:%@,sound:%@,userInfo:%@}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler(); // 系统要求执行这个方法
}

// 只有当应用程序在前台时，才会在委托上调用该方法。如果未实现该方法或未及时调用该处理程序，则不会显示该通知。
// 应用程序可以选择将通知显示为声音，badge 角标，alert 或显示在通知列表中。 该决定应基于通知中的信息是否对用户可见。
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    NSDictionary *userInfo = notification.request.content.userInfo;
    if ([notification.request.trigger isKindOfClass:UNPushNotificationTrigger.class]) {
        // TODO: 处理远程推送内容
        
        NSLog(@"%@",userInfo);
    }
    // 需要执行这个方法，选择是否提醒用户，有 Bardge、Sound、Alert 三种类型可以选择设置
    completionHandler(UNNotificationPresentationOptionAlert);
}
```



### 清除 Badge

一般需要在打开应用或者退出应用时，将 badge 数目清零。

```objc
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // 本地清空角标
    [application setApplicationIconBadgeNumber:0];
}
```

