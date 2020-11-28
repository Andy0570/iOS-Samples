//
//  NSString+HQLNormalRegex.m
//  SeaTao
//
//  Created by Qilin Hu on 2020/6/5.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "NSString+HQLNormalRegex.h"

@implementation NSString (HQLNormalRegex)

// 通用方法
- (BOOL)hql_validateByRegex:(NSString *)regex{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isMatch = [predicate evaluateWithObject:self];
    return isMatch;
}

// 用户名
// 任意字符：@"^.{6,20}$"
- (BOOL)hql_isUsernameValidate {
    NSString *regex = @"^[a-zA-Z0-9~!@#%&*.,_?/\\\\]{6,36}$";
    return [self hql_validateByRegex:regex];
}

// 密码
- (BOOL)hql_isPasswordValidate {
    NSString *regex = @"^[a-zA-Z0-9~!@#%&*.,_?/\\\\]{6,36}$";
    return [self hql_validateByRegex:regex];
}

// 姓名
- (BOOL)hql_isNameValidate {
    NSString *regex = @"^[\\u4e00-\\u9fa5|.|·]{2,}$";
    return [self hql_validateByRegex:regex];
}

// 身份证号码，仅支持 18 位身份证号码
- (BOOL)hql_isIdNumberValidate {
    NSString *regex = @"^\\d{17}(\\d|X|x)$";
    return [self hql_validateByRegex:regex];
}

// 手机号
- (BOOL)hql_isMobileNumberValidate {
    NSString *regex = @"^1[3-9]\\d{9}$";
    return [self hql_validateByRegex:regex];
}

// 短信验证码
- (BOOL)hql_isCaptchaValidate {
     NSString *regex = @"^\\d{4,6}$";
    return [self hql_validateByRegex:regex];
}

// 邮政编码
- (BOOL)hql_isPostCodeValidate:(NSString *)postCode {
    NSString *regex = @"^\\d{6}$";
    return [self hql_validateByRegex:regex];
}

// 邮箱
- (BOOL)hql_isEmailValidate:(NSString *)email {
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self hql_validateByRegex:regex];
}

// URL 链接
- (BOOL)hql_isURLValidate:(NSString *)url {
    NSString *regex = @"^[0-9A-Za-z]{1,50}";
    return [self hql_validateByRegex:regex];
}

// 银行卡号
- (BOOL)hql_isBankNumberValidate:(NSString *)bankNumber {
    NSString *regex = @"^([0-9]{16}|[0-9]{19})$";
    return [self hql_validateByRegex:regex];
}

// 车牌号
- (BOOL)hql_isCarNumberValidate:(NSString *)carNumber {
    NSString *regex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    return [self hql_validateByRegex:regex];
}

// 江苏省社保卡人员识别号
- (BOOL)hql_isGrdmValidate {
    NSString *regex = @"^[Jj][Ss].(\\d+)(\\d|X|x)$";
    return [self hql_validateByRegex:regex];
}

// 6~20 位纯数字
- (BOOL)hql_isNumberValidate:(NSString *)number {
    NSString *regex = @"^(\\d){6,20}$";
    return [self hql_validateByRegex:regex];
}

@end
