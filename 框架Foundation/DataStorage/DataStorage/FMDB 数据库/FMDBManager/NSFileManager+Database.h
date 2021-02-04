//
//  NSFileManager+Database.h
//  SeaTao
//
//  Created by Qilin Hu on 2021/1/14.
//  Copyright © 2021 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (Database)

/// 图片 - 设置
+ (NSURL *)urlForUserSettingImage:(NSString *)imageName;

/// 图片 - 聊天
+ (NSURL *)urlForUserChatImage:(NSString *)imageName;

/// 图片 - 聊天背景
+ (NSURL *)urlForUserChatBackgroundImage:(NSString *)imageName;

/// 图片 - 用户头像
+ (NSURL *)urlForUserAvatar:(NSString *)imageName;

/// 图片 - 屏幕截图
+ (NSURL *)urlForScreenshotImage:(NSString *)imageName;

/// 图片 - 本地通讯录
+ (NSURL *)urlForContactsAvator:(NSString *)imageName;

/// 聊天语音
+ (NSURL *)urlForUserChatVoice:(NSString *)voiceName;

/// 表情
+ (NSURL *)urlForExpressionForGroupId:(NSString *)groupID;

/// 数据 - 本地通讯录
+ (NSURL *)urlForContactsData;

/// 数据库 - 通用
+ (NSURL *)commonDatabaseURL;

/// 数据库 - 消息
+ (NSURL *)messageDatabaseURL;

/// 缓存
+ (NSURL *)urlForCacheFile:(NSString *)filename;


@end

NS_ASSUME_NONNULL_END
