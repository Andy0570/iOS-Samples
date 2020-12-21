//
//  NotificationService.m
//  PushNotificationService
//
//  Created by Qilin Hu on 2020/12/21.
//

#import "NotificationService.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Modify the notification content here...
    // self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
    
    if (!self.bestAttemptContent) {
        return;
    }
    
    NSString *attachmentURLAsString = (NSString *)request.content.userInfo[@"media-url"];
    if (!attachmentURLAsString) {
        return;
    }
    
    NSURL *attachmentURL = [NSURL URLWithString:attachmentURLAsString];
    
    // 下载 URL 对应的图片,如果图片不为 nil 就把它传递到 attachments
    [self downloadImageFromURL:attachmentURL completion:^(UNNotificationAttachment *attachment) {
        self.bestAttemptContent.attachments = [NSArray arrayWithObject:attachment];
        self.contentHandler(self.bestAttemptContent);
    }];
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    if (self.contentHandler && self.bestAttemptContent) {
        self.bestAttemptContent.title = @"Incoming Image";
        self.contentHandler(self.bestAttemptContent);
    }
}

// 从 URL 链接中下载图片
- (void)downloadImageFromURL:(NSURL *)url completion:(void(^)(UNNotificationAttachment *attachment))completionHandler {
    NSURLSessionDownloadTask *task = [NSURLSession.sharedSession downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 1. 测试 URL 和转义，如果 URL 不确定
        if (!location) {
            completionHandler(nil);
            return;
        }
        
        // 2. 获取当前用户临时目录
        NSURL *urlPath = [NSURL fileURLWithPath:NSTemporaryDirectory()];
        // 3. 在这种情况下，为 url 路径添加适当的结尾。
        // .jpg (系统在安排相应的通知请求之前验证附加文件的内容。如果附加的文件损坏、无效或不支持的文件类型，则不会安排传递通知请求。)
        NSString *uniqueURLString = [NSProcessInfo.processInfo.globallyUniqueString stringByAppendingString:@".png"];
        urlPath = [urlPath URLByAppendingPathComponent:uniqueURLString];
        
        // 4. 将 downloadUrl 移动到新创建的 urlPath
        if ([[NSFileManager defaultManager] moveItemAtURL:location toURL:urlPath error:NULL]) {
            UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"picture" URL:urlPath options:nil error:nil];
            completionHandler(attachment);
        } else {
            completionHandler(nil);
        }
    }];
    [task resume];
}

@end
