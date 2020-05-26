//
//  UUIDKeychain.h
//  Project
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

/// KeyChain 钥匙串管理器
@interface UUIDKeychain : NSObject

/// 将数据保存到钥匙串
/// @param uuidStr 要保存的 UUID 字符串
/// @param key 数据的 key
+ (void)saveUUIDString:(NSString *)uuidStr forKey:(NSString *)key;

/// 通过 key 从钥匙串中获取之前保存的数据
/// @param key 要获取的数据的 key
+ (NSString *)loadUUIDStringForKey:(NSString *)key;

/// 删除钥匙串中之前保存的数据
/// @param key 要删除的数据的 key
+ (void)deleteKey:(NSString *)key;

@end
