//
//  HQLRegixViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/6/5.
//  Copyright © 2020 ToninTech. All rights reserved.
//

#import "HQLRegixViewController.h"

// Frameworks
#import <Toast.h>
#import <RegexKitLite.h>

@interface HQLRegixViewController ()

@end

@implementation HQLRegixViewController


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Private

// MARK: NSPredicate 示例
- (void)testRegix {
    // 待匹配字符串
    NSString *string = @"201708----201710";
    // 正则表达式
    NSString *regix = @"^\\d{6}\\D+\\d{6}$";
    // 创建 NSPredicate 实例对象
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regix];
    // 返回正则表达式匹配结果，YES or NO
    BOOL isMatch = [predicate evaluateWithObject:string];
    NSString *result = [NSString stringWithFormat:@"result = %@",(isMatch ? @"YES" : @"NO")];

    [self.view makeToast:result duration:2.0 position:CSToastPositionCenter];
}

- (void)testStringFunction {
    
    // 待匹配字符串
    NSString *string = @"Hello World123";
    // 返回匹配到的第一个字符串范围
    NSRange range = [string rangeOfString:@"\\d+" options:NSRegularExpressionSearch];
    // 如果匹配到就打印匹配到的子字符串，在这里为123。
    if (range.location != NSNotFound){
        NSLog(@"%@",[string substringWithRange:range]);
    }
}

- (void)predicateUse {

}

// MARK: 使用 RegexKitLite 框架
// isMatchedByRegex: 方法
- (void)regexKitLiteFunction1 {
    NSString *email = @"andywhm@163.com";
    
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    if ([email isMatchedByRegex:emailRegex]) {
        [self.view makeToast:@"匹配"];
    } else {
        [self.view makeToast:@"不匹配"];
    }
}

// MARK: 使用 RegexKitLite 框架
// stringByMatching: capture:
- (void)regexKitLiteFunction2 {
    //获取 oauth_token、oauth_token_secret 与 name 的值
    NSString *htmlStr = @"oauth_token=1a1de4ed4fca40599c5e5cfe0f4fba97&oauth_token_secret=3118a84ad910967990ba50f5649632fa&name=foolshit";
    NSString *regexString = @"oauth_token=(\\w+)&oauth_token_secret=(\\w+)&name=(\\w+)";
    NSString *matchedString1 = [htmlStr stringByMatching:regexString capture:0L]; // 返回第一次匹配的结果,带完全匹配的字符
    NSString *matchedString2 = [htmlStr stringByMatching:regexString capture:1L]; // 返回第一次匹配的结果中第 1 处模糊匹配，不带完全匹配的字符中
    NSString *matchedString3 = [htmlStr stringByMatching:regexString capture:2L]; // 返回第一次匹配的结果中第 2 处模糊匹配，
    NSString *matchedString4 = [htmlStr stringByMatching:regexString capture:3L]; // 返回第一次匹配的结果中第 3 处模糊匹配，

    NSLog(@"%@",matchedString1);
    NSLog(@"%@",matchedString2);
    NSLog(@"%@",matchedString3);
    NSLog(@"%@",matchedString4);

    htmlStr = @"0_T123F_0_T2F_0_T3F_0";
    NSString *regex = @"T123F";
    NSString *result = [htmlStr stringByMatching:regex capture:0L];
    NSLog(@"匹配结果:%@",result);
}

// RegexKitLite 框架中的其他方法
/**
 // 该方法通过 Regex 进行字串的比对，并且会将第一组比对出来的结果以 NSArray 返回
 - (NSArray *)captureComponentsMatchedByRegex:(NSString *)regex;
 
 // 该方法会回传 Regex 所比对出来的字串群组，但会回传全部的配对组合
 - (NSArray *)arrayOfCaptureComponentsMatchedByRegex:(NSString *)regex;
 
 // 将字串中与 Regex 配对的结果进行替换
 - (NSString *)stringByReplacingOccurrencesOfRegex:(NSString *)regex withString:(NSString *)replacement;
 */

// 校验 URL 合法性
- (void)testUrlIsValidate {
    NSURL *url = [NSURL URLWithString:@"https://example.com"];
    BOOL isUrlValid = url && [url scheme] && [url host];
    if (isUrlValid) {
        NSLog(@"url = %@, scheme = %@, host = %@",url, [url scheme], [url host]);
        // url = https://example.com, scheme = https, host = example.com
    }
}

// 通过正则表达式校验 URL 合法性
- (void)validateURLByRegex {
    NSURL *url = [NSURL URLWithString:@"https://example.com"];
    NSString *urlString = url.absoluteString;
    
    // 正则表达式
    NSString *regex = @"^((http)|(https))+:[^\\s]+\\.[^\\s]*$";
    // 创建 NSPredicate 实例对象
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    // 返回正则表达式匹配结果，YES or NO
    BOOL isMatch = [predicate evaluateWithObject:urlString];
    NSString *result = [NSString stringWithFormat:@"result = %@",(isMatch ? @"YES" : @"NO")];

    [self.view makeToast:result duration:2.0 position:CSToastPositionCenter];
}

// 测试输入的密码是否包含一个大写字母
- (void)testIsContainsUppercaseCharacters {
    NSString *password = @"123456A1";
    BOOL isMatch = [password isMatchedByRegex:@"[A-Z]+"];
    NSString *result = [NSString stringWithFormat:@"result = %@",(isMatch ? @"YES" : @"NO")];
    [self.view makeToast:result duration:2.0 position:CSToastPositionCenter]; // YES
}

#pragma mark - Actions

- (IBAction)testButtionAction:(id)sender {
    // [self validateURLByRegex];
}


@end
