//
//  UUIDKeychain.m
//  Project
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "UUIDKeychain.h"

@implementation UUIDKeychain

#pragma mark - 保存和读取 UUID

// 获取 keyChain 字典
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword,(__bridge id)kSecClass,
            service, (__bridge id)kSecAttrService,
            service, (__bridge id)kSecAttrAccount,
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock,(__bridge id)kSecAttrAccessible, nil];
}

+ (void)saveUUIDString:(NSString *)uuidStr forKey:(NSString *)key {
    // 获取 keyChain 字典
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    // 保存新项目之前删除旧项目
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    
    // 对需要保存的数据进行归档
    NSData *archiverData;
    if (@available(iOS 12.0, *)) {
        NSError *error;
        archiverData = [NSKeyedArchiver archivedDataWithRootObject:uuidStr requiringSecureCoding:YES error:&error];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        archiverData = [NSKeyedArchiver archivedDataWithRootObject:uuidStr];
#pragma clang diagnostic pop
    }
    // 添加新对象到搜索字典
    [keychainQuery setObject:archiverData forKey:(__bridge id<NSCopying>)(kSecValueData)];
    // 使用 keyChain 字典将项目添加到钥匙串
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
    NSAssert(status == noErr, @"Couldn't Add the keychain item.");
}

+ (NSString *)loadUUIDStringForKey:(NSString *)key {
    
    id result = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    
    // 搜索配置
    // 因为在我们的简单情况下，我们期望只返回一个属性（例如密码），我们可以将属性kSecReturnData设置为kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id<NSCopying>)(kSecReturnData)];
    // kSecMatchLimitOne 表示返回一个搜索结果
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id<NSCopying>)(kSecMatchLimit)];
    
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        
        // 解档数据
        if (@available(iOS 12.0, *)) {
            result = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSString class] fromData:(__bridge NSData *)keyData error:nil];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            result = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
#pragma clang diagnostic pop
        }
    }
    if (keyData) {
        CFRelease(keyData);
    }
    return result;
}

+ (void)deleteKey:(NSString *)key {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    NSAssert( status == noErr || status == errSecItemNotFound, @"Problem deleting current dictionary." );
}

@end
