//
//  HQLValidateDataTool.h
//  XuZhouSS
//
//  Created by ToninTech on 2017/6/2.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 正则表达式工具类
 */
@interface HQLValidateDataTool : NSObject

/** 正则表达式:用户名 */
+ (BOOL)validateUserName:(NSString *)username;

/** 正则表达式:密码 */
+ (BOOL)validatePassword:(NSString *)password;

/** 正则表达式:身份证号码 */
+ (BOOL)validateIDNumber:(NSString *)idNumber;

/** 正则表达式:姓名 */
+ (BOOL)validateName:(NSString *)name;

/** 正则表达式:人员识别号 */
+ (BOOL)validateGrdm:(NSString *)grdm;

/** 正则表达式:手机号 */
+ (BOOL)validatePhoneNumber:(NSString *)number;

/** 正则表达式:验证码 */
+ (BOOL)validateVerificationCode:(NSString *)code;

/** 正则表达式：纯数字6~20个 */
+ (BOOL)validateNumber:(NSString *)number;

/** 正则表达式:个人代码 */
+ (BOOL)validatePersonalNumber:(NSString *)personalNumber;

/** 正则表达式:邮政编码 */
+ (BOOL)validatePostCode:(NSString *)postCode;

@end
