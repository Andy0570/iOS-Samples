//
//  MessageStroge.m
//  DataStorage
//
//  Created by Qilin Hu on 2021/1/15.
//

#import "MessageStroge.h"
#import "Message.h"
#import "Message+WCTTableCoding.h"

@implementation MessageStroge

// 创建指定目录
+ (NSURL *)p_createDirectory:(NSString *)directoryName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsURL = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
    NSURL *directoryURL = [documentsURL URLByAppendingPathComponent:directoryName];
    if (![fileManager fileExistsAtPath:directoryURL.path]) {
        BOOL result = [fileManager createDirectoryAtPath:directoryURL.path withIntermediateDirectories:YES attributes:nil error:nil];
        NSAssert(result, @"Failed to Create Directory.");
    }
    return [directoryURL URLByAppendingPathComponent:@"message.sqlite"];
}


- (void)createMessageTable {
    // MARK: 创建表和索引
    NSURL *databaseURL = [MessageStroge p_createDirectory:@"Message"];
    WCTDatabase *database = [[WCTDatabase alloc] initWithPath:databaseURL.path];
    /**
     CREATE TABLE message (localID INTEGER PRIMARY KEY AUTOINCREMENT,
                           content TEXT,
                           createTime BLOB,
                           modifiedTime BLOB);
     */
    BOOL result = [database createTableAndIndexesOfName:@"message"
                                              withClass:Message.class];
    NSLog(@"创建表和索引:%@", result ? @"YES" : @"NO");
    
    
    // MARK: 插入
    Message *message = [[Message alloc] init];
    message.localID = 1;
    message.content = @"Hello WCDB!";
    message.createTime = [NSDate date];
    message.modifiedTime = [NSDate date];
    /**
     INSERT INTO message(localID, content, createTime, modifiedTime)
     VALUES(1, "Hello  WCDB!", 1496396165, 1496396165);
     */
    result = [database insertObject:message into:@"message"];
    NSLog(@"插入:%@", result ? @"YES" : @"NO");
    
    
    // MARK: 删除
    // DELETE FROM message WHERE localID>0;
    result = [database deleteObjectsFromTable:@"message"
                                        where:Message.localID > 0];
    NSLog(@"删除:%@", result ? @"YES" : @"NO");
    
    
    // MARK: 修改
    // UPDATE message SET content="Hello, Wechat!";
    message.content = @"Hello, Wechat";
    result = [database updateAllRowsInTable:@"message"
                               onProperties:Message.content
                                 withObject:message];
    NSLog(@"修改:%@", result ? @"YES" : @"NO");
    
    // MARK: 查询
    // SELECT * FROM message;
    NSArray<Message *> *messages1 = [database getAllObjectsOfClass:Message.class
                                                         fromTable:@"message"];
    NSLog(@"messages:%@",messages1);
    
    // MARK: 查询并排序
    // SELECT * FROM message ORDER BY localID;
    NSArray<Message *> *messages2 = [database getObjectsOfClass:Message.class
                                                      fromTable:@"message"
                                                        orderBy:Message.localID.order()];
    NSLog(@"messages:%@",messages2);
    
    
    // WCTTable 相当于预设了表名和类名的 WCTDatabase 对象，接口和 WCTDatabase 基本一致
    WCTTable *table = [database getTableOfName:@"message" withClass:Message.class];
    
    // MARK: 通过 WCTTable 查询
    // SELECT * FROM message ORDER BY localID;
    NSArray<Message *> *queryResult = [table getObjectsOrderBy:Message.localID.order()];
    NSLog(@"messages:%@",queryResult);
    
    
    // MARK: 事务
    BOOL commited = [database runTransaction:^BOOL{
        [database insertObject:message into:@"message"];
        return YES; // 返回 YES 以 commit 事务，返回 NO 以 rollback 事务。
    }];
    
    /**
     MARK: 字段映射与运算符
     
     WINQ 接口语法
     一元操作符：+、-、! 等
     二元操作符：||、&&、+、-、*、/、|、&、<<、>>、<、<=、==、!=、>、>= 等
     范围比较：IN、BETWEEN 等
     字符串匹配：LIKE、GLOB、MATCH、REGEXP 等
     聚合函数：AVG、COUNT、MAX、MIN、SUM 等
     */
    
    /**
     SELECT MAX(createTime), MIN(createTime)
     FROM message
     WHERE localID>0 AND content IS NOT NULL
     */
    [database getObjectsOnResults:{Message.createTime.max(), Message.createTime.min()}
                        fromTable:@"message"
                            where:Message.localID > 0 && Message.content.isNotNull()];
    
    /**
     SELECT DISTINCT localID
     FROM message
     ORDER BY modifiedTime ASC
     LIMIT 10
     */
    [database getObjectsOnResults:Message.localID.distinct()
                        fromTable:@"message"
                          orderBy:Message.modifiedTime.order(WCTOrderedAscending)
                            limit:10];
    
    /**
     DELETE FROM message
     WHERE localID BETWEEN 10 AND 20 OR content LIKE 'Hello%'
     */
    [database deleteObjectsFromTable:@"message"
                               where:Message.localID.between(10, 20) || Message.content.like("Hello%")];
    
    // MARK: 字段组合
    // 多个字段可以通过大括号{}进行组合
    /**
     SELECT localID, content FROM message;
     */
    [database getAllObjectsOnResults:{Message.localID, Message.content}
                           fromTable:@"message"];
    
    /**
     SELECT *
     FROM message
     ORDER BY createTime ASC, localID DESC;
     */
    [database getObjectsOfClass:Message.class
                      fromTable:@"message"
                        orderBy:{Message.createTime.order(WCTOrderedAscending), Message.localID.order(WCTOrderedDescending)}];
    
    
    
    // MARK: className.AllProperties 用于获取类定义的所有字段映射的列表
     /**
      SELECT localID, content, createTime, modifiedTime FROM message;
      */
    [database getAllObjectsOnResults:Message.AllProperties
                           fromTable:@"message"];
    
    
    // MARK: className.AnyProperty 用于指代 SQL 中的 *
    /**
     SELECT count(*) FROM message;
     */
    [database getOneValueOnResult:Message.AnyProperty.count()
                        fromTable:@"message"];
    
    
    // 高级用法
    // as 重定向
    // 从数据库中取出了消息的最新的修改时间，并以此将此时间作为消息的创建时间，新建了一个 message。
    NSNumber *maxModifiedTime = [database getOneValueOnResult:Message.modifiedTime.max()
                                                    fromTable:@"message"];
    Message *lastMessage1 = [[Message alloc] init];
    lastMessage1.createTime = [NSDate dateWithTimeIntervalSince1970:maxModifiedTime.doubleValue];
    
    // 通过 as 重定向语法优化
    // as(Message.createTime) 语法，将查询结果重新指向 createTime
    Message *lastMessage2 = [database getOneObjectOnResults:Message.modifiedTime.max().as(Message.createTime)
                                                  fromTable:@"message"];
    
}


/**
 WCDB 内提供统计的接口注册获取数据库操作的 SQL、性能、错误等，开发者可以将这些信息打印到日志或上报到后台，以调试或统计
 */
- (void)monitor {
    //Error Monitor
    [WCTStatistics SetGlobalErrorReport:^(WCTError *error) {
        NSLog(@"[WCDB]%@", error);
    }];

    //Performance Monitor
    [WCTStatistics SetGlobalPerformanceTrace:^(WCTTag tag, NSDictionary<NSString *, NSNumber *> *sqls, NSInteger cost) {
        NSLog(@"Database with tag:%d", tag);
        NSLog(@"Run :");
        [sqls enumerateKeysAndObjectsUsingBlock:^(NSString *sqls, NSNumber *count, BOOL *) {
            NSLog(@"SQL %@ %@ times", sqls, count);
        }];
        NSLog(@"Total cost %ld nanoseconds", (long)cost);
    }];

    //SQL Execution Monitor
    [WCTStatistics SetGlobalSQLTrace:^(NSString *sql) {
        NSLog(@"SQL: %@", sql);
    }];
}

@end

