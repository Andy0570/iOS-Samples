//
//  IMUser.m
//  DataStorage
//
//  Created by Qilin Hu on 2021/8/5.
//

#import "IMUser.h"
#import <YYKit.h>
#import <WCDB/WCDB.h>

@implementation IMUser

// 使用 WCDB_IMPLEMENTATION 宏在「类文件」定义绑定到数据库表的类
WCDB_IMPLEMENTATION(IMUser)

// 使用 WCDB_SYNTHESIZE 宏在「类文件」定义需要绑定到数据库表的字段
WCDB_SYNTHESIZE(IMUser, userId)
WCDB_SYNTHESIZE(IMUser, name)
WCDB_SYNTHESIZE(IMUser, gender)
WCDB_SYNTHESIZE(IMUser, age)
WCDB_SYNTHESIZE(IMUser, telephone)

// WCDB_PRIMARY 定义主键
WCDB_PRIMARY(IMUser, userId)

// WCDB_UNIQUE 定义唯一约束
WCDB_UNIQUE(IMUser, userId)

// WCDB_NOT_NULL 定义非空约束
WCDB_NOT_NULL(IMUser, userId)
WCDB_NOT_NULL(IMUser, name)

#pragma mark - Override

- (void)encodeWithCoder:(NSCoder *)coder {
    [self modelEncodeWithCoder:coder];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    return [self modelInitWithCoder:coder];
}

- (id)copyWithZone:(NSZone *)zone {
    return [self modelCopy];
}

- (NSUInteger)hash {
    return [self modelHash];
}

- (BOOL)isEqual:(id)object {
    return [self modelIsEqual:object];
}

- (NSString *)description {
    return [self modelDescription];
}

@end
