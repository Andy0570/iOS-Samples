//
//  NotificationService.h
//  PushNotificationService
//
//  Created by Qilin Hu on 2020/12/21.
//

#import <UserNotifications/UserNotifications.h>

@interface NotificationService : UNNotificationServiceExtension

@end


/**
 通过 Notification Service Extension 实现推送通知拦截处理！
 
 !!!: 注意点
 payload 的 aps 字段中必须要有 "mutable-content" : 1
 项目 target 版本请设置为 iOS 13.2
 如果测试发送推送通知，还是没有走扩展，请重启 iPhone。
 
 {
     "aps" : {
         "alert" : {
         "title" : "This is title",
         "body" : "This is body"
         },
         "badge" : 1,
         "sound" : "default",
         "category": "customUICategory",
         "mutable-content" : 1
     },
     "media-url": "https://static01.imgkr.com/temp/aeecc28371fd4ce093202e1beec7ecf4.png",
     "media-type": "image"
 }
 */
