//
//  HQLScaryBugDatabase.h
//  ScaryBugs
//
//  Created by Qilin Hu on 2018/1/2.
//  Copyright © 2018年 Qilin Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HQLScaryBugDatabase : NSObject

// 返回数组：存放的是 Scary bug 文件夹名称：../Library/Private Documents/#.scarybug
+ (NSMutableArray *)loadScaryBugDocs;

// 下一个可获得到路径
+ (NSString *)nextScaryBugDocPath;

@end
