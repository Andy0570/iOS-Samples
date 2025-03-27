//
//  NSString+HQLRegex.h
//  SeaTao
//
//  Created by Qilin Hu on 2021/3/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 正则表达式工具类，基于 RegexKitLite 框架！
/// <http://regexkit.sourceforge.net/Documentation/index.html>
@interface NSString (HQLRegex)

/// 用户名
- (BOOL)hql_isValidUsername;

/// 密码
- (BOOL)hql_isValidPassword;

/// 强密码（必须包含大小写字母和数字的组合，不能使用特殊字符，长度在6-64之间）
- (BOOL)hql_isValidStrongPassword;

/// 姓名
- (BOOL)hql_isValidName;

/// 身份证号码，仅支持 18 位身份证号码
- (BOOL)hql_isValidIdNumber;

/// 手机号
- (BOOL)hql_isValidPhoneNumber;

/// 4～6 位短信验证码
- (BOOL)hql_isValidCaptcha;

/// 邮政编码
- (BOOL)hql_isValidPostCode;

/// 邮箱
- (BOOL)hql_isValidEmail;

/// URL 链接
- (BOOL)hql_isValidURL;

/// 银行卡号
- (BOOL)hql_isValidBankNumber;

/// 车牌号
- (BOOL)hql_isValidCarNumber;

/// 江苏省社保卡人员识别号
- (BOOL)hql_isValidGrdm;

/// 6~20 位纯数字
- (BOOL)hql_isValidNumber;

@end

NS_ASSUME_NONNULL_END
