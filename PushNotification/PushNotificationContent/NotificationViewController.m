//
//  NotificationViewController.m
//  PushNotificationContent
//
//  Created by Qilin Hu on 2020/12/21.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface NotificationViewController () <UNNotificationContentExtension>

@property IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *speakerLabel;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
}

/**
 didReceive(_:)：该方法必须实现。在该方法内使用 notification content 配置视图控制器。在视图控制器可见时，该方法可能会被调用多次。
 具体的说，新到达通知与已经显示通知 threadIdentifier 相同时，会再次调用该方法。该方法在扩展程序的主线程中调用。
 */
- (void)didReceiveNotification:(UNNotification *)notification {
    self.label.text = [NSString stringWithFormat:@"Content Extension:%@",notification.request.content.body];
    [self shake];
}

/**
 didReceive(_:completionHandler:)：该方法可选实现。用户点击自定义按钮时会调用该方法。该方法的 UNNotificationResponse 参数可以用来区分用户点击的按钮。处理完毕任务后，必须调用 completion 块。如果你实现了该方法，则必须处理所有 category 的所有 action。如果没有实现该方法，用户点击按钮后系统会将通知转发给你的 app。
 */
- (void)didReceiveNotificationResponse:(UNNotificationResponse *)response completionHandler:(void (^)(UNNotificationContentExtensionResponseOption))completion {
    if ([response.actionIdentifier isEqualToString:@"stop"]) {
        self.speakerLabel.text = @"🔇";
        [self cancelShake];
        completion(UNNotificationContentExtensionResponseOptionDoNotDismiss);
    } else if ([response.actionIdentifier isEqualToString:@"comment"]) {
        completion(UNNotificationContentExtensionResponseOptionDismissAndForwardAction);
    } else {
        completion(UNNotificationContentExtensionResponseOptionDoNotDismiss);
    }
}

- (void)shake {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = 1;
    animation.repeatCount = HUGE_VALF;
    animation.values = @[@(-20.0), @(20.0), @(-20.0), @(20.0), @(-10.0), @(10.0), @(-5.0), @(5.0), @(0.0)];
    [self.speakerLabel.layer addAnimation:animation forKey:@"shake"];
}

- (void)cancelShake {
    [self.speakerLabel.layer removeAnimationForKey:@"shake"];
}

@end
