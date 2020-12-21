//
//  AppDelegate+APNsUpload.m
//  PushNotification
//
//  Created by Qilin Hu on 2020/12/21.
//

#import "AppDelegate+APNsUpload.h"
#import <UserNotifications/UserNotifications.h>

@implementation AppDelegate (APNsUpload)

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

// 上传推送通知所需的设备标识符
- (void)hql_sendPushNotificationDetails:(NSData *)deviceToken {
    // 获取 APNs 返回的 device token
    const char *data = [deviceToken bytes];
    NSMutableString *token = [NSMutableString string];
    
    for (int i = 0; i<deviceToken.length; ++i) {
        [token appendFormat:@"%02.2hhx",data[i]];
    }
    NSLog(@"Device Token: %@", [token copy]);
    
    // TODO: 向服务器转发 device token 开启推送通知功能
    
}

// 注册可交互式通知
// 在通知上添加 action 按钮，实现可操作（Actionable）通知
/**
 
 【日历 Category payload 示例】
 !!!: 可交互式通知的 payload 字段中必须包含 category 字段，且唯一标识符需要与注册时设置的相同！
 {
     "aps":{
         "alert":{
             "title":"This is Title",
             "body":"This is Body"
         },
         "badge":1,
         "sound":"default",
         "category": "calendarCategory"
     }
 }
 */
- (void)hql_registerNotificationCategory {
    // 日历 Category
    // 标记为完成
    UNNotificationAction *completeAction = [UNNotificationAction actionWithIdentifier:@"makeAsCompleted"
                                                                                title:@"标记为完成"
                                                                              options:UNNotificationActionOptionNone];
    // 1 分钟后提醒
    UNNotificationAction *remindMeIn1MinuteAction = [UNNotificationAction actionWithIdentifier:@"remindMeIn1Minute"
                                                                                         title:@"1 分钟后提醒"
                                                                                       options:UNNotificationActionOptionNone];
    // 5 分钟后提醒
    UNNotificationAction *remindMeIn5MinuteAction = [UNNotificationAction actionWithIdentifier:@"remindMeIn5Minute"
                                                                                         title:@"5 分钟后提醒"
                                                                                       options:UNNotificationActionOptionNone];
    // 日历 Category
    UNNotificationCategory *calendarCategory = [UNNotificationCategory categoryWithIdentifier:@"calendarCategory"
                                                                                      actions:@[completeAction, remindMeIn1MinuteAction, remindMeIn5MinuteAction]
                                                                            intentIdentifiers:@[]
                                                                                      options:UNNotificationCategoryOptionCustomDismissAction];
    
    // 自定义 UI Category
    UNNotificationAction *stopAction = [UNNotificationAction actionWithIdentifier:@"stop"
                                                                            title:@"暂停"
                                                                          options:UNNotificationActionOptionForeground];
    UNNotificationAction *commentAction = [UNNotificationAction actionWithIdentifier:@"comment"
                                                                              title:@"评论"
                                                                            options:UNNotificationActionOptionForeground];
    UNNotificationCategory *customUICategory = [UNNotificationCategory categoryWithIdentifier:@"customUICategory"
                                                                                      actions:@[stopAction, commentAction]
                                                                            intentIdentifiers:@[]
                                                                                      options:UNNotificationCategoryOptionCustomDismissAction];
    
    [UNUserNotificationCenter.currentNotificationCenter setNotificationCategories:[NSSet setWithObjects:calendarCategory, customUICategory, nil]];
}

/**
 UNNotificationAction * likeAction;              //喜欢
 UNNotificationAction * ingnoreAction;           //取消
 UNTextInputNotificationAction * inputAction;    //文本输入
 
 likeAction = [UNNotificationAction actionWithIdentifier:@"action_like"
                                                   title:@"点赞"
                                                 options:UNNotificationActionOptionForeground];

 inputAction = [UNTextInputNotificationAction actionWithIdentifier:@"action_input"
                                                             title:@"评论"
                                                           options:UNNotificationActionOptionForeground
                                              textInputButtonTitle:@"发送"
                                              textInputPlaceholder:@"说点什么"];
 
 ingnoreAction = [UNNotificationAction actionWithIdentifier:@"action_cancel"
                                                      title:@"忽略"
                                                    options:UNNotificationActionOptionForeground];
 
 //下面的Identifier 需与 NotificationContent的info.plist 文件中所配置的 UNNotificationExtensionCategory 一致，
 //本示例中为“myNotificationCategory”
 UNNotificationCategory * category;
 category = [UNNotificationCategory categoryWithIdentifier:@"myNotificationCategory"
                                                   actions:@[likeAction, inputAction, ingnoreAction]
                                         intentIdentifiers:@[]
                                                   options:UNNotificationCategoryOptionNone];
 
 NSSet * sets = [NSSet setWithObjects:category, nil];
 [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:sets];
 */


@end
