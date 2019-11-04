//
//  HQLSSCardModel.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2018/12/28.
//  Copyright © 2018 ToninTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 卡包模型
 */
@interface HQLSSCardModel : NSObject

@property (nonatomic, readonly, copy) NSString *idNumber;
@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, assign) BOOL isMasterCard; // 主/副卡标识
@property (nonatomic, readwrite, assign) BOOL isCardUsing; // 是否正在使用中

@end

NS_ASSUME_NONNULL_END
