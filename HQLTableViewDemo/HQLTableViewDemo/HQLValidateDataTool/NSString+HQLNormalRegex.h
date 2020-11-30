//
//  NSString+HQLNormalRegex.h
//  SeaTao
//
//  Created by Qilin Hu on 2020/6/5.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 正则表达式扩展类
@interface NSString (HQLNormalRegex)

/// 通用方法
- (BOOL)hql_validateByRegex:(NSString *)regex;

/// 用户名
- (BOOL)hql_isUsernameValidate;

/// 密码
- (BOOL)hql_isPasswordValidate;

/// 强密码，至少 8 个字符，至少 1 个大写字母，1 个小写字母和 1 个数字，其他可以是任意字符
- (BOOL)hql_isStrongPasswordValidate;

/// 姓名
- (BOOL)hql_isNameValidate;

/// 身份证号码，仅支持 18 位身份证号码
- (BOOL)hql_isIdNumberValidate;

/// 手机号
- (BOOL)hql_isMobileNumberValidate;

/// 4～6 位短信验证码
- (BOOL)hql_isCaptchaValidate;

/// 邮政编码
- (BOOL)hql_isPostCodeValidate:(NSString *)postCode;

/// 邮箱
- (BOOL)hql_isEmailValidate:(NSString *)email;

/// URL 链接
- (BOOL)hql_isURLValidate:(NSString *)url;

/// 银行卡号
- (BOOL)hql_isBankNumberValidate:(NSString *)bankNumber;

/// 车牌号
- (BOOL)hql_isCarNumberValidate:(NSString *)carNumber;

/// 江苏省社保卡人员识别号
- (BOOL)hql_isGrdmValidate;

/// 6~20 位纯数字
- (BOOL)hql_isNumberValidate:(NSString *)number;

@end

NS_ASSUME_NONNULL_END
