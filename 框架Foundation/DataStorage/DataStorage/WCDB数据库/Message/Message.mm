//
//  Message.m
//  DataStorage
//
//  Created by Qilin Hu on 2021/1/15.
//

#import "Message.h"
#import <WCDB/WCDB.h>

@implementation Message

// 使用 WCDB_IMPLEMENTATION 宏在「类文件」定义绑定到数据库表的类
WCDB_IMPLEMENTATION(Message)

// 使用 WCDB_SYNTHESIZE 宏在「类文件」定义需要绑定到数据库表的字段
WCDB_SYNTHESIZE(Message, localID)
WCDB_SYNTHESIZE(Message, content)
WCDB_SYNTHESIZE(Message, createTime)
WCDB_SYNTHESIZE(Message, modifiedTime)

// 将数据库表的字段与类的属性名进行映射
// WCDB_SYNTHESIZE_COLUMN(Message, localID, "db_id")
// WCDB_SYNTHESIZE_COLUMN(Message, content, "db_content")

// WCDB_PRIMARY 定义主键
WCDB_PRIMARY(Message, localID)

// WCDB_PRIMARY_AUTO_INCREMENT 定义主键且自增
// Auto-increment 会在新记录插入表中时生成一个唯一的数字。
//WCDB_PRIMARY_AUTO_INCREMENT(Message, localID)

// WCDB_INDEX 定义索引
// 索引：CREATE INDEX message_index ON message(createTime)
WCDB_INDEX(Message, "_index", createTime)

// WCDB_UNIQUE 定义唯一约束
// WCDB_UNIQUE(<#className#>, <#propertyName#>)

// WCDB_NOT_NULL 定义非空约束
// WCDB_NOT_NULL(<#className#>, <#propertyName#>)

@end
