//
//  HQLPasswordsView.h
//  XuZhouSS
//
//  Created by ToninTech on 2017/7/18.
//  Copyright © 2017年 ToninTech. All rights reserved.
//  !!!: 该示例为之前的遗留代码（Deprecated），请联系开发者，获取更新版本的实现！

#import <UIKit/UIKit.h>

typedef void(^HQLPasswordButtonClickBlock)(void);
typedef void(^HQLPasswordViewInputFinishBlock)(NSString *);

/**
 密码框输入视图
 */
@interface HQLPasswordsView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *loadingText;
@property (nonatomic, strong) UITextField *pwdTextField;

/** 取消支付Block */
@property (nonatomic, copy) HQLPasswordButtonClickBlock closeBlock;
/** 忘记密码Block */
@property (nonatomic, copy) HQLPasswordButtonClickBlock forgetPasswordBlock;
/** 输入密码完成的Block */
@property (nonatomic, copy) HQLPasswordViewInputFinishBlock finishBlock;

/** 显示密码输入视图 */
//- (void)showInView:(UIView *)view;

/** 移除密码输入视图 */
- (void)removePasswordView;

/** 请求完成后显示提示信息 */
- (void)requestComplete:(BOOL)state;
- (void)requestComplete:(BOOL)state message:(NSString *)message;

@end
