//
//  HQLFeedbackType.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/10/9.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <Mantle.h>

NS_ASSUME_NONNULL_BEGIN

/// 意见反馈类型
@interface HQLFeedbackType : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, strong) NSNumber *feedbackId;
@property (nonatomic, readonly, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
