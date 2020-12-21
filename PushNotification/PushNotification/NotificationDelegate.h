//
//  NotificationDelegate.h
//  PushNotification
//
//  Created by Qilin Hu on 2020/12/21.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

@interface NotificationDelegate : NSObject <UNUserNotificationCenterDelegate>

@end

NS_ASSUME_NONNULL_END

/**
 UNUserNotificationCenterDelegate 协议中的方法用来处理与通知的交互，以及 app 处于前台时如何响应通知。

 userNotification(_:didReceive:withCompletionHandler:)： app 处于后台、未运行时，系统会调用该方法，可以在该方法内响应 actionable 通知，以及用户点击通知时执行的操作。例如，打开指定页面。
 userNotificationCenter(_:willPresent:withCompletionHandler:)：app 处于前台时，系统会调用该方法，在该方法内决定如何处理通知。
 */
