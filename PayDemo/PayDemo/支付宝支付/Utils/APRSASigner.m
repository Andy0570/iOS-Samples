//
//  APRSASigner.m
//  AliSDKDemo
//
//  Created by antfin on 17-10-24.
//  Copyright (c) 2017年 AntFin. All rights reserved.
//

#import "APRSASigner.h"
#import "openssl_wrapper.h"

@interface APRSASigner()

@property(nonatomic, copy) NSString *privateKey;

@end

@implementation APRSASigner

- (id)initWithPrivateKey:(NSString *)privateKey
{
	if (self = [super init]) {
		_privateKey = [privateKey copy];
	}
	return self;
}

- (NSString *)signString:(NSString *)string  withRSA2:(BOOL)rsa2
{
	// 在Document文件夹下创建私钥文件，并将秘钥写入文件
	NSString * signedString = nil;
	NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *path = [documentPath stringByAppendingPathComponent:@"AlixPay-RSAPrivateKey"];
	NSString *formatKey = [self formatPrivateKey:_privateKey];
	[formatKey writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
	
    // 开始执行签名
	const char *msg = [string cStringUsingEncoding:NSUTF8StringEncoding];
    int msg_len = (int)strlen(msg);
    unsigned char *sig = (unsigned char *)malloc(256);
	unsigned int sig_len = 0;
    int ret = rsa_sign_with_private_key_pem((char *)msg, msg_len, sig, &sig_len, (char *)[path UTF8String], rsa2);
    
	// 签名成功,需要给签名字符串base64编码和UrlEncode,该两个方法也可以根据情况替换为自己函数
    if (ret == 1) {
        NSString * base64String = base64StringFromData([NSData dataWithBytes:sig length:sig_len]);
		signedString = [self urlEncodedString:base64String];
    }
	
    // 清理内存
	free(sig);
    return signedString;
}

- (NSString *)formatPrivateKey:(NSString *)privateKey
{
    const char *pstr = [privateKey UTF8String];
    int len = (int)[privateKey length];
    NSMutableString *result = [NSMutableString string];
    [result appendString:@"-----BEGIN PRIVATE KEY-----\n"];
    int index = 0;
    int count = 0;
    while (index < len) {
        char ch = pstr[index];
        if (ch == '\r' || ch == '\n') {
            ++index;
            continue;
        }
        [result appendFormat:@"%c", ch];
        if (++count == 79)
        {
            [result appendString:@"\n"];
            count = 0;
        }
        index++;
    }
    [result appendString:@"\n-----END PRIVATE KEY-----"];
    return result;
}

- (NSString*)urlEncodedString:(NSString *)string
{
    NSCharacterSet *charset = [[NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"]invertedSet];
    NSString *encodedString = [string stringByAddingPercentEncodingWithAllowedCharacters:charset];
    return encodedString;
}

@end
