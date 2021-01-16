//
//  NSFileManager+Database.m
//  SeaTao
//
//  Created by Qilin Hu on 2021/1/14.
//  Copyright © 2021 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "NSFileManager+Database.h"
#import <JKCategories.h>
//#import "HQLUserManager.h"

@implementation NSFileManager (Database)

/// 图片 - 设置
+ (NSURL *)urlForUserSettingImage:(NSString *)imageName {
    // 从归档文件中读取用户信息
//    HQLUserManager *sharedManager = [HQLUserManager sharedManager];
//    NSNumber *userId = sharedManager.user.userId ? : @0;
    
    NSString *directory = [NSString stringWithFormat:@"User/%@/Setting/Images/", @0];
    NSURL *directoryURL = [self p_createDirectory:directory];
    return [directoryURL URLByAppendingPathComponent:imageName];
}

/// 图片 - 聊天
+ (NSURL *)urlForUserChatImage:(NSString *)imageName {
    // 从归档文件中读取用户信息
//    HQLUserManager *sharedManager = [HQLUserManager sharedManager];
//    NSNumber *userId = sharedManager.user.userId ? : @0;
    
    NSString *directory = [NSString stringWithFormat:@"User/%@/Chat/Images/", @0];
    NSURL *directoryURL = [self p_createDirectory:directory];
    return [directoryURL URLByAppendingPathComponent:imageName];
}

/// 图片 - 聊天背景
+ (NSURL *)urlForUserChatBackgroundImage:(NSString *)imageName {
    // 从归档文件中读取用户信息
//    HQLUserManager *sharedManager = [HQLUserManager sharedManager];
//    NSNumber *userId = sharedManager.user.userId ? : @0;
    
    NSString *directory = [NSString stringWithFormat:@"User/%@/Chat/Background/", @0];
    NSURL *directoryURL = [self p_createDirectory:directory];
    return [directoryURL URLByAppendingPathComponent:imageName];
}

/// 图片 - 用户头像
+ (NSURL *)urlForUserAvatar:(NSString *)imageName {
    // 从归档文件中读取用户信息
//    HQLUserManager *sharedManager = [HQLUserManager sharedManager];
//    NSNumber *userId = sharedManager.user.userId ? : @0;
    
    NSString *directory = [NSString stringWithFormat:@"User/%@/Chat/Avator/", @0];
    NSURL *directoryURL = [self p_createDirectory:directory];
    return [directoryURL URLByAppendingPathComponent:imageName];
}

/// 图片 - 屏幕截图
+ (NSURL *)urlForScreenshotImage:(NSString *)imageName {
    NSURL *contactsDirectory = [self p_createDirectory:@"Screenshot/"];
    return [contactsDirectory URLByAppendingPathComponent:imageName];
}

/// 图片 - 本地通讯录
+ (NSURL *)urlForContactsAvator:(NSString *)imageName {
    NSURL *contactsAvatorDirectory = [self p_createDirectory:@"Contacts/Avator/"];
    return [contactsAvatorDirectory URLByAppendingPathComponent:imageName];
}

/// 聊天语音
+ (NSURL *)urlForUserChatVoice:(NSString *)voiceName {
    // 从归档文件中读取用户信息
//    HQLUserManager *sharedManager = [HQLUserManager sharedManager];
//    NSNumber *userId = sharedManager.user.userId ? : @0;
    
    NSURL *voiceDirectory = [self p_createDirectory:@"User/%@/Chat/Voice/"];
    NSString *voiceFileName = [NSString stringWithFormat:@"%@_%@", @0, voiceName];
    return [voiceDirectory URLByAppendingPathComponent:voiceFileName];
}

/// 表情
+ (NSURL *)urlForExpressionForGroupId:(NSString *)groupID {
    NSURL *expressionDirectory = [self p_createDirectory:@"Expression/"];
    return [expressionDirectory URLByAppendingPathComponent:groupID];
}

/// 数据 - 本地通讯录
+ (NSURL *)urlForContactsData {
    NSURL *contactsDirectory = [self p_createDirectory:@"Contacts/"];
    return [contactsDirectory URLByAppendingPathComponent:@"contacts.dat"];
}

/// 数据库 - 通用
+ (NSURL *)commonDatabaseURL {
    // 从归档文件中读取用户信息
//    HQLUserManager *sharedManager = [HQLUserManager sharedManager];
//    NSNumber *userId = sharedManager.user.userId ? : @0;
    
    NSString *directory = [NSString stringWithFormat:@"User/%@/Database/common/", @0];
    NSURL *commonDirectory = [self p_createDirectory:directory];
    return [commonDirectory URLByAppendingPathComponent:@"common.sqlite"];
}

/// 数据库 - 消息
+ (NSURL *)messageDatabaseURL {
    // 从归档文件中读取用户信息
//    HQLUserManager *sharedManager = [HQLUserManager sharedManager];
//    NSNumber *userId = sharedManager.user.userId ? : @0;
        
    NSString *directory = [NSString stringWithFormat:@"User/%@/Database/Message/", @0];
    NSURL *commonDirectory = [self p_createDirectory:directory];
    return [commonDirectory URLByAppendingPathComponent:@"message.sqlite"];
}

/// 缓存
+ (NSURL *)urlForCacheFile:(NSString *)filename {
    return [[NSFileManager jk_cachesURL] URLByAppendingPathComponent:filename];
}

#pragma mark - Private

// 创建指定目录
+ (NSURL *)p_createDirectory:(NSString *)directoryName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsURL = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
    NSURL *directoryURL = [documentsURL URLByAppendingPathComponent:directoryName];
    if (![fileManager fileExistsAtPath:directoryURL.path]) {
        BOOL result = [fileManager createDirectoryAtPath:directoryURL.path withIntermediateDirectories:YES attributes:nil error:nil];
        NSAssert(result, @"Failed to Create Directory.");
    }
    
    return directoryURL;
}

@end
