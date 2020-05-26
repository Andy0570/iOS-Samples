//
//  UUIDManager.m
//  Project
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "UUIDManager.h"
#import "UUIDKeychain.h"
#import <YYKit/NSString+YYAdd.h>

// 设置 UUID 在钥匙串中的唯一标识符
static NSString *const KUUIDManagerKey = @"com.example.uuid";

@implementation UUIDManager

+ (NSString *)getKeychainUUID {
    // 尝试从钥匙串中读取存储的 UUID
    NSString *uuidString = (NSString *)[UUIDKeychain loadUUIDStringForKey:KUUIDManagerKey];
    
    // 如果钥匙串中没有，则生成一个 UUID 并用钥匙串存储
    if (!uuidString || ![uuidString isNotBlank]) {
        // 生成新的 UUID
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        // 将该 UUID 使用钥匙串存储
        [UUIDKeychain saveUUIDString:uuidString forKey:KUUIDManagerKey];
    }
    return uuidString;
}

+ (void)deleteKeychainUUID {
    [UUIDKeychain deleteKey:KUUIDManagerKey];
}

@end
