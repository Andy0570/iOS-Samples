//
//  HQLValidateDataTool.m
//  XuZhouSS
//
//  Created by ToninTech on 2017/6/2.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import "HQLValidateDataTool.h"

@implementation HQLValidateDataTool

#pragma mark - Public

// 正则表达式:用户名 任意字符：@"^.{6,20}$"、@"^[a-zA-Z0-9~!@#%&*.,_?/\\\\]{6,20}$"
+ (BOOL)validateUserName:(NSString *)username {
    NSString *regex = @"^.{6,20}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:username];
}

// 正则表达式:密码
+ (BOOL)validatePassword:(NSString *)password {
    NSString *regex = @"^[a-zA-Z0-9~!@#%&*.,_?/\\\\]{6,20}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:password];
}

// 正则表达式:身份证号码
+ (BOOL)validateIDNumber:(NSString *)idNumber {
    NSString *regex = @"^\\d{17}(\\d|X|x)$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:idNumber];
}

// 正则表达式:姓名
+ (BOOL)validateName:(NSString *)name {
    NSString *regex = @"^[\\u4e00-\\u9fa5|.|·]{2,}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:name];
}

// 正则表达式:人员识别号
+ (BOOL)validateGrdm:(NSString *)grdm {
    NSString *regex = @"^[Jj][Ss].(\\d+)(\\d|X|x)$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:grdm];
}

// 正则表达式:手机号
+ (BOOL)validatePhoneNumber:(NSString *)number {
    NSString *regex = @"^1(3|4|5|7|8)\\d{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:number];
}

// 正则表达式:验证码
+ (BOOL)validateVerificationCode:(NSString *)code {
    NSString *regex = @"^\\d{4}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:code];
}

// 正则表达式：纯数字
+ (BOOL)validateNumber:(NSString *)number {
    NSString *regex = @"^(\\d){6,20}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:number];
}

// 正则表达式:个人代码
// \w 所有的文字数字式字符：大小写字母、数字和下划线 (同 [a-zA-Z0-9_]) 缴费主体编号 @"^\\w+$"
+ (BOOL)validatePersonalNumber:(NSString *)personalNumber {
    NSString *regex = @"^\\w{1,30}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:personalNumber];
}

// 正则表达式:邮政编码
+ (BOOL)validatePostCode:(NSString *)postCode {
    NSString *regex = @"^\\d{6}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:postCode];
}

@end
