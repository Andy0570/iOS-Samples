//
//  Message+WCTTableCoding.h
//  DataStorage
//
//  Created by Qilin Hu on 2021/1/15.
//

#import "Message.h"
#import <WCDB/WCDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface Message (WCTTableCoding) <WCTTableCoding>

// 使用 WCDB_PROPERTY 宏在「头文件」中声明需要绑定到数据库表的字段
WCDB_PROPERTY(localID)
WCDB_PROPERTY(content)
WCDB_PROPERTY(createTime)
WCDB_PROPERTY(modifiedTime)

@end

NS_ASSUME_NONNULL_END
