//
//  GHIssue.h
//  MantleDemo
//
//  Created by Qilin Hu on 2020/4/26.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>
@class GHUser;


typedef enum : NSUInteger {
    GHIssueStateOpen,
    GHIssueStateClosed
} GHIssueState;

NS_ASSUME_NONNULL_BEGIN

/// 通过 Mantle 框架实现模型层
// 需要遵守 <MTLJSONSerializing> 协议
@interface GHIssue : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSURL *URL;     // URL 类型
@property (nonatomic, copy, readonly) NSURL *HTMLURL; // URL 类型
@property (nonatomic, copy, readonly) NSNumber *number;
@property (nonatomic, assign, readonly) GHIssueState state;  // 枚举类型
@property (nonatomic, copy, readonly) NSString *reporterLogin;
@property (nonatomic, strong, readonly) GHUser *assignee; // 该属性指向 GHUser 对象实例
@property (nonatomic, copy, readonly) NSDate *updatedAt;  // JSON 日期字符串，转换为 NSDate

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *body;

@property (nonatomic, copy, readonly) NSDate *retrievedAt;

@end

NS_ASSUME_NONNULL_END
