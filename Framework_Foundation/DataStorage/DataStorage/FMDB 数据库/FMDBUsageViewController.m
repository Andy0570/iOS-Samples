//
//  FMDBUsageViewController.m
//  DataStorage
//
//  Created by Qilin Hu on 2020/12/14.
//

#import "FMDBUsageViewController.h"

#import <FMDatabase.h>
#import <JKCategories.h>

@interface FMDBUsageViewController ()
@property (nonatomic, strong) FMDatabase *database;
@end

@implementation FMDBUsageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建数据库
    self.database = [FMDatabase databaseWithURL:[self databaseURL]];
    
    // 打开数据库
    if (![_database open]) {
        NSLog(@"数据库打开失败");
        
        _database = nil;
        return;
    }
    NSLog(@"数据库打开成功");
}

// 返回数据库文件路径，Documents/myDatabase.sqlite
- (NSURL *)databaseURL {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsURL = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
    NSURL *databaseURL = [documentsURL URLByAppendingPathComponent:@"myDatabase.sqlite"];
    
    if (![fileManager fileExistsAtPath:databaseURL.path]) {
        BOOL isSucceed = [fileManager createFileAtPath:databaseURL.path contents:nil attributes:nil];
        NSAssert(isSucceed, @"Failed to create directory.");
    }
    
    return databaseURL;
}

#pragma mark - Actions

// 创建表
- (IBAction)createTable:(id)sender {
    NSString *sql = @"CREATE TABLE IF NOT EXISTS student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL)";
    [self.database executeUpdate:sql];
}

// 写入数据
- (IBAction)insertData:(id)sender {
    // 在 SQL 语句中使用 ？ 作为占位符
    NSString *sql = @"INSERT INTO student (name, age) VALUES (?, ?)";
    NSString *name = [NSString stringWithFormat:@"张三 - %@", NSString.jk_UUID];
    NSNumber *age = [NSNumber numberWithInt:30];
    
    [self.database executeUpdate:sql, name, age];
}

// 使用executeUpdateWithFormat: - 不确定的参数用%@，%d等来占位
- (void)executeUpdateWithFormat {
    NSString *sql = @"INSERT INTO student (name, age) values (%@, %i)";
    NSString *name = [NSString stringWithFormat:@"yonna - %@", NSString.jk_UUID];
    NSNumber *age = [NSNumber numberWithInt:30];
    
    [self.database executeUpdateWithFormat:sql, name, age];
}

// 使用 executeUpdate:withParameterDictionary:
- (void)executeUpdateWithParameterDictionary {
    NSString *sql = @"INSERT INTO student (name, age) values (:name, :age)";
    NSString *name = [NSString stringWithFormat:@"王五 - %@", NSString.jk_UUID];
    NSNumber *age = [NSNumber numberWithInt:30];
    NSDictionary *students = @{
        @"name": name,
        @"age": age
    };
    
    [self.database executeUpdate:sql withParameterDictionary:students];
}

// 删除数据
- (IBAction)deleteData:(id)sender {
    NSString *sql = @"DELETE FROM student WHERE id = ?";
    [self.database executeUpdate:sql, [NSNumber numberWithInt:1]];
}

// 更新数据
- (IBAction)updateData:(id)sender {
    NSString *sql = @"UPDATE student set name = '李四' WHERE id = ?";
    [self.database executeUpdate:sql, [NSNumber numberWithInt:2]];
}

// 查询数据
- (IBAction)selectData:(id)sender {
    NSString *sql = @"SELECT id, name, age FROM student";
    FMResultSet *resultSet = [self.database executeQuery:sql];
    
    while (resultSet.next) {
        int identifier = [resultSet intForColumnIndex:0];
        NSString *name = [resultSet stringForColumnIndex:1];
        int age = [resultSet intForColumnIndex:2];
        
        NSLog(@"%d, %@, %d", identifier, name, age);
    }
}


// 批处理
- (IBAction)executeStatements:(id)sender {
    NSURL *databaseURL = [self databaseURL];
    NSLog(@"%@",databaseURL.path);
    
    // 1.创建数据库对象
    FMDatabase *db = [FMDatabase databaseWithURL:databaseURL];
    if ([db open]) {
        NSString *sql = @"CREATE TABLE IF NOT EXISTS bulktest1 (id integer PRIMARY KEY AUTOINCREMENT, x text);"
        "CREATE TABLE IF NOT EXISTS bulktest2 (id integer PRIMARY KEY AUTOINCREMENT, y text);"
        "CREATE TABLE IF NOT EXISTS bulktest3 (id integer PRIMARY KEY AUTOINCREMENT, z text);"
        "INSERT INTO bulktest1 (x) VALUES ('XXX');"
        "INSERT INTO bulktest2 (y) VALUES ('YYY');"
        "INSERT INTO bulktest3 (z) VALUES ('ZZZ');";
        
        BOOL result = [db executeStatements:sql];
        
        sql = @"SELECT count(*) as count FROM bulktest1;"
        "SELECT count(*) as count FROM bulktest2;"
        "SELECT count(*) as count FROM bulktest3;";
        
        result = [db executeStatements:sql withResultBlock:^int(NSDictionary * _Nonnull resultsDictionary) {
            NSLog(@"dictionary = %@", resultsDictionary);
            return 0;
        }];
    } else {
        NSLog(@"Failure to open database.");
    }
}

@end
