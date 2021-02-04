//
//  HQLFileBasicUsageViewController.m
//  DataStorage
//
//  Created by Qilin Hu on 2020/12/10.
//

#import "HQLFileBasicUsageViewController.h"

@interface HQLFileBasicUsageViewController ()

@end

@implementation HQLFileBasicUsageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建自定义目录
    NSURL *bundleIDDir = [self applicationSupportDirectory];
    
    // 复制目录
    [self backupMyApplicationDataWithURL:bundleIDDir];
    
    // 一次枚举一个对象
    [self performSelector:@selector(enumerateOneFileAtATimeAtURL:) withObject:bundleIDDir afterDelay:0.3];
    
    // 一次枚举一个对象
    [self performSelector:@selector(enumerateOneFileAtATimeExample2AtURL:) withObject:bundleIDDir afterDelay:0.3];
    
    // 一次枚举整个目录
    [self performSelector:@selector(enumerateAllAtOnceAtURL:) withObject:bundleIDDir afterDelay:0.3];
    
    // 获取并计算指定文件占用内存大小
    [self getFileSize];
    
    // 获取文件夹中所有的文件，计算所有文件占用的内存大小
    [self getAllFile];
}

#pragma mark - 创建自定义目录

// MARK: 创建目录，模版代码
- (NSURL *)documentsUrl {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // Application Support 目录
    NSURL *appSupportDir = [fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask].firstObject;
    NSString *appBunleID = [[NSBundle mainBundle] bundleIdentifier];
    NSURL *documentsUrl = [appSupportDir URLByAppendingPathComponent:appBunleID];
    if (documentsUrl) { return documentsUrl; }
    
    NSError *error = nil;
    BOOL isCreateDocumentsUrlSucceed = [fileManager createDirectoryAtURL:documentsUrl
                                             withIntermediateDirectories:YES
                                                              attributes:nil
                                                                   error:&error];
    NSAssert(isCreateDocumentsUrlSucceed, @"Failed to create directory.");
    return documentsUrl;
}

/**
 获取自定义目录，如果目录不存在，则递归创建该目录
 
 方法：createDirectoryAtURL: withIntermediateDirectories: attributes: error:
 
 使用 NSFileManager 在 Library/Application Support/ 目录下创建自定义目录。
 因为这个方法每次都会接触到文件系统，会非常耗费时间。如果需要多次用到该目录，你应该保存返回的 URL，而非每次需要时调用该方法。
 */
- (NSURL *)applicationSupportDirectory {
    // 1.创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 2.查找 Application Support 目录在主目录的路径
    NSArray *possibleURLs = [fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask];
    
    NSURL *appSupportDir = nil; // Application Support 目录
    NSURL *customDir = nil;     // Application Support 目录下的自定义目录
    if (possibleURLs.count > 0) {
        // 3. 数组不为空时，使用第一个元素
        appSupportDir = possibleURLs.firstObject;
    }
    
    // 4. 如果存在 Application Support 目录，将应用的 bundleIdentifier 添加到文件结尾，用于创建自定义目录
    if (appSupportDir) {
        NSString *appBundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
        // 自定义目录的路径
        customDir = [appSupportDir URLByAppendingPathComponent:appBundleIdentifier];
    }
    
    /**
     5. 如果 customDir 目录不存在，创建该目录
     
     createDirectoryAtURL: withIntermediateDirectories: attributes: error: 方法用于创建目录，
     createIntermediates: 指定在创建目录的过程中，如果父目录不存在，是否创建父目录。参数为 YES 时，自动创建不存在的父目录；参数为 NO 时，如果任何中间父目录不存，则此方法将失败。
     attributes: 用于指定新建目录文件属性，包括所有者、创建日期、群组等。如果指定为 nil，则使用默认属性。
     
     如果目录创建成功，方法返回 YES；如果中间目录创建成功且目标目录已经存在，也返回 YES；如果遇到错误，返回 NO。
     */
    NSError *error;
    if (![fileManager createDirectoryAtURL:customDir withIntermediateDirectories:YES attributes:nil error:&error]) {
        NSLog(@"Couldn't create dirPath,error: %@",error);
        return nil;
    }
    
    return customDir;
}

#pragma mark - NSString 字符串数据的创建&读取

/**
 创建文件
 
 方法：createFileAtPath: contents: attributes:
 */
- (void)saveFile {
    // 1.创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 2.构造文件路径
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *appBundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *customPath = [documentsPath stringByAppendingPathComponent:appBundleIdentifier];
    
    // 3.构造数据
    NSString *string = @"Hello World";
    
    // 4. NSString -> NSData
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    // 5.创建文件
    //createFileAtPath 创建文件，如果文件已经存在，那么新创建的文件会将原文件覆盖
    BOOL isSuccess = [fileManager createFileAtPath:customPath contents:data attributes:nil];
    if (isSuccess) {
        NSLog(@"Create file success.");
    }
}

/**
 读取文件
 
 方法：contentsAtPath:
 */
- (void)readFile {
    // 1.创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 2.构造文件路径
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *appBundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *customPath = [documentsPath stringByAppendingPathComponent:appBundleIdentifier];
    
    // 3.根据文件路径读取数据
    NSData *data = [fileManager contentsAtPath:customPath];
    
    // 4.NSData -> NSString
    NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",content);
}

#pragma mark - 复制文件或目录

/*
 异步复制文件或目录
 源路径：  Library/Application Support/bundleID/Data
 目标路径：Library/Application Support/bundleID/Data.backup
 
 使用 NSFileManager 的 copyItemAtURL:toURL:error: 和 copyItemAtPath:toPath:error: 方法可以复制文件或目录。
 */
- (void)backupMyApplicationDataWithURL:(NSURL *)bundleIdentifier {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 1.获得源文件、备份文件路径。如果源文件不存在，则创建源文件
    NSURL *appDataDir = [bundleIdentifier URLByAppendingPathComponent:@"Data"]; // Data
    if (![fileManager fileExistsAtPath:appDataDir.path]) {
        NSError *error;
        if (![fileManager createDirectoryAtURL:appDataDir withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"Couldn't create appDataDir,error: %@",error);
            return;
        }
    }
    
    NSURL *backupDir = [appDataDir URLByAppendingPathExtension:@"backup"]; // Data.backup
    
    // 2.异步执行复制
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 3.使用 init 方法初始化文件管理器，以便以后可能用到代理方法 <NSFileManagerDelegate>
        NSFileManager *theFM = [[NSFileManager alloc] init];
        
        // 4.尝试复制文件，如果目标路径已经存在此文件，那么会导致操作失败
        NSError *error;
        if (![theFM copyItemAtURL:appDataDir toURL:backupDir error:&error]) {
            // 5. 如果复制失败，可能是 backupDir 文件已经存在，删除 backupDir 文件
            if ([theFM removeItemAtURL:backupDir error:&error]) {
                // 6.再次复制，如果失败，终止此次复制操作
                if (![theFM copyItemAtURL:appDataDir toURL:backupDir error:&error]) {
                    NSLog(@"Couldn't copy appDataDir,error:%@",error);
                }
            }
        }
    });
}

// 复制文件示例
- (void)copyFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];

    //1.构造路径
    //文件的原路径
    NSString *srcPath = [NSHomeDirectory() stringByAppendingPathComponent:@"temp/file.txt"];
    //文件复制之后的路径
    NSString *toPath = [NSHomeDirectory() stringByAppendingPathComponent:@"file.txt"];
        
    BOOL success = [fileManager copyItemAtPath:srcPath toPath:toPath error:nil];
    //注意：如果目标路径已经存在此文件，那么会导致操作失败
    if (!success) {
        NSLog(@"复制失败");
    }
}

#pragma mark - 移动文件或目录

/**
 移动文件或目录
 
 使用 moveItemAtURL:toURL:error: 和 moveItemAtPath:toPath:error: 方法移动文件或目录。
 */
- (void)moveFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //构造路径
    //文件的原路径
    NSString *srcPath = [NSHomeDirectory() stringByAppendingPathComponent:@"file.txt"];
    //文件移动之后的路径
    NSString *toPath = [NSHomeDirectory() stringByAppendingPathComponent:@"temp/file.txt"];
    
    //注意：如果目标路径已经存在此文件，那么会导致操作失败
    NSError *error = nil;
    BOOL success = [fileManager moveItemAtPath:srcPath
                                        toPath:toPath
                                         error:&error];
    if (!success) {
        NSLog(@"文件移动失败,%@",error);
    }
}

#pragma mark - 移除文件或目录
/*
 移除文件或目录
 
 使用 removeItemAtURL:error: 和 removeItemAtPath:error: 方法移除文件或目录。
 */
- (void)removeFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];

    // 1.构造文件路径
    NSString *toPath = [NSHomeDirectory() stringByAppendingPathComponent:@"file.txt"];
    
    // 删除文件或文件夹之前，务必判断文件是否存在，否则会造成过度释放。
    // 2.判断文件是否存在
    if (![fileManager fileExistsAtPath:toPath]) { return; }
    
    //3.删除文件
    if ([fileManager removeItemAtPath:toPath error:nil]) {
        NSLog(@"删除文件成功");
    }
}

#pragma mark - 枚举目录

/*
 【示例 1】
 枚举目录，每次枚举一个文件。使用 NSDirectoryEnumerator 类逐个文件枚举。
 
 使用 enumeratorAtURL:includePropertiesForKeys:options:errorHandler: 方法枚举出 bundleIDDir 目录内所有可见子目录。
 
     keys 数组告诉枚举器为每个项目预取、缓存的文件属性信息。枚举时需要接触磁盘，此时缓存此类信息等到再次需要此类信息时就不再需要接触磁盘，可以提高效率。
     options: 指定枚举不应列出文件包和隐藏文件的内容。
     errorHandler: 是返回 BOOL 值的块，当发生错误时，如果块返回 YES，则枚举继续进行；当发生错误时，如果块返回 NO，则停止枚举。
 */
- (void)enumerateOneFileAtATimeAtURL:(NSURL *)enumerateURL {
    NSArray *keys = [NSArray arrayWithObjects:NSURLIsDirectoryKey,NSURLLocalizedNameKey, nil];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtURL:enumerateURL
                                          includingPropertiesForKeys:keys
                                                             options:NSDirectoryEnumerationSkipsSubdirectoryDescendants | NSDirectoryEnumerationSkipsHiddenFiles
                                                        errorHandler:^BOOL(NSURL * _Nonnull url, NSError * _Nonnull error) {
        // 1.遇到错误时输出错误，并继续递归
        if (error) {
            NSLog(@"[error] %@ %@",error, url);
        }
        return YES;
    }];
    
    for (NSURL *url in enumerator) {
        NSNumber *isDirectory = nil;
        NSError *error;
        if (![url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error]) {
            NSLog(@"%@,%@",error,url);
        }
        
        // 使用 skipDescendants 方法排除你不想要枚举的目录
        if (isDirectory.boolValue) {
            // 2.扩展名为 backup 时，跳过递归
            if ([url.pathExtension isEqualToString:@"backup"]) {
                [enumerator skipDescendants];
                continue;
            }
            
            NSString *localizedname = nil;
            if ([url getResourceValue:&localizedname forKey:NSURLLocalizedNameKey error:NULL]) {
                NSLog(@"Directory at %@",localizedname);
            }
        }
    }
}
/*
 调用结果：
 Directory at Data
 */

/*
 【示例 2】
 枚举目录，每次枚举一个文件。
 */
- (void)enumerateOneFileAtATimeExample2AtURL:(NSURL *)enumerateURL {
    // 构造枚举器
    NSArray *keys = [NSArray arrayWithObjects:NSURLCreationDateKey,NSURLLocalizedNameKey, nil];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtURL:enumerateURL
                                          includingPropertiesForKeys:keys
                                                             options:0
                                                        errorHandler:nil];
    
    // 遍历目录
    for (NSURL *url in enumerator) {
        NSString *name = nil;
        NSDate *creationDate = nil;
        NSError *error = nil;
        // 通过 getResourceValue:... 方法可以从 URL 中得到已缓存的值，而不用重新访问文件系统（提高效率）。
        if ([url getResourceValue:&name forKey:NSURLLocalizedNameKey error:&error] && [url getResourceValue:&creationDate forKey:NSURLCreationDateKey error:&error]) {
            // 打印文件的名称和创建日期
            NSLog(@"%@ was created at %@.", name, creationDate);
        }
    }
}

/*
 【示例 3】
 枚举目录，一次枚举整个目录。
 
 使用 NSFileManager 对目录进行批次枚举 (batch enumeration) 有两种选择：
 1. 如果只枚举该目录，不深入子目录和程序包 (pachage)，使用 contentsOfDirectoryAtURL:includingPropertiesForKeys:options:error: 或 contentsOfDirectoryAtPath:error: 方法。
 2. 如果要深入到子目录，并只返回子目录，使用 subPathsOfDirectoryAtPath:error: 方法。

 示例：使用 contentsOfDirectoryAtURL:includingPropertiesForKeys:options:error: 方法枚举 bundleIDDir 目录。
 
 */
- (void)enumerateAllAtOnceAtURL:(NSURL *)enumerateURL {
    NSError *error;
    NSArray *properties = [NSArray arrayWithObjects:NSURLLocalizedNameKey, NSURLCreationDateKey, NSURLLocalizedTypeDescriptionKey, nil];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtURL:enumerateURL
                                   includingPropertiesForKeys:properties
                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                        error:&error];
    
    if (error) {
        NSLog(@"Couldn't enumerate directory. error:%@",error);
    }
    
    for (NSURL *url in contents) {
        NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:(-24*60*60)];
        
        // 1.获取项目的文件属性，使用 NSURLCreationDateKey 键提取文件创建日期
        NSDictionary *attributes = [fileManager attributesOfItemAtPath:url.path error:nil];
        NSDate *lastModificationDate = [attributes valueForKey:NSURLCreationDateKey];
        
        // 2.如果文件在 24 小时之内创建，输出文件路径到控制台
        if ([yesterday earlierDate:lastModificationDate] == yesterday) {
            NSLog(@"%@ was modified within the last 24 hours", url);
        }
    }
}
/*
 调用结果：
 file:///private/var/mobile/Containers/Data/Application/1EC6B210-819E-4834-AEC0-BE8FC6A46C74/Library/Application%20Support/gov.jsxzlss.HQLTableViewDemo/Data.backup/ was modified within the last 24 hours
 file:///private/var/mobile/Containers/Data/Application/1EC6B210-819E-4834-AEC0-BE8FC6A46C74/Library/Application%20Support/gov.jsxzlss.HQLTableViewDemo/Data/ was modified within the last 24 hours
 */

#pragma mark - 文件属性

// 获取并计算指定文件占用内存大小
- (void)getFileSize {
    NSFileManager *fileManager = [NSFileManager defaultManager];

    //1.构造文件路径
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"file.txt"];

    //获得文件的属性字典
    NSDictionary *fileAttribute = [fileManager attributesOfItemAtPath:filePath error:nil];
    NSLog(@"%@",fileAttribute);

    //获取文件大小
    NSNumber *fileSize = [fileAttribute objectForKey:@"NSFileSize"];
    long size = [fileSize longValue];
    NSLog(@"size = %ld",size);
}

// 获取文件夹中所有的文件，计算所有文件占用的内存大小
- (void)getAllFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];

    //1.构造路径
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"壁纸"];
        
    //2.获取文件夹中所有的子文件路径(路径是相对路径)
    NSArray *subPaths = [fileManager subpathsOfDirectoryAtPath:filePath error:nil];
        
    //3.遍历每一个子路径
    long sum = 0;
    for (NSString *subpath in subPaths) {
            
    //4.子路径与父路径拼接
    NSString *path = [filePath stringByAppendingPathComponent:subpath];
            
    //5.获取文件的属性，计算所有文件占用内存大小
    NSDictionary *fileAttribute = [fileManager attributesOfItemAtPath:path error:nil];
    
    // 通过键值访问文件的属性，获取文件大小
    NSNumber *filesize = fileAttribute[@"NSFileSize"];
    long size = [filesize longValue];
    sum += size;
    }
    //6.单位换算
    float result = sum / (1000*1000.0);
    NSLog(@"result = %.1f",result);
}


@end
