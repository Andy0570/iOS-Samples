//
//  HQLUser.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/10/12.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 用户模型
@interface HQLUser : NSObject

@property (nonatomic, readonly, strong) NSNumber *userId;
@property (nonatomic, readonly, copy) NSString *nickname;
@property (nonatomic, readonly, strong) NSURL *avatarUrl;

- (instancetype)initWithUserId:(NSNumber *)userId nickname:(NSString *)nickname avatarUrl:(NSURL *)avatarUrl NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
