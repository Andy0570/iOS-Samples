//
//  NotificationViewController.h
//  PushNotificationContent
//
//  Created by Qilin Hu on 2020/12/21.
//

#import <UIKit/UIKit.h>

@interface NotificationViewController : UIViewController

@end


/**
 !!!: 要点：
 1. 创建 Notification Content 时要 Active 激活。
 2. 需要修改 Info.plist 文件。
    Info.plist -> NSExtension -> NSExtensionAttributes -> UNNotificationExtensionCategory 设置该 Target 的唯一标识符
    其 value 默认为 String 类型。如果要支持多个 category，可以将其修改为 Array 类型。
 
    
 
 
 3. 需要编辑 Target capability 中的 App Groups
 */
