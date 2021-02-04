//
//  HQLStorageManager.m
//  DataStorage
//
//  Created by Qilin Hu on 2021/1/7.
//

#import "HQLStorageManager.h"
#import "Student.h"
#import <FMDB/FMDB.h>

static HQLStorageManager *_sharedInstance = nil;

// Table SQL
static NSString *const kCreateStudentTableSQL = @"CREATE TABLE IF NOT EXISTS Student(ObjectData BLOB NOT NULL,CreateData TEXT NOT NULL);";

// Table name
static NSString *const kStudentTable = @"StudentTable";

// Column Name
static NSString *const kObjectDataColumn = @"ObjectData";
static NSString *const kIdentityColumn = @"Identity";
static NSString *const kCreateDateColumn = @"CreateDate";

@interface HQLStorageManager ()
@property (nonatomic, strong) FMDatabaseQueue *dbQuene;
@end

@implementation HQLStorageManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }
    
    __unused BOOL result = [self initDatabase];
    NSAssert(result, @"Init Database Failure!");
    return self;
}

- (BOOL)initDatabase {
    // 创建目录
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    doc = [doc stringByAppendingPathComponent:@"LDebugTool"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:doc]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:doc withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"HQLStorageManager create folder fail, error = %@", error.description);
        }
        NSAssert(!error, error.description);
    }
    
    // 数据库文件名
    NSString *filePath = [doc stringByAppendingPathComponent:@"LDebugTool.db"];
    
    // 创建数据库
    _dbQuene = [FMDatabaseQueue databaseQueueWithPath:filePath];
    
    __block BOOL result = NO;
    [_dbQuene inDatabase:^(FMDatabase * _Nonnull db) {
        // ObjectData use to convert to Student Model, launchDate use as identity
        result = [db executeUpdate:kCreateStudentTableSQL];
        if (!result) {
            NSLog(@"HQLStorageManager create StudentModelTable fail");
        }
    }];
    return result;
}

// 插入操作
- (BOOL)saveStudent:(Student *)student {
    // 1.归档
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:student];
    if (data.length == 0) {
        NSLog(@"HQLStorageManager save student model fail, because model's data is null");
        return NO;
    }
    
    // 2.将归档数据保存到数据库
    __block NSArray *arguments = @[data, student.startTime];
    __block BOOL result = NO;
    
    [_dbQuene inDatabase:^(FMDatabase * _Nonnull db) {
        NSError *error;
        result = [db executeUpdate:[NSString stringWithFormat:@"INSERT INTO %@(%@,%@) VALUES (?,?);", kStudentTable, kObjectDataColumn, kCreateDateColumn] values:arguments error:&error];
        if (!result) {
            NSLog(@"HQLStorageManager save student model fail,Error = %@",error.localizedDescription);
        } else {
            NSLog(@"HQLStorageManager save student success!");
        }
    }];
    return result;
}

// 查询操作
- (NSArray <Student *> *)getAllStudents {
    __block NSMutableArray *students = [[NSMutableArray alloc] init];
    
    // 1.查询获取表中所有的学生数据
    [_dbQuene inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *resultSet = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@"], kStudentTable];
        while ([resultSet next]) {
            // 2.解档
            NSData *objectData = [resultSet dataForColumn:kObjectDataColumn];
            Student *student = [NSKeyedUnarchiver unarchiveObjectWithData:objectData];
            if (student) {
                [students insertObject:student atIndex:0];
            }
        }
    }];
    
    return [students copy];
}

// 删除操作
- (BOOL)removeStudents:(NSArray <Student *> *)students {
    __block BOOL result = YES;
    [students enumerateObjectsUsingBlock:^(Student *student, NSUInteger idx, BOOL * _Nonnull stop) {
        result = result && [self _removeMotionModel:student];
    }];
    return result;
}

// 内部真正实现的删除操作
- (BOOL)_removeMotionModel:(Student *)student {
    __block BOOL result = NO;
    [_dbQuene inDatabase:^(FMDatabase * _Nonnull db) {
        NSError *error;
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?", kStudentTable, kCreateDateColumn] values:@[student.startTime] error:&error];
        if (!result) {
            NSLog(@"Delete Student model fail,error = %@",error);
        }
    }];
    return result;
}

@end
