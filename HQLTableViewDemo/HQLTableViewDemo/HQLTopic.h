//
//  HQLTopic.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/10/12.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HQLUser, HQLComment;

/// 话题模型
@interface HQLTopic : NSObject

/// 视频 ID
@property (nonatomic, strong) NSNumber *mediabaseId;

@property (nonatomic, strong) NSNumber *topicId;

/// 用户模型
@property (nonatomic, strong) HQLUser *user;

/// 点赞数
@property (nonatomic, assign) NSNumber *thumbNums;
@property (nonatomic, copy) NSString *thumbNumsString;

/// 是否点赞
@property (nonatomic, assign, getter=isThumb) BOOL thumb;

/// 创建时间
@property (nonatomic, strong) NSDate *createDateTime;
@property (nonatomic, copy) NSString *createDateTimeString;

/// 话题内容
@property (nonatomic, copy) NSString *content;

/// 该话题下的所有评论
@property (nonatomic, strong) NSMutableArray<HQLComment *> *comments;

/// 评论条数
@property (nonatomic, assign) NSNumber *commentsCount;

@end

NS_ASSUME_NONNULL_END
