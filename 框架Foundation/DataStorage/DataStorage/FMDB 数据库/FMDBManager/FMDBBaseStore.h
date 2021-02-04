//
//  FMDBBaseStore.h
//  SeaTao
//
//  Created by Qilin Hu on 2021/1/14.
//  Copyright © 2021 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDBManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMDBBaseStore : NSObject

// 数据库操作队列（从 FMDBManager 获取，默认使用 commonQueue）
@property (nonatomic, weak) FMDatabaseQueue *databaseQueue;

/// 创建表
- (BOOL)createTable:(NSString *)tableName withSQL:(NSString *)sql;

/// 执行带数组参数的 SQL 语句（增、删、改）
- (BOOL)executeUpdate:(NSString *)sql withArgumentsInArray:(NSArray *)arguments;

/// 执行带字典参数的 SQL 语句（增、删、改）
- (BOOL)executeUpdate:(NSString *)sql withParameterDictionary:(NSDictionary *)arguments;

/// 执行格式化的 SQL 语句（增、删、改）
- (BOOL)executeUpdate:(NSString*)sql, ...;

- (void)executeQuery:(NSString*)sql resultBlock:(void(^)(FMResultSet *result))resultBlock;

@end

NS_ASSUME_NONNULL_END
