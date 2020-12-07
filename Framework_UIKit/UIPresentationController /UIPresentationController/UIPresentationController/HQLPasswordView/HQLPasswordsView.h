//
//  HQLPasswordsView.h
//  XuZhouSS
//
//  Created by ToninTech on 2017/7/18.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HQLPasswordViewInputFinishBlock)(NSString *inputPassword);

/// 密码框输入视图
@interface HQLPasswordsView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *loadingText;
// @"password_close" 、@"password_back"
@property (nonatomic, copy) NSString *closeButtonImage;
@property (nonatomic, strong) UITextField *pwdTextField;

/** 取消支付Block */
@property (nonatomic, copy) dispatch_block_t closeBlock;
/** 忘记密码Block */
@property (nonatomic, copy) dispatch_block_t forgetPasswordBlock;
/** 输入密码完成的Block */
@property (nonatomic, copy) HQLPasswordViewInputFinishBlock finishBlock;

/** 请求完成后显示提示信息 */
- (void)requestComplete:(BOOL)state;
- (void)requestComplete:(BOOL)state message:(NSString *)message;

@end
