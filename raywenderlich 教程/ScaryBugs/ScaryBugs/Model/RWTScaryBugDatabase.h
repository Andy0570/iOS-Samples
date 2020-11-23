//
//  RWTScaryBugDatabase.h
//  ScaryBugs
//
//  Created by Qilin Hu on 2020/11/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RWTScaryBugDatabase : NSObject

// 返回数组：存放的是 Scary bug 文件夹名称：../Library/Private Documents/#.scarybug
+ (NSMutableArray *)loadScaryBugDocs;

// 下一个可获得到路径
+ (NSString *)nextScaryBugDocPath;

@end

NS_ASSUME_NONNULL_END
