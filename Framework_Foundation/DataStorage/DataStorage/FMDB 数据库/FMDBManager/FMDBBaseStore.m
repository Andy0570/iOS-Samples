//
//  FMDBBaseStore.m
//  SeaTao
//
//  Created by Qilin Hu on 2021/1/14.
//  Copyright © 2021 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "FMDBBaseStore.h"

@implementation FMDBBaseStore

#pragma mark - Initialize

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }
    
    self.databaseQueue = [[FMDBManager sharedInstance] commonQueue];
    return self;
}

#pragma mark - Public

/// 创建表
- (BOOL)createTable:(NSString *)tableName withSQL:(NSString *)sql {
    __block BOOL result = YES;
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if (![db tableExists:tableName]) {
            result = [db executeUpdate:sql];
        }
    }];
    return result;
}

/// 执行带数组参数的 SQL 语句（增、删、改）
- (BOOL)executeUpdate:(NSString *)sql withArgumentsInArray:(NSArray *)arguments {
    __block BOOL result = YES;
    if (self.databaseQueue) {
        [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
            result = [db executeUpdate:sql withArgumentsInArray:arguments];
        }];
    }
    return result;
}

/// 执行带字典参数的 SQL 语句（增、删、改）
- (BOOL)executeUpdate:(NSString *)sql withParameterDictionary:(NSDictionary *)arguments {
    __block BOOL result = YES;
    if (self.databaseQueue) {
        [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
            result = [db executeUpdate:sql withParameterDictionary:arguments];
        }];
    }
    return result;
}

/// 执行格式化的 SQL 语句（增、删、改）
- (BOOL)executeUpdate:(NSString*)sql, ... {
    __block BOOL result = YES;
    if (self.databaseQueue) {
        va_list args;
        va_list *p_args;
        p_args = &args;
        va_start(args, sql);
        [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
            result = [db executeUpdate:sql withVAList:*p_args];
        }];
        va_end(args);
    }
    return result;
}

- (void)executeQuery:(NSString*)sql resultBlock:(void(^)(FMResultSet *result))resultBlock {
    if (self.databaseQueue) {
        [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
            FMResultSet *resultSet = [db executeQuery:sql];
            if (resultBlock) {
                resultBlock(resultSet);
            }
        }];
    }
}

@end
