//
//  CFileUtile.h
//  CoolLibrary
//
//  Created by Chentao on 16/3/5.
//  Copyright © 2016年 Chentao. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const UserInfo_Directory;
extern NSString *const UserInfo_FileName;

@interface CFileUtils : NSObject

+ (NSString *)userpath;

+ (NSString *)getMD5WithData:(NSData *)data;

+ (NSString *)getFileMD5WithPath:(NSString *)path;

@end
