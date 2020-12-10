//
//  UUIDManager.h
//  Project
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 设备 UUID 管理类
@interface UUIDManager : NSObject

/// 获取设备 UUID 唯一标识符
+ (NSString *)getKeychainUUID;

/// 删除 UUID 唯一标识符，当用户注销账户、解除绑定手机时会用到
+ (void)deleteKeychainUUID;

@end
