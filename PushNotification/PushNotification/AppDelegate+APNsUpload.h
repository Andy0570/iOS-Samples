//
//  AppDelegate+APNsUpload.h
//  PushNotification
//
//  Created by Qilin Hu on 2020/12/21.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (APNsUpload)

// 注册推送通知
- (void)hql_registerForPushNotifications;

// 上传推送通知所需的设备标识符
- (void)hql_sendPushNotificationDetails:(NSData *)deviceToken;

// 注册可交互式通知
- (void)hql_registerNotificationCategory;

@end

NS_ASSUME_NONNULL_END
