//
//  NSString+HQLNormalRegex.h
//  SeaTao
//
//  Created by Qilin Hu on 2020/6/5.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (HQLNormalRegex)

- (BOOL)hql_validateByRegex:(NSString *)regex;

// 正则表达式:用户名
- (BOOL)hql_isUsernameValidate;

// 正则表达式:密码
- (BOOL)hql_isPasswordValidate;

// 正则表达式:姓名
- (BOOL)hql_isNameValidate;

// 正则表达式:身份证号码，仅支持 18 位身份证号码
- (BOOL)hql_isIdNumberValidate;

// 正则表达式:手机号
- (BOOL)hql_isMobileNumberValidate;

// 正则表达式:验证码
- (BOOL)hql_isCaptchaValidate;

@end

NS_ASSUME_NONNULL_END
