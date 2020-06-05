//
//  DCCheckRegular.h
//  CDDKit
//
//  Created by 陈甸甸 on 2017/10/8.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

/**
 正则表达式，又称正规表示法，是对字符串操作的一种逻辑公式。正则表达式可以检测给定的
 字符串是否符合我们定义的逻辑，也可以从字符串中获取我们想要的特定部分。它可以迅速地
 用极简单的方式达到字符串的复杂控制。
 
 其他参考：JKCategory - NSString+JKNormalRegex.h
 */


#import <Foundation/Foundation.h>

@interface DCCheckRegular : NSObject

// 邮箱号
+ (BOOL)dc_checkMailInput:(NSString *)mail;

// 手机号
+ (BOOL)dc_checkTelNumber:(NSString *)telNumber;

// 车牌号
+ (BOOL)dc_checkCarNumber:(NSString *)CarNumber;

// 昵称
+ (BOOL)dc_checkNickname:(NSString *)nickname;

// 用户密码6-18位数字和字母组合
+ (BOOL)dc_checkPassword:(NSString *)password;

// 用户身份证号
+ (BOOL)dc_checkUserIdCard: (NSString *)idCard;

// 员工号,12位的数字
+ (BOOL)dc_checkEmployeeNumber : (NSString *)number;

// URL
+ (BOOL)dc_checkURL : (NSString *)url;

// 以C开头的18位字符
+ (BOOL)dc_checkCtooNumberTo18:(NSString *)nickNumber;

// 以C开头字符
+ (BOOL)dc_checkCtooNumber:(NSString *)nickNumber;

// 银行卡号
+ (BOOL)dc_checkBankNumber:(NSString *)bankNumber;

// 数字和字母
+ (BOOL)dc_checkTeshuZifuNumber:(NSString *)CheJiaNumber;

@end
