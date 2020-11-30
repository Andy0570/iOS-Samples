//
//  HQLCodeResignView.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/11/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CodeResignViewCompletionHandler)(NSString *content);
typedef void(^CodeResignViewCancelHandler)(NSString *content);

/// 验证码输入视图
@interface HQLCodeResignView : UIView

@property (nonatomic, copy) CodeResignViewCompletionHandler completionHandler;
@property (nonatomic, copy) CodeResignViewCancelHandler cancelHandler;

- (instancetype)initWithCodeBits:(NSInteger)codeBits;

@end

NS_ASSUME_NONNULL_END
