//
//  WCDBUsageViewController.m
//  DataStorage
//
//  Created by Qilin Hu on 2021/8/5.
//

#import "WCDBUsageViewController.h"
#import "IMUser.h"
#import "IMUser+WCTTableCoding.h"
#import <YYKit.h>

static NSString * const kTableName = @"users";

@interface WCDBUsageViewController ()
@property (nonatomic, strong) WCTDatabase *database;
@end

@implementation WCDBUsageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"WCDB 使用示例";
}

// 创建数据库
- (IBAction)createDatabase:(id)sender {
    NSURL *databaseURL = [self p_userDatabaseURL];
    self.database = [[WCTDatabase alloc] initWithPath:databaseURL.path];
    BOOL result = [self.database createTableAndIndexesOfName:kTableName withClass:IMUser.class];
    NSAssert(result, @"Failed to Create users Database.");
    
//    if (result) {
//        [self insertUsers];
//    }
}

- (IBAction)executeDatabaseOperation:(id)sender {
    // 查询获取所有数据
    [self getAllUsers];
    
//    // 查询获取所有用户的 id 字段
//    [self getAllUserId];
//
//    // 通过 userId 查询单个用户
//    [self getUserWithUesrId];
//
//    // 获取去重性别
//    [self getUserGender];
    
    // 测试 MAX(age), MIN(age)
    [self testMaxAndMinOperation];
}

/// 查询所有用户
/// SELECT * FROM contacts ORDER BY name
- (void)getAllUsers {
    NSArray *result = [self.database getAllObjectsOfClass:IMUser.class fromTable:kTableName];
    NSLog(@"查询获取所有数据: \n%@", result);
}

/// 查询获取所有用户的 id 字段
- (void)getAllUserId {
    NSArray *result = [self.database getOneColumnOnResult:IMUser.userId fromTable:kTableName];
    NSLog(@"查询获取所有用户的 id 字段: \n%@", result);
}

/// 通过 userId 查询单个用户
- (void)getUserWithUesrId {
    IMUser *user = [self.database getOneObjectOfClass:IMUser.class fromTable:kTableName where:IMUser.userId == 18];
    NSLog(@"通过 userId 查询单个用户: \n%@", user);
}

/// 获取去重性别
- (void)getUserGender {
    NSArray *result = [self.database getRowsOnResults:IMUser.gender.distinct()
                                            fromTable:kTableName
                                                where:IMUser.age > 18];
    NSLog(@"获取去重性别: \n%@", result);
}

// 测试 MAX(age), MIN(age)
/**
 <IMUser: 0x280dfc480> {
 age = 47;
 gender = 0;
 name = <nil>;
 telephone = <nil>;
 userId = 10
}
 */
- (void)testMaxAndMinOperation {
    NSArray *result = [self.database getObjectsOnResults:{IMUser.userId.min(), IMUser.age.max()}
                                               fromTable:kTableName
                                                   where:IMUser.userId > 0 &&
                                                         IMUser.name.isNotNull()];
    NSLog(@"测试 MAX(age), MIN(age): \n%@", result);
}


#pragma mark - Private

// ./Documents/User/Database/common/user.sqlite
- (NSURL *)p_userDatabaseURL {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsURL = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
    NSString *directory = [NSString stringWithFormat:@"User/Database/common/"];
    NSURL *directoryURL = [documentsURL URLByAppendingPathComponent:directory];
    
    if (![fileManager fileExistsAtPath:directoryURL.path]) {
        BOOL result = [fileManager createDirectoryAtPath:directoryURL.path withIntermediateDirectories:YES attributes:nil error:nil];
        NSAssert(result, @"Failed to Create Directory: %@.",directoryURL.path);
    }
    return [directoryURL URLByAppendingPathComponent:@"user.sqlite"];
}

// 插入 10 条测试用户数据
- (void)insertUsers {
    NSArray *jsonArray = @[
        @{
            @"userId": @10,
            @"name": @"张三",
            @"gender": @0,
            @"age": @23,
            @"telephone": @"null"
        },
        @{
            @"userId": @11,
            @"name": @"李四",
            @"gender": @1,
            @"age": @28,
            @"telephone": @"null"
        },
        @{
            @"userId": @12,
            @"name": @"王武",
            @"gender": @1,
            @"age": @32,
            @"telephone": @"null"
        },
        @{
            @"userId": @13,
            @"name": @"赵六",
            @"gender": @0,
            @"age": @47,
            @"telephone": @"null"
        },
        @{
            @"userId": @14,
            @"name": @"李雷",
            @"gender": @1,
            @"age": @25,
            @"telephone": @"null"
        },
        @{
            @"userId": @15,
            @"name": @"王新宇",
            @"gender": @0,
            @"age": @36,
            @"telephone": @"null"
        },
        @{
            @"userId": @16,
            @"name": @"张浩然",
            @"gender": @0,
            @"age": @18,
            @"telephone": @"null"
        },
        @{
            @"userId": @17,
            @"name": @"刘德华",
            @"gender": @1,
            @"age": @19,
            @"telephone": @"null"
        },
        @{
            @"userId": @18,
            @"name": @"胡八一",
            @"gender": @0,
            @"age": @20,
            @"telephone": @"null"
        },
        @{
            @"userId": @19,
            @"name": @"李飞飞",
            @"gender": @0,
            @"age": @45,
            @"telephone": @"null"
        }
    ];
    
    NSArray *users = [NSArray modelArrayWithClass:IMUser.class json:jsonArray];
    if (users.count == 0) {
        NSLog(@"%s, JSON 数据转换错误！", __PRETTY_FUNCTION__);
        return;
    }
    
    // MARK: 插入 10 条用户数据
    BOOL result = [self.database insertObjects:users into:kTableName];
    if (!result) {
        NSLog(@"%s, 数据库操作失败001", __PRETTY_FUNCTION__);
    }
}

@end
