//
//  HQLComment.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/10/12.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HQLUser;

/// 评论模型
@interface HQLComment : NSObject

/// 视频 ID
@property (nonatomic, strong) NSNumber *mediabaseId;

/// 评论、回复 ID
@property (nonatomic, strong) NSNumber *commentId;

/// 创建时间
@property (nonatomic, strong) NSDate *createDateTime;

/// 被回复的用户
@property (nonatomic, strong) HQLUser *toUser;

/// 评论来源用户
@property (nonatomic, strong) HQLUser *fromeUser;

/// 评论内容
@property (nonatomic, copy) NSString *content;

/// 是否是回复
@property (nonatomic, assign, getter=isReply) BOOL reply;

@end

NS_ASSUME_NONNULL_END
