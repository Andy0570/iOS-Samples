//
//  IMUser+WCTTableCoding.h
//  DataStorage
//
//  Created by Qilin Hu on 2021/8/5.
//

#import "IMUser.h"
#import <WCDB/WCDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMUser (WCTTableCoding) <WCTTableCoding>

// 使用 WCDB_PROPERTY 宏在「头文件」中声明需要绑定到数据库表的字段
WCDB_PROPERTY(userId)
WCDB_PROPERTY(name)
WCDB_PROPERTY(gender)
WCDB_PROPERTY(age)
WCDB_PROPERTY(telephone)

@end

NS_ASSUME_NONNULL_END
