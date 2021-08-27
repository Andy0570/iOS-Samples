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
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation HQLRegixViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Actions

- (IBAction)testButtionAction:(id)sender {
     [self example100];
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

#pragma mark - 使用 RegexKitLite 框架

// 通过 isMatchedByRegex: 方法验证 email 是否合法
- (void)regexKitLiteFunction1 {
    NSString *email = @"andywhm@163.com";
    
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    if ([email isMatchedByRegex:emailRegex]) {
        [self.view makeToast:@"匹配"];
    } else {
        [self.view makeToast:@"不匹配"];
    }
}

/**
 - (NSString *)stringByMatching:(NSString *)regex capture:(NSInteger)capture
 
 regex 表示正则表达式，capture 表示匹配选项
 capture 为 0 时，表示返回第一次匹配的字符串，带完全匹配的结果
 capture 为 1 时，表示返回第一次匹配的结果中第一处模糊匹配的子字符串
 capture 为 2 时，表示返回第一次匹配的结果中第二处模糊匹配，依次类推。

 */
- (void)regexKitLiteFunction2 {
    //获取 oauth_token、oauth_token_secret 与 name 的值
    NSString *htmlStr = @"oauth_token=1a1de4ed4fca40599c5e5cfe0f4fba97&oauth_token_secret=3118a84ad910967990ba50f5649632fa&name=foolshit";
    NSString *regexString = @"oauth_token=(\\w+)&oauth_token_secret=(\\w+)&name=(\\w+)";
    // 返回第一次匹配的结果,带完全匹配的字符
    NSString *matchedString1 = [htmlStr stringByMatching:regexString capture:0L];
    // 返回第一次匹配的结果中第 1 处模糊匹配，不带完全匹配的字符中
    // 1a1de4ed4fca40599c5e5cfe0f4fba97
    NSString *matchedString2 = [htmlStr stringByMatching:regexString capture:1L];
    // 返回第一次匹配的结果中第 2 处模糊匹配，
    // 3118a84ad910967990ba50f5649632fa
    NSString *matchedString3 = [htmlStr stringByMatching:regexString capture:2L];
    // 返回第一次匹配的结果中第 3 处模糊匹配
    // foolshit
    NSString *matchedString4 = [htmlStr stringByMatching:regexString capture:3L];

    NSLog(@"%@",matchedString1);
    NSLog(@"%@",matchedString2);
    NSLog(@"%@",matchedString3);
    NSLog(@"%@",matchedString4);

    htmlStr = @"0_T123F_0_T2F_0_T3F_0";
    NSString *regex = @"T123F";
    NSString *result = [htmlStr stringByMatching:regex capture:0L];
    NSLog(@"匹配结果:%@",result); // 匹配结果:T123F
}

// RegexKitLite 框架中的其他方法
/**
 // 该方法通过 Regex 进行字符串的比对，并且会将第一组比对出来的结果以 NSArray 返回
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

// 找出格式为 nnn-nnn-nnnn 的电话号码
- (void)example1 {
    NSRange r;
    NSString *regEx =@"[0-9]{3}-[0-9]{3}-[0-9]{4}";
    r = [self.textView.text rangeOfString:regEx options:NSRegularExpressionSearch];
    if (r.location != NSNotFound) {
        NSLog(@"Phone number is %@", [self.textView.text substringWithRange:r]);
    } else {
        NSLog(@"Not found.");
    }
}

// 找出格式为 nnn-nnn-nnnn 的电话号码
- (void)example12 {
    NSString *regEx =@"[0-9]{3}-[0-9]{3}-[0-9]{4}";
    NSString *match = [self.textView.text stringByMatching:regEx];
    if (![match isEqualToString:@""]) {
        NSLog(@"Phone number is %@", match);
    } else {
        NSLog(@"Not found.");
    }
}

// 找出格式为 nnn-nnn-nnnn 的电话号码
- (void)example13 {
    NSString *regEx =@"[0-9]{3}-[0-9]{3}-[0-9]{4}";
    for (NSString *match in [self.textView.text componentsMatchedByRegex:regEx]) {
        NSLog(@"Phone number is %@", match);
    }
}

- (void)example14 {
    // 找出格式为 nnn-nnn-nnnn 的电话号码
    NSString *regEx =@"([0-9]{3})-([0-9]{3}-[0-9]{4})";
    // 并将电话号码格式替换为 (nnn) nnn-nnnn
    NSString *replaced = [self.textView.text stringByReplacingOccurrencesOfRegex:regEx withString:@"($1) $2"];
    NSLog(@"replace phone number is:%@",replaced);
    // hhhhjvh(123) 124-13455hhh
}

// MARK: 查找匹配的范围
- (void)example21 {
    NSString *searchString = @"This is neat.";
    NSString *regexString = @"(\\w+)\\s+(\\w+)\\s+(\\w+)";
    NSRange searchRange = NSMakeRange(0, searchString.length);
    NSRange matchRange = NSMakeRange(NSNotFound, 0UL);
    NSError *error;
    
    matchRange = [searchString rangeOfRegex:regexString
                                    options:RKLNoOptions
                                    inRange:searchRange
                                    capture:2L
                                      error:&error];
    
    NSLog(@"matchedRange: %@", NSStringFromRange(matchRange));
    // matchedRange: {5, 2}
    
    NSString *matchedString = [searchString substringWithRange:matchRange];
    NSLog(@"matchString: '%@'", matchedString);
    // matchString: 'is'
}

- (void)example22 {
    NSString *searchString = @"This is neat.";
    NSString *regexString = @"(\\w+)\\s+(\\w+)\\s+(\\w+)";
    
    NSString *matchedString = [searchString stringByMatching:regexString capture:2L];
    
    NSLog(@"matchString: '%@'", matchedString);
    // matchString: 'is'
}

// MARK: 搜索和替换
- (void)example31 {
    NSString *searchString = @"This is neat.";
    NSString *regexString = @"\\b(\\w+)\\b";
    NSString *replaceWithString = @"{$1}";
    NSString *replacedString = NULL;
    
    replacedString = [searchString stringByReplacingOccurrencesOfRegex:regexString
                                                            withString:replaceWithString];
    
    NSLog(@"replaced string: '%@'", replacedString);
    // replaced string: '{This} {is} {neat}.'
}

- (void)example32 {
    NSString *regexString = @"\\b(\\w+)\\b";
    NSString *replaceWithString = @"{$1}";
    NSUInteger replacedCount = 0UL;
    
    NSMutableString *mutableString = [NSMutableString stringWithString:@"This is neat."];
    
    replacedCount = [mutableString replaceOccurrencesOfRegex:regexString withString:replaceWithString];
    
    NSLog(@"Count: %ld string: '%@'", (u_long)replacedCount, mutableString);
    // Count: 3 string: '{This} {is} {neat}.'
}

- (void)example33 {
    
    NSString *searchString = @"This is neat.";
    NSString *regexString = @"\\b(\\w+)\\b";
    NSString *replacedString = NULL;
    
    replacedString = [searchString stringByReplacingOccurrencesOfRegex:regexString usingBlock:^NSString *(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        return [NSString stringWithFormat:@"{%@}", [capturedStrings[1] capitalizedString]];
    }];
    
    NSLog(@"%@",replacedString);
    // {This} {Is} {Neat}.
}

- (void)example41 {
    NSString *searchString = @"This is neat.";
    NSString *regexString = @"\\s+";
    NSArray *splitArray = NULL;
    
    splitArray = [searchString componentsSeparatedByRegex:regexString];
    NSLog(@"splitArray:%@", splitArray);
    /**
     splitArray:    (
         "This",
         "is",
         "neat.",
     )
     */
}

- (void)example51 {
    NSString *searchString = @"$10.23, $1024.42, $3099";
    NSString *regexString = @"\\$((\\d+)(?:\\.(\\d+)|\\.?))";
    NSArray *matchArray = NULL;
    
    matchArray = [searchString componentsMatchedByRegex:regexString];
    
    NSLog(@"matchArray:%@",matchArray);
    /**
     matchArray:    (
         "$10.23",
         "$1024.42",
         "$3099",
     )
     */
}


- (void)example52 {
    NSString *searchString = @"$10.23, $1024.42, $3099";
    NSString *regexString = @"\\$((\\d+)(?:\\.(\\d+)|\\.?))";
    NSArray *capturesArray = NULL;
    
    capturesArray = [searchString arrayOfCaptureComponentsMatchedByRegex:regexString];
    NSLog(@"capturesArray:%@",capturesArray);
    /**
     (
             (
             "$10.23",
             "10.23",
             "10",
             "23",
         ),
             (
             "$1024.42",
             "1024.42",
             "1024",
             "42",
         ),
             (
             "$3099",
             "3099",
             "3099",
             "",
         ),
     )
     */
}

- (void)example61 {
    
    NSString *searchString = @"one\ntwo\n\nfour\n";
    NSString *regexString = @"(?m)^.*$";
    NSArray *matchArray = NULL;
    NSEnumerator *matchEnumerator = NULL;
    NSString *matchedString = NULL;
    NSUInteger line = 0UL;
    
    matchArray = [searchString componentsMatchedByRegex:regexString];
    matchEnumerator = [matchArray objectEnumerator];
    
    while ((matchedString = [matchEnumerator nextObject]) != nil) {
        NSLog(@"%lu: %lu '%@'", ++line, [matchedString length], matchedString);
    }
}

- (void)example62 {
    NSString *searchString = @"one\ntwo\n\nfour\n";
    NSString *regexString = @"(?m)^.*$";
    NSUInteger line = 0UL;
    
    for (NSString *matchedString in [searchString componentsMatchedByRegex:regexString]) {
        NSLog(@"%lu: %lu '%@'", ++line, [matchedString length], matchedString);
    }
}

- (void)example63 {
    NSString *searchString = @"one\ntwo\n\nfour\n";
    NSString *regexString = @"(?m)^.*$";
    __block NSUInteger line = 0UL;
    
    [searchString enumerateStringsMatchedByRegex:regexString usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        NSLog(@"%lu: %lu '%@'", ++line, [capturedStrings[0] length], capturedStrings[0]);
    }];
}

- (void)example70 {
    NSString *searchString = @"http://www.example.com:8080/index.html";
    NSString *regexString = @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?"@"(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    
    NSInteger portInteger = [[searchString stringByMatching:regexString capture:1L] integerValue];
    NSLog(@"portInteger:%ld",(long)portInteger);
    // portInteger:8080
}

- (void)example71 {
    NSString *searchString = @"The int 5542 to convert";
    NSString *regexString = @"([+\\-]?[0-9]+)";
    int matchedInt = [[searchString stringByMatching:regexString capture:1L] intValue];
}

- (void)example72 {
    NSString *searchString = @"The double 1.010489e5 to convert";
    NSString *regexString = @"([+\\-]?(?:[0-9]*\\.[0-9]+|[0-9]+\\.)"
                            @"(?:[eE][+\\-]?[0-9]+)?)";
    double matchedDouble = [[searchString stringByMatching:regexString capture:1L] doubleValue];
}


- (void)example81 {
    NSString *searchString = @"A hex value: 0x0badf00d";
    NSString *regexString  = @"\\b(0[xX][0-9a-fA-F]+)\\b";
    NSString *hexString    = [searchString stringByMatching:regexString capture:1L];
    
    // Use strtol() to convert the string to a long.
    long hexLong = strtol([hexString UTF8String], NULL, 16);
    NSLog(@"hexLong: 0x%lx / %ld", (u_long)hexLong, hexLong);
    // hexLong: 0xbadf00d / 195948557
}

- (void)example82 {
    
    NSString *fileNameString = @"example";
    NSString *regexString    = @"(?:\r\n|[\n\v\f\r\302\205\\p{Zl}\\p{Zp}])";
    NSError  *error          = NULL;
    
    NSString *fileString = [NSString stringWithContentsOfFile:fileNameString
                                                 usedEncoding:NULL
                                                        error:&error];
    
    if(fileString) {
        NSArray *linesArray = [fileString componentsSeparatedByRegex:regexString];
        for(NSString *lineString in linesArray) { // ObjC 2.0 for...in loop. // Per line processing.
        }
    } else {
        NSLog(@"Error reading file '%@'", fileNameString);
        if(error) { NSLog(@"Error: %@", error); }
    }
}

- (void)example83 {
    NSString *searchString =
                  @"http://johndoe:secret@www.example.com:8080/private/mail/index.html";
    NSString *regexString  =
                  @"\\b(https?)://(?:(\\S+?)(?::(\\S+?))?@)?([a-zA-Z0-9\\-.]+)"
                  @"(?::(\\d+))?((?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    if([searchString isMatchedByRegex:regexString]) {
        
        NSString *protocolString = [searchString stringByMatching:regexString capture:1L];
        NSString *userString     = [searchString stringByMatching:regexString capture:2L];
        NSString *passwordString = [searchString stringByMatching:regexString capture:3L];
        NSString *hostString = [searchString stringByMatching:regexString capture:4L];
        NSString *portString = [searchString stringByMatching:regexString capture:5L];
        NSString *pathString = [searchString stringByMatching:regexString capture:6L];
        
        NSMutableDictionary *urlDictionary = [NSMutableDictionary dictionary];
        if(protocolString) { [urlDictionary setObject:protocolString forKey:@"protocol"]; }
        if(userString)     { [urlDictionary setObject:userString     forKey:@"user"];     }
        if(passwordString) { [urlDictionary setObject:passwordString forKey:@"password"]; }
        if(hostString) { [urlDictionary setObject:hostString forKey:@"host"];     }
        if(portString) { [urlDictionary setObject:portString forKey:@"port"];     }
        if(pathString) { [urlDictionary setObject:pathString forKey:@"path"];     }
        
        NSLog(@"urlDictionary: %@", urlDictionary);
        /**
         urlDictionary:     {
             password = "secret",
             port = "8080",
             path = "/private/mail/index.html",
             protocol = "http",
             host = "www.example.com",
             user = "johndoe",
         }
         */
    }
}

- (void)example84 {
    NSString *searchString = @"http://johndoe:secret@www.example.com:8080/private/mail/index.html";
    NSString *regexString = @"\\b(https?)://(?:(\\S+?)(?::(\\S+?))?@)?([a-zA-Z0-9\\-.]+)"
                            @"(?::(\\d+))?((?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    
    NSDictionary *urlDictionary = NULL;
    
    urlDictionary = [searchString dictionaryByMatchingRegex:regexString
                                        withKeysAndCaptures:@"protocol", 1,
                                                            @"user",     2,
                                                            @"password", 3,
                                                            @"host",     4,
                                                            @"port",     5,
                                                            @"path",     6,
                                                            NULL];
    if(urlDictionary) {
      NSLog(@"urlDictionary: %@", urlDictionary);
    }
    /**
     {
         password = "secret",
         port = "8080",
         path = "/private/mail/index.html",
         protocol = "http",
         host = "www.example.com",
         user = "johndoe",
     }
     */
}

// MARK: 测试使用 NSSet
- (void)example100 {
    NSArray *array1 = @[@"1",@"2",@"3",@"4",@"5",@"6"];
    NSArray *array2 = @[@"4",@"5",@"6",@"7",@"8",@"9"];
    
    NSMutableSet *set1 = [NSMutableSet setWithCapacity:6];
    [set1 addObjectsFromArray:array1];
    NSSet *set2 = [NSSet setWithArray:array2];
    
    // 并集
    [set1 unionSet:set2];
    // set1: 1,2,3,4,5,6,7,8,9
    //NSLog(@"%@",set1);
    /**
     {(
             "7",
             "3",
             "8",
             "4",
             "9",
             "5",
             "1",
             "6",
             "2",
         )}
     */
    
    // 求交集
    [set1 intersectSet:set2];
    NSLog(@"%@",set1);
    // 4,5,6
    
    // 差集
    [set1 minusSet:set2];
    //NSLog(@"%@",set1);
    // 1,2,3
    
    
}


@end
