# iOS 数据持久化方案


* NSUserDefaults （偏好设置）
* property list（plist，属性列表）
* NSKeyedArchiver NSKeyedUnarchiver（归档、解档）
* text file（Write 写入文件方式，永久保存在磁盘中）
* SQL databases（SQLite 数据库）
* Core Data
* KeyChain (钥匙串)





## 参考

* [简书：iOS 四种保存文件的方式](https://www.jianshu.com/p/a8e292f0c838)
* [使用 NSFileManager 管理文件系统](https://www.jianshu.com/p/73f346855c54)
* [使用偏好设置、属性列表、归档解档保存数据、恢复数据](https://github.com/pro648/tips/wiki/%E4%BD%BF%E7%94%A8%E5%81%8F%E5%A5%BD%E8%AE%BE%E7%BD%AE%E3%80%81%E5%B1%9E%E6%80%A7%E5%88%97%E8%A1%A8%E3%80%81%E5%BD%92%E6%A1%A3%E8%A7%A3%E6%A1%A3%E4%BF%9D%E5%AD%98%E6%95%B0%E6%8D%AE%E3%80%81%E6%81%A2%E5%A4%8D%E6%95%B0%E6%8D%AE)
* [GitHub：数据存储之归档解档 NSKeyedArchiver NSKeyedUnarchiver](https://github.com/pro648/tips/wiki/%E6%95%B0%E6%8D%AE%E5%AD%98%E5%82%A8%E4%B9%8B%E5%BD%92%E6%A1%A3%E8%A7%A3%E6%A1%A3-NSKeyedArchiver-NSKeyedUnarchiver) 
* [GitHub: SAMKeychain](https://github.com/soffes/SAMKeychain)





## MARK：通过归档解档的方式保存用户数据

通过单例方法初始化类时，通过从归档文件中恢复类信息。

打开归档文件需要知道该归档文件的路径。

你不能把获取归档文件路径的过程写在一个实例方法中，比如`NSString *path = [self getArchiveFilePath]`，因为这时候单例类正在初始化，还没有返回 `self`，所以还无法调用实例方法，不过你可以把它写在一个 C 函数中，就像这样：

```objc
NSString *userDataPath() {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *userDataPath = [documentsPath stringByAppendingPathComponent:@"user.data"];
    
    if (![fileManager fileExistsAtPath:documentsPath]) {
        NSError *error = nil;
        BOOL isCreateDirectorySucceed = [fileManager createDirectoryAtPath:documentsPath
                                               withIntermediateDirectories:YES
                                                                attributes:nil
                                                                     error:&error];
        if (!isCreateDirectorySucceed) {
            DDLogError(@"Create User Directory Error:\n%@",error);
        }
    }
    return userDataPath;
}
```

在单例类方法中解档：

```objc
+ (instancetype)sharedManager {
    static HQLUserManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 从归档文件中读取用户数据
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSData *archivedData = [fileManager contentsAtPath:userDataPath()];
        if (@available(iOS 11.0, *)) {
            NSError *error;
            sharedManager = (HQLUserManager *)[NSKeyedUnarchiver unarchivedObjectOfClass:HQLUserManager.class fromData:archivedData error:&error];
            if (!sharedManager) {
                DDLogDebug(@"%@,Unarchiver Error:\n%@",@(__PRETTY_FUNCTION__),error);
            }
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            sharedManager = (HQLUserManager *)[NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
#pragma clang diagnostic pop
        }
        
        if (!sharedManager) {
            sharedManager = [[HQLUserManager alloc] init];
            sharedManager.loginState = NO;
        }
    });
    return sharedManager;
}
```

在应用退出之前，调用归档方法：

```objc
- (BOOL)archiveUserData {
    if (@available(iOS 11.0, *)) {
        NSError *error = nil;
        NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:self requiringSecureCoding:YES error:&error];
        NSAssert1(archivedData, @"Archived Data Error:\n%@", error);
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL result = [fileManager createFileAtPath:userDataPath() contents:archivedData attributes:nil];
        return result;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        BOOL result = [NSKeyedArchiver archiveRootObject:self toFile:userDataPath()];
        return result;
#pragma clang diagnostic pop
    }
}
```



