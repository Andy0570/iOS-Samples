//
//  NSString+HQLRegex.m
//  SeaTao
//
//  Created by Qilin Hu on 2021/3/24.
//

#import "NSString+HQLRegex.h"
#import <RegexKitLite.h>

@implementation NSString (HQLRegex)

/// 用户名
- (BOOL)hql_isValidUsername {
    NSString *regex = @"^[a-zA-Z0-9~!@#%&*.,_?/\\\\]{6,36}$";
    return [self isMatchedByRegex:regex];
}

/// 密码
- (BOOL)hql_isValidPassword {
    NSString *regex = @"^[a-zA-Z0-9~!@#%&*.,_?/\\\\]{6,36}$";
    return [self isMatchedByRegex:regex];
}

/// 强密码（必须包含大小写字母和数字的组合，不能使用特殊字符，长度在6-64之间）
- (BOOL)hql_isValidStrongPassword {
    //NSString *regex = @"^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{6,64}$";
    NSString *regex = @"^[a-zA-Z0-9~!@#%&*.,_?/\\\\]{6,36}$";
    return [self isMatchedByRegex:regex];
}

/// 姓名
- (BOOL)hql_isValidName {
    NSString *regex = @"^[\\u4e00-\\u9fa5|.|·]{2,}$";
    return [self isMatchedByRegex:regex];
}

/// 身份证号码，仅支持 18 位身份证号码
- (BOOL)hql_isValidIdNumber {
    NSString *regex = @"^\\d{17}(\\d|X|x)$";
    return [self isMatchedByRegex:regex];
}

/// 手机号
- (BOOL)hql_isValidPhoneNumber {
    NSString *regex = @"^1[3-9]\\d{9}$";
    return [self isMatchedByRegex:regex];
}

/// 4～6 位短信验证码
- (BOOL)hql_isValidCaptcha {
    NSString *regex = @"^\\d{4,6}$";
    return [self isMatchedByRegex:regex];
}

/// 邮政编码
- (BOOL)hql_isValidPostCode {
    NSString *regex = @"^\\d{6}$";
    return [self isMatchedByRegex:regex];
}

/// 邮箱
- (BOOL)hql_isValidEmail {
    NSString *regex = @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";
    return [self isMatchedByRegex:regex];
}

/// URL 链接
- (BOOL)hql_isValidURL {
    NSString *regex = @"\\b(https?)://(?:(\\S+?)(?::(\\S+?))?@)?([a-zA-Z0-9\\-.]+)"
                      @"(?::(\\d+))?((?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    return [self isMatchedByRegex:regex];
}

/// 银行卡号
- (BOOL)hql_isValidBankNumber {
    NSString *regex = @"^([0-9]{16}|[0-9]{19})$";
    return [self isMatchedByRegex:regex];
}

/// 车牌号
- (BOOL)hql_isValidCarNumber {
    NSString *regex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    return [self isMatchedByRegex:regex];
}

/// 江苏省社保卡人员识别号
- (BOOL)hql_isValidGrdm {
    NSString *regex = @"^[Jj][Ss].(\\d+)(\\d|X|x)$";
    return [self isMatchedByRegex:regex];
}

/// 6~20 位纯数字
- (BOOL)hql_isValidNumber {
    NSString *regex = @"^(\\d){6,20}$";
    return [self isMatchedByRegex:regex];
}

@end
