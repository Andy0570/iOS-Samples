该使用说明主要翻译自 FMDB 的 GitHub 项目 README 文档：<https://github.com/ccgus/fmdb>

我会忽略一些安装说明类的，与具体使用无关的，Swift 版本的信息，然后添加一些从公开网络获取的注释说明类信息。

# FMDB v2.7

这是对 [SQLite](https://sqlite.org/index.html) 进行封装的 Objective-C 接口。

FMDB 来自 Flying Meat Software，由 Gus Mueller 开发。

SQLite 是基于 C 语言开发、轻量级、跨平台的嵌入式关系型数据库。在 iOS 中需要使用 C 语言函数进行数据库操作。你无法使用 Objective-C 直接访问，因为 libqlite3 框架基于 C 语言编写。

FMDB 则以 Objective-C 的方式封装了 SQLite 的 C 语言 API。

## FMDB Class Reference:

<https://ccgus.github.io/fmdb/html/index.html>

## What's New in FMDB 2.7

FMDB 2.7 试图支持一个更自然的接口。这对于 Swift 开发者来说有相当大的变化（对可空性「nullability」进行了审核；在可能的情况下转向外部接口中的属性，而不是方法；等等）。对于 Objective-C 开发者来说，这几乎可以无缝过渡（除非你使用了之前在公共接口中暴露的 `ivars`，无论如何，你都不应该这么做！）。

### Nullability and Swift Optionals

。。。

### Custom Functions

。。。

### API Changes

。。。

### URL Methods

为了配合苹果从 paths 到 URL 的转变，以前只接受 paths 路径的各种 init 方法，现在都有了 `NSURL` 的方式。

## 用法

FMDB 有三个主要的类：

1. `FMDatabase` — 一个 `FMDatabase` 对象就代表一个单独的 SQLite 数据库，用来执行 SQL 语句。

2. `FMResultSet` — 使用 `FMDatabase` 执行查询后的结果集。

3. `FMDatabaseQueue` — 在多线程中执行多个查询或更新，它是线程安全的。



### 创建数据库

通过指定 SQLite 数据库文件的路径来创建 FMDatabase 对象。文件路径有三种情况：

1. 文件系统路径，该文件不一定要存在于磁盘上。当该文件不存在时，FMDB 会自己创建一个。
2. 一个空字符串（`@""`）。在 Temporary 临时文件目录创建一个空数据库。当关闭 `FMDatabase` 连接时，该数据库将被删除。
3. NULL。在内存中创建一个数据库。当关闭 `FMDatabase` 连接时，此数据库将被销毁。

```objc
NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.db"];
FMDatabase *db = [FMDatabase databaseWithPath:path];
```



### 打开数据库

在与数据库交互之前，必须先打开它。如果没有足够的资源或权限打开或创建数据库，则打开失败。

通常打开并操作数据库完成后，需要调用 `close` 方法来关闭数据库。

```objc
if (![db open]) {
    db = nil;
    return;
}

// some operation
// ...

[db close];
```



### 执行更新操作

任何类型的 SQL 语句，只要不是 `SELECT` 语句，都可以作为更新操作。这包括 `CREATE`、`UPDATE`、`INSERT`、`ALTER`、`COMMIT`、`BEGIN`、`DETACH`、DELETE、`DROP`、END、`EXPLAIN`、VACUUM 和 `REPLACE` 语句（还有更多）。基本上，如果你的 SQL 操作不是以 `SELECT` 开头的，那它就是更新操作。

执行更新操作会返回一个单一的 `BOOL` 值。返回 `YES` 表示更新已成功执行，返回 `NO` 表示遇到了一些错误。可以调用 `-lastErrorMessage` 和 `-lastErrorCode` 方法来检索更多信息。




### 执行查询操作

`SELECT` 语句是一个查询操作，并通过 `-executeQuery...` 方法之一来执行。

如果执行查询成功，则返回一个 `FMResultSet` 对象，失败时返回 `nil`。你应该使用 `-lastErrorMessage` 和 `-lastErrorCode` 方法来确定查询失败的原因。

为了迭代查询的结果，你可以使用 `while()` 循环。你还需要从一条记录 "步进 "到另一条记录。在FMDB中，最简单的方法是这样做的：

```objc
FMResultSet *s = [db executeQuery:@"SELECT * FROM myTable"];
while ([s next]) {
    // 检索每个记录的值
}
```

在尝试访问查询返回值之前，您必须始终调用 ``-[FMResultSet next]``，即使只有一个返回值：

```objc
FMResultSet *s = [db executeQuery:@"SELECT COUNT(*) FROM myTable"];
if ([s next]) {
    int totalCount = [s intForColumnIndex:0];
}

// 如果你不能确认 Result Set 是否消耗完，则调用 FMResultSet 的 -close 方法。
[s close];
```

`FMResultSet` 有许多方法可以以适当的方式获取不同类型的值：

```objc
intForColumn:
longForColumn:
longLongIntForColumn:
boolForColumn:
doubleForColumn:
stringForColumn:
dateForColumn:
dataForColumn:
dataNoCopyForColumn:
UTF8StringForColumnIndex:
objectForColumn:
```

这些方法中的每一个方法都还有一个 `{type}ForColumnIndex:` 变体，用于根据「列在结果中的位置」来检索数据，而不是根据列名来检索数据。

通常情况下，你并不需要关闭 `FMResultSet`，因为相关的数据库关闭时，`FMResultSet` 也会被自动关闭。

而当你只发起了一个请求或者有没有耗尽结果集的任何其他请求时，你就需要手动调用 `FMResultSet` 的 `-close` 方法。

### 关闭

当你完成对数据库的查询和更新操作后，你应该关闭 `FMDatabase` 连接，这样 SQLite 就会释放它在运行过程中获得的任何资源。

```objc
[db close];
```

### 事务（Transactions ）

事务操作：错误会回滚

`FMDatabase` 可以通过调用一个适当的方法或执行 `begin`/`end` 事务语句来开始和提交一个事务。

### 多语句和批处理

你可以使用 `FMDatabase` 的 `executeStatements:withResultBlock:` 方法在一个字符串中执行多条 SQL 语句。

```objc
NSString *sql = @"create table bulktest1 (id integer primary key autoincrement, x text);"
                 "create table bulktest2 (id integer primary key autoincrement, y text);"
                 "create table bulktest3 (id integer primary key autoincrement, z text);"
                 "insert into bulktest1 (x) values ('XXX');"
                 "insert into bulktest2 (y) values ('YYY');"
                 "insert into bulktest3 (z) values ('ZZZ');";

success = [db executeStatements:sql];

sql = @"select count(*) as count from bulktest1;"
       "select count(*) as count from bulktest2;"
       "select count(*) as count from bulktest3;";

success = [self.db executeStatements:sql withResultBlock:^int(NSDictionary *dictionary) {
    NSInteger count = [dictionary[@"count"] integerValue];
    XCTAssertEqual(count, 1, @"expected one record for dictionary %@", dictionary);
    return 0;
}];
```



### 数据清理

当向 FMDB 提供 SQL 语句时，你不应该试图在执行插入操作前 "sanitize" 清除任何值。相反，您应该使用标准的 SQLite 绑定语法：

```sqlite
INSERT INTO myTable VALUES (?, ?, ?, ?)
```

 `?` 字符会被 SQLite 识别为要插入的值的占位符。执行方法全都可以接受可变数量的参数（或这些参数的表示形式，如`NSArray`、NSDictionary 或 `va_list`），并为你适当地转义。

要在 Objective-C 中使用 `?` 作为 SQL 的占位符：

```objc
NSInteger identifier = 42;
NSString *name = @"Liam O'Flaherty (\"the famous Irish author\")";
NSDate *date = [NSDate date];
NSString *comment = nil;

// 调用 executeUpdate: 方法，在执行 SQL 语句时将具体的参数传入
BOOL success = [db executeUpdate:@"INSERT INTO authors (identifier, name, date, comment) VALUES (?, ?, ?, ?)", @(identifier), name, date, comment ?: [NSNull null]];
if (!success) {
    NSLog(@"error = %@", [db lastErrorMessage]);
}
```

参数必须是 `NSObject` 的子类，所以象 `int`、`double`、`bool` 这种基本类型，需要封装成对应的包装类才行。

> 注意：基本数据类型，如 `NSInteger` 变量标识符，应作为 `NSNumber` 对象，通过使用 @ 语法实现，如上图所示。或者也可以使用 `[NSNumber numberWithInt:identifier]` 语法。
>
> 同样，SQL 中的 `NULL`值也应该以 `[NSNull null]` 的形式插入。例如，在注释可能是 `nil` 的情况下（本例中也是），可以使用注释 `?:[NSNull null]` 语法，如果注释不是 `nil`，则插入字符串，但如果是 `nil`，则插入`[NSNull null]`。



### 使用 FMDatabaseQueue 和线程安全

在多线程中同时使用一个 `FMDatabase` 实例是个坏主意。一直以来，每个线程创建一个`FMDatabase` 对象是可以的。只是不要跨线程共享一个实例，也绝对不要同时跨多个线程。坏事终究会发生，你终究会有东西崩溃，也许会得到一个异常，也许会有陨石从天而降，砸到你的 Mac Pro。这将会很糟糕。

**所以不要实例化一个单一的 `FMDatabase` 对象，并在多个线程中使用它。**

相反，使用 `FMDatabaseQueue`。实例化一个单一的 `FMDatabaseQueue`，并跨多个线程使用它。`FMDatabaseQueue` 对象将同步和协调多个线程的访问。下面是如何使用它的示例：

```objc
// 1.创建你的操作队列
FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:aPath];

// 使用
[queue inDatabase:^(FMDatabase *db) {
    [db executeUpdate:@"INSERT INTO myTable VALUES (?)", @1];
    [db executeUpdate:@"INSERT INTO myTable VALUES (?)", @2];
    [db executeUpdate:@"INSERT INTO myTable VALUES (?)", @3];

    FMResultSet *rs = [db executeQuery:@"select * from foo"];
    while ([rs next]) {
        …
    }
}];

// 如果要支持事务
[queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
    [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:1]];
    [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:2]];
    [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:3]];

    if (whoopsSomethingWrongHappened) {
        *rollback = YES;
        return;
    }
    // etc…
    [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:4]];
}];
```



# 参考

* [SQLite With Swift Tutorial: Getting Started @raywenderlich.com](https://www.raywenderlich.com/6620276-sqlite-with-swift-tutorial-getting-started) ⭐️
* [Objc 中国：用 SQLite 和 FMDB 替代 Core Data](https://objccn.io/issue-4-3/)
* [在 iOS 开发中使用 FMDB @20120422 @唐巧](https://blog.devtang.com/2012/04/22/use-fmdb/)
* [iOS SQLite、CoreData、FMDB 数据库详解](https://www.jianshu.com/p/5a085a4fe2d7)
* [iOS-FMDB 详解及使用 @20190323](https://www.jianshu.com/p/45267dfca32f)
* [iOS FMDB 使用与缓存数据 @20171127](https://www.jianshu.com/p/968c381cb7d7)