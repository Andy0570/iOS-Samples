//
//  HQLPasswordView.h
//  HQLPasswordViewDemo
//
//  Created by ToninTech on 2017/6/19.
//  Copyright © 2017年 ToninTech. All rights reserved.
//  !!!: 该示例为之前的遗留代码（Deprecated），请联系开发者，获取更新版本的实现！


#import <UIKit/UIKit.h>
#import "HQLPasswordBackgroundView.h"

typedef void(^HQLPasswordViewInputFinishBlock)(NSString *);
/**
 密码输入视图
 */
@interface HQLPasswordView : UIView 

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *loadingText;

/** 取消支付Block */
@property (nonatomic, copy) dispatch_block_t closeBlock;
/** 忘记密码Block */
@property (nonatomic, copy) dispatch_block_t forgetPasswordBlock;
/** 输入密码完成的Block */
@property (nonatomic, copy) HQLPasswordViewInputFinishBlock finishBlock;

/** 显示密码输入视图 */
- (void)showInView:(UIView *)view;
/** 移除密码输入视图 */
- (void)removePasswordView;

/** 开始加载 */
- (void)startLoading;
/** 加载完成 */
- (void)stopLoading;

/** 请求完成后显示提示信息 */
- (void)requestComplete:(BOOL)state;
- (void)requestComplete:(BOOL)state message:(NSString *)message;

@end
