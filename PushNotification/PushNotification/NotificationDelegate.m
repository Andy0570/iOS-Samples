//
//  NotificationDelegate.m
//  PushNotification
//
//  Created by Qilin Hu on 2020/12/21.
//

#import "NotificationDelegate.h"
#import <UIKit/UIKit.h>

@implementation NotificationDelegate

#pragma mark - <UNUserNotificationCenterDelegate>

// 只有当应用程序在前台时，才会在委托上调用该方法。如果未实现该方法或未及时调用该处理程序，则不会显示该通知。
// 应用程序可以选择将通知显示为声音，badge 角标，alert 或显示在通知列表中。 该决定应基于通知中的信息是否对用户可见。
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    NSDictionary *userInfo = notification.request.content.userInfo;
    if ([notification.request.trigger isKindOfClass:UNPushNotificationTrigger.class]) {
        // TODO: 处理远程推送内容
        
        NSLog(@"%@",userInfo);
    }
    
    if ([notification.request.identifier isEqualToString:@"calendar"]) {
        completionHandler(UNNotificationPresentationOptionNone);
        return;
    }
    
    // 需要执行这个方法，选择是否提醒用户，有 Bardge、Sound、Alert 三种类型可以选择设置
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound);
}

// 这是点击推送通知后，进入 APP 执行的函数
// 当用户通过打开应用程序，关闭通知或执行 UNNotificationAction 响应通知时，将在委托上调用该方法。
// 必须在应用程序从 application:didFinishLaunchingWithOptions: 委托方法返回之前设置。
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if ([response.notification.request.trigger isKindOfClass:UNPushNotificationTrigger.class]) {
        // TODO: 处理远程推送内容
        
        NSLog(@"收到远程推送通知：%@", userInfo);
    }
    
    if (response.actionIdentifier == UNNotificationDefaultActionIdentifier) {
        NSLog(@"Default Action");
    } else if (response.actionIdentifier == UNNotificationDismissActionIdentifier) {
        NSLog(@"Dismiss Action");
    } else if ([response.notification.request.content.categoryIdentifier isEqualToString:@"calendarCategory"]) {
        // 处理日历 Category 按钮点击
        [self handleCalendarCategoryAction:response];
    } else if ([response.notification.request.content.categoryIdentifier isEqualToString:@"customUICategory"]) {
        // 处理自定义UI Category
        [self handleCustomUICategory:response];
    }
    
    completionHandler(); // 系统要求执行这个方法
}

#pragma mark - Help Method

// 处理日历 Category 按钮点击
- (void)handleCalendarCategoryAction:(UNNotificationResponse *)response {
    if ([response.actionIdentifier isEqualToString:@"makeAsCompleted"]) {
        // 日历 Category - 标记为完成 Action
        return;
    } else if ([response.actionIdentifier isEqualToString:@"remindMeIn1Minute"]) {
        // 日历 Category - 1 分钟后提醒 Action
        NSDate *newDate = [NSDate dateWithTimeIntervalSinceNow:60];
        [self scheduleNotificationAt:newDate];
        NSLog(@"1 Minute");
    } else if ([response.actionIdentifier isEqualToString:@"remindMeIn5Minutes"]) {
        // 日历 Category - 5 分钟后提醒 Action
        NSDate *newDate = [NSDate dateWithTimeIntervalSinceNow:60*5];
        [self scheduleNotificationAt:newDate];
        NSLog(@"5 Minutes");
    }
}

// 处理自定义UI Category
- (void)handleCustomUICategory:(UNNotificationResponse *)response {
    NSString *text = @"";
    if ([response.actionIdentifier isEqualToString:@"stop"]) {
        return;
    } else if ([response.actionIdentifier isEqualToString:@"comment"]) {
        text = ((UNTextInputNotificationResponse *)response).userText;
    }
    
    if (text.length > 0) {
        NSString *message = [NSString stringWithFormat:@"You just said:%@",text];
        // 简单显示 Alert 弹窗
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Comment" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        
        UIViewController *vc = UIApplication.sharedApplication.keyWindow.rootViewController;
        [vc presentViewController:alertController animated:YES completion:nil];
    }
}

// Calendar
- (void)scheduleNotificationAt:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *components = [calendar componentsInTimeZone:[NSTimeZone localTimeZone] fromDate:date];
    NSDateComponents *newComponents = [[NSDateComponents alloc] init];
    newComponents.calendar = calendar;
    newComponents.timeZone = [NSTimeZone localTimeZone];
    newComponents.month = components.month;
    newComponents.day = components.day;
    newComponents.hour = components.hour;
    newComponents.minute = components.minute;
    
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:newComponents repeats:NO];
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"Calendar Reminder";
    content.body = @"github.com/andy0570";
    content.sound = UNNotificationSound.defaultSound;
    content.categoryIdentifier = @"calendarCategory";
    
    // Request
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"calendar"
                                                                          content:content
                                                                          trigger:trigger];
    
    [UNUserNotificationCenter.currentNotificationCenter addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Failed to add request to notification center. error:\(error)");
        }
    }];
}

@end
