//
//  NSString+HQLNormalRegex.m
//  SeaTao
//
//  Created by Qilin Hu on 2020/6/5.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "NSString+HQLNormalRegex.h"

@implementation NSString (HQLNormalRegex)

- (BOOL)hql_validateByRegex:(NSString *)regex{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isMatch = [predicate evaluateWithObject:self];
    return isMatch;
}

// 正则表达式:用户名
- (BOOL)hql_isUsernameValidate {
    NSString *regex = @"^[a-zA-Z0-9~!@#%&*.,_?/\\\\]{6,36}$";
    return [self hql_validateByRegex:regex];
}

// 正则表达式:密码
- (BOOL)hql_isPasswordValidate {
    NSString *regex = @"^[a-zA-Z0-9~!@#%&*.,_?/\\\\]{6,36}$";
    return [self hql_validateByRegex:regex];
}

// 正则表达式:姓名
- (BOOL)hql_isNameValidate {
    NSString *regex = @"^[\\u4e00-\\u9fa5|.|·]{1,}$";
    return [self hql_validateByRegex:regex];
}

// 正则表达式:身份证号码，仅支持 18 位身份证号码
- (BOOL)hql_isIdNumberValidate {
    NSString *regex = @"^\\d{17}(\\d|X|x)$";
    return [self hql_validateByRegex:regex];
}

// 正则表达式:手机号
- (BOOL)hql_isMobileNumberValidate {
    NSString *regex = @"^1[3-9]\\d{9}$";
    return [self hql_validateByRegex:regex];
}

// 正则表达式:验证码
- (BOOL)hql_isCaptchaValidate {
     NSString *regex = @"^\\d{4,6}$";
    return [self hql_validateByRegex:regex];
}

@end
