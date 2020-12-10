每个 iOS 应用都有自己专属的应用沙盒（sandbox）。应用沙盒就是文件系统中的目录，但是 iOS 系统会将每个应用的沙盒目录与文件系统的其他部分隔离。应用只能访问各自的沙盒。

# 应用沙盒目录

![](https://tva1.sinaimg.cn/large/0081Kckwgy1glhq82lnzgj30lw07kmx5.jpg)

* 应用程序包（application bundle）
  包含应用可执行文件和所有资源文件，例如 NIB 文件和图像文件。它是只读目录。

* Doucments/ 目录
  存放应用运行时生成的并且需要保留的数据。iTunes 或 iCloud 会在同步设备时备份该目录。当设备发生故障时，可以从 iTunes 或 iCloud 恢复该目录中的文件。

* Library/Caches/ 目录

  存放应用运行时生成的并且需要保留的数据。与Documents/ 目录不同的是，iTunes 或 iCloud 不会在同步设备时备份该目录。不备份缓存数据的主要原因是相关数据的体积可能会很大，从而延长同步设备所需的时间。如果数据源是在别处（例如web服务器），就可以将得到的数据保存在 Library/Caches/ 目录。当用户需要恢复设备时，相关的应用只需要从数据源（例如web服务器）再次获取数据即可。

* Library/Preferences/ 目录
  存放所有的偏好设置，iOS的设置（Setting）应用也会在该目录中查找应用的设置信息。使用 `NSUserDefaults` 类，可以通过 Library/Preferences/ 目录中的某个特定文件以键值对形式保存数据。iTunes 或 iCloud 会在同步设备时备份该目录。

* tmp/ 目录
  存放应用运行时所需的临时数据。当某个应用没有运行时，iOS系统可能会清除该应用的 tmp/ 目录下的文件，但是为了节约用户设备空间，不能依赖这种自动清除机制，而是当应用不再需要使用 tmp/ 目录中的文件时，就及时手动删除这写文件。iTunes 或 iCloud 不会在同步设备时备份 tmp/ 目录。通过 `NSTemporaryDirectory` 函数可以得到应用沙盒中的 tmp/ 目录的全路径。

# 获取应用文件夹目录

## 1. 获取 NSString 路径

```objectivec
// 1.捆绑包目录
NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
// 资源文件夹目录
NSString *resourcePath = [[NSBundle mainBundle] resourcePath];

// 2.沙盒主目录
NSString *homeDir = NSHomeDirectory();

// 3.Documents 目录：NSDocumentDirectory
NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;

// 4.Library 目录：NSLibraryDirectory
NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;

// 5.Caches 目录：NSCachesDirectory
NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;

// 6.Temporary 目录：NSTemporaryDirectory
NSString *tmpPathA = NSTemporaryDirectory();
```

## 2. 获取 NSURL 路径

```objectivec
// 1.捆绑包目录
NSURL *bundleURL = [[NSBundle mainBundle] bundleURL];

// 2.沙盒主目录：NSApplicationDirectory
NSURL *applicationURL = [[NSFileManager defaultManager] URLsForDirectory:NSApplicationDirectory inDomains:NSUserDomainMask].firstObject;

// 3.Documents 目录：NSDocumentDirectory
NSURL *documentsURL = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;

// 4.Library 目录：NSLibraryDirectory
NSURL *libraryURL = [[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask].firstObject;

// 5.Caches 目录：NSCachesDirectory
NSURL *cachesURL = [[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask].firstObject;

// plist 文件路径
NSURL *bundleURL = [[NSBundle mainBundle] bundleURL];
NSURL *url = [bundleURL URLByAppendingPathComponent:@"mainTableViewTitleModel.plist"];
```

## 3. 文件路径追加方式

因为 Doucments、Library、tmp 目录都是在 Home 目录下，所以你也可以先获取 Home 目录，再通过文件路径追加的方式获取下一层目录：

```objectivec
NSString *homeDir = NSHomeDirectory(); 

NSString *documentsPath = [homeDir stringByAppendingString:@"/Documents"];   
NSString *documentsPath = [homeDir stringByAppendingPathComponent:@"Documents"]; //注意：不需要加‘/’
NSString *libraryPath = [homeDir stringByAppendingPathComponent:@"Library"];
```

这里只是提供一种思路，实际常见下不建议这么做，以免错误的操作（误删除原文件/拼接路径错误）导致的各种异常。

在程序中，为避免使用硬编码的路径名，应尽可能地使用方法和函数来获取当前目录路径名、用户主目录及临时文件目录。

## 4. 第三方框架便捷语法：YYKit

获取文档沙盒目录也可以使用 YYKit 框架中封装好的便捷语法，在 `UIApplication+YYAdd`类中定义成了相关的属性供使用：
```objectivec
/// "Documents" folder in this app's sandbox.
@property (nonatomic, readonly) NSURL *documentsURL;
@property (nonatomic, readonly) NSString *documentsPath;

/// "Caches" folder in this app's sandbox.
@property (nonatomic, readonly) NSURL *cachesURL;
@property (nonatomic, readonly) NSString *cachesPath;

/// "Library" folder in this app's sandbox.
@property (nonatomic, readonly) NSURL *libraryURL;
@property (nonatomic, readonly) NSString *libraryPath;

// 内部实现方法
// documents
- (NSURL *)documentsURL {
    return [[[NSFileManager defaultManager]
             URLsForDirectory:NSDocumentDirectory
             inDomains:NSUserDomainMask] lastObject];
}

- (NSString *)documentsPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

// caches
- (NSURL *)cachesURL {
    return [[[NSFileManager defaultManager]
             URLsForDirectory:NSCachesDirectory
             inDomains:NSUserDomainMask] lastObject];
}

- (NSString *)cachesPath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

// library
- (NSURL *)libraryURL {
    return [[[NSFileManager defaultManager]
             URLsForDirectory:NSLibraryDirectory
             inDomains:NSUserDomainMask] lastObject];
}

- (NSString *)libraryPath {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}
```

还有 JKCategories 框架：`NSFileManager+Paths.h` 也封装了便捷语法。



## Xcode7 模拟器应用沙盒查看

下面的方法可以查看【模拟器中的应用沙盒】在Mac中的位置：

参考：[ Mac10.11 Xcode7 模拟器应用沙盒查看（手动）  ](http://blog.csdn.net/belugaw/article/details/51018235)
1. 先查看模拟器 Identifier.
    Xcode ——Windows——Devices （或者快捷键 shift + cmd + 2），记住Identifier所对应的值。
    ![](https://tva1.sinaimg.cn/large/0081Kckwgy1glhqcnb9vpj30mm0hbdgt.jpg)

2. 打开Finder，shift + cmd + G 搜索路径
    路径：/Users/*用户名*/Library/Developer/CoreSimulator/Devices/查找到的模拟器的Identitfier值/data/Containers/Data/Application/BAB08A8E-914C-4552-B58E-3015436D3F0E（项目的id）/Library/Caches

  > Tips:如何查看隐藏文件夹？使用快捷键：cmd+shift+,

3. **po NSHomeDirectory()** 指令方法：
    在项目中的某处打一个断点，然后运行程序，在控制台窗口All Output中(lldb)后面输入"po NSHomeDirectory()"

### 模拟器在Mac中的位置：
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/



# 读写文件

##  NSString

### 将 NSString 对象写入文件

```objectivec
NSMutableString *str = [[NSMutableString alloc] init];
for (int i = 0; i < 10; i++) {
    [str appendString:@"Aaron is cool! \n"];
}

// 声明一个指向 NSError 对象的指针，但是不创建相应的对象
// 实际上，只有当发生错误时，才会由 writeToFile 创建相应的 NSError 对象
NSError *error;

// 将 NSError 指针通过引用传入 writeToFile:atomically:encoding:error: 方法
BOOL success = [str writeToFile:@"/tmp/cool.txt"
                     atomically:YES
                       encoding:NSUTF8StringEncoding
                          error:&error];

// 检查返回的布尔值，如果写入文件夹失败，就查询 NSError 对象并输出错误描述
if (success) {
     NSLog(@"done writing /tmp/cool.txt");
}else {
    NSLog(@"writing /tmp/cool.txt failed:%@",[error localizedDescription]);
}
```



### 通过 NSString 读取文件

```objectivec
NSError *readError;
NSString *readStr = [[NSString alloc]
                     initWithContentsOfFile:@"/etc/resolve.conf"
                                   encoding:NSASCIIStringEncoding
                                      error:&readError];

if (!readStr) {
    NSLog(@"read failed:%@",[error localizedDescription]);
}else {
    NSLog(@"resolve.conf looks like this: %@",readStr);
}
```



### 文件路径的追加

```objectivec
// 获取沙盒Home路径
NSString *homeDir = NSHomeDirectory(); 
NSString *documents = [homeDir stringByAppendingString:@"/Documents"];   
NSString *documents = [homeDir stringByAppendingPathComponent:@"Documents"]; //注意：不需要加‘/’
```



### NSString 处理路径

```objectivec
//演示路径 
NSString *path = @"/Users/apple/file.text";

// 1.获取路径的组成部分  结果: (“/”,”Users”, “apple”, “file.text”) 
NSArray *components = [path pathComponents];

// 2.路径的最后一个组成部分   结果: file.text
NSString *lastName = [path lastPathComponent]；

// 3.追加文件或目录  结果: /Users/apple/file.text/app.text
NSString *filePath = [path stringByAppendingPathComponent:@"app.text"];

// 4.删除最后部分的组成部分 结果: /Users/apple
NSString *filePath = [path stringByDeletingLastPathComponent];

// 5. 取路径最后部分的扩展名 结果: text
NSString *extName = [path pathExtension];

// 6. 追加扩展名   结果: /Users/apple/file.text.jpg
NSString *filePath = [path stringByAppendingPathExtension:@"jpg"];
```



> **文件路径**
> 简单来说就是我们不应该使用 ```NSString``` 来描述文件路径。对于 OS X 10.7 和 iOS 5，```NSURL``` 更便于使用，而且更有效率，它还能缓存文件系统的属性。

>再者，```NSURL``` 有八个方法来访问被称为 resource values 的东西。这些方法提供了一个稳定的接口，使我们可以用来获取和设置文件与目录的各种属性，例如本地化文件名（```NSURLLocalizedNameKey```）、文件大小（```NSURLFileSizeKey```），以及创建日期（```NSURLCreationDateKey```），等等。

>尤其是在遍历目录内容时，使用 ```-[NSFileManager enumeratorAtURL:includingPropertiesForKeys:options:errorHandler:]```，并传入一个**关键词（keys）**列表，然后用 ```-getResourceValue:forKey:error:``` 检索它们，能带来显著的性能提升。

下面是一个简短的例子展示了如何将它们组合在一起：

```objectivec
NSError *error = nil;
NSFileManager *fm = [[NSFileManager alloc] init];

// documentsURL
NSURL *documents = [fm URLForDirectory:NSDocumentationDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:&error];

// 构造枚举器
NSArray *properties = @[NSURLLocalizedNameKey, NSURLCreationDateKey];
NSDirectoryEnumerator *dirEnumerator = [fm enumeratorAtURL:documents
                                includingPropertiesForKeys:properties
                                                   options:0
                                              errorHandler:nil];

// 遍历 documents 文件目录
for (NSURL *fileURL in dirEnumerator) {
    NSString *name = nil;
    NSDate *creationDate = nil;
    if ([fileURL getResourceValue:&name forKey:NSURLLocalizedNameKey error:NULL] &&
        [fileURL getResourceValue:&creationDate forKey:NSURLCreationDateKey error:NULL])
    {
        NSLog(@"'%@' was created at %@", name, creationDate);
    }
}
```

我们把属性的键传给 `-enumeratorAtURL:... `方法中，在遍历目录内容时，这个方法能确保用非常高效的方式获取它们。在循环中，调用 `-getResourceValue:...` 能简单地从 `NSURL` 得到已缓存的值，而不用去访问文件系统。

### 路径类型转换

```objectivec
// 创建文件管理器
NSFileManager *fileManager = [NSFileManager defaultManager];

// 1. 创建 NSURL 类型的 documents 路径
NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    
// 1.1 NSURL ——> NSString
NSString *documentsPath = documentsURL.path;
    
// 1.2 NSURL ——> File Reference URL
NSURL *fileReferenceURL = documentsURL.fileReferenceURL;

// 2. 创建 NSString 类型的 documents 路径
NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;

// 2.1 NSString ——> NSURL
NSURL *documentsURL = [NSURL fileURLWithPath:documentsPath];
```


## NSData

* `NSData` 对象“代表”内存中的某块缓冲区，可以保存相应字节数的数据。
* `NSData` 是对数据的一种抽象。
* 任何数据都可以通过 `NSData` 来存储，`NSMutableData` 是可变的，继承于 `NSData`。


### 将 NSData 对象下载的数据写入文件

```objectivec
NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
NSString *str = @"https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/logo_white_fe6da1ec.png";
NSURL *url = [NSURL URLWithString:str];
NSURLSessionDataTask *task = [[NSURLSession sharedSession]
                              dataTaskWithURL:url
                              completionHandler:
  ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

    if (!data) {
        NSLog(@"fetch failed: %@",[error localizedDescription]);
    }
    NSLog(@"The file is %lu bytes",(unsigned long)[data length]);

    NSError *writtenError = nil;
    // NSData 对象会先将数据写入临时文件，成功后再移动至指定的路径
    BOOL written = [data writeToFile:@"/tmp/baidu.png"
                             options:NSDataWritingAtomic
                               error:&writtenError];
    if (!written) {
        NSLog(@"written failed: %@",[writtenError localizedDescription]);
    }
    NSLog(@"written success");

}];

//  NSURLSessionDataTask 在刚创建的时候处于暂停状态，需要手动调用resume方法恢复,让NSURLSessionDataTask 开始向服务器发送请求。
[task resume];
[runLoop run];
```



### 从文件读取数据并存入 NSData 对象

```objectivec
NSData *readData = [NSData dataWithContentsOfFile:@"tmp/baidu.png" options:NSDataReadingMappedIfSafe error:nil];
NSLog(@"The file read from the disk has %lu bytes",(unsigned long)[readData length]);
```



### 寻找特别目录

```objectivec
// 方法会返回包含指定的数组
NSArray *desktops = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
// 我知道用户只有一个桌面文件夹
NSString *desktopPath = desktops[0];
NSLog(@"desktop Path:%@",desktopPath);
```

目录枚举：

```objectivec
typedef NS_ENUM(NSUInteger, NSSearchPathDirectory) {
    NSApplicationDirectory = 1,             // supported applications (Applications)
    NSDemoApplicationDirectory,             // unsupported applications, demonstration versions (Demos)
    NSDeveloperApplicationDirectory,        // developer applications (Developer/Applications). DEPRECATED - there is no one single Developer directory.
    NSAdminApplicationDirectory,            // system and network administration applications (Administration)
    NSLibraryDirectory,                     // various documentation, support, and configuration files, resources (Library)
    NSDeveloperDirectory,                   // developer resources (Developer) DEPRECATED - there is no one single Developer directory.
    NSUserDirectory,                        // user home directories (Users)
    NSDocumentationDirectory,               // documentation (Documentation)
    NSDocumentDirectory,                    // documents (Documents)
    NSCoreServiceDirectory,                 // location of CoreServices directory (System/Library/CoreServices)
    NSAutosavedInformationDirectory NS_ENUM_AVAILABLE(10_6, 4_0) = 11,   // location of autosaved documents (Documents/Autosaved)
    NSDesktopDirectory = 12,                // location of user's desktop
    NSCachesDirectory = 13,                 // location of discardable cache files (Library/Caches)
    NSApplicationSupportDirectory = 14,     // location of application support files (plug-ins, etc) (Library/Application Support)
    NSDownloadsDirectory NS_ENUM_AVAILABLE(10_5, 2_0) = 15,              // location of the user's "Downloads" directory
    NSInputMethodsDirectory NS_ENUM_AVAILABLE(10_6, 4_0) = 16,           // input methods (Library/Input Methods)
    NSMoviesDirectory NS_ENUM_AVAILABLE(10_6, 4_0) = 17,                 // location of user's Movies directory (~/Movies)
    NSMusicDirectory NS_ENUM_AVAILABLE(10_6, 4_0) = 18,                  // location of user's Music directory (~/Music)
    NSPicturesDirectory NS_ENUM_AVAILABLE(10_6, 4_0) = 19,               // location of user's Pictures directory (~/Pictures)
    NSPrinterDescriptionDirectory NS_ENUM_AVAILABLE(10_6, 4_0) = 20,     // location of system's PPDs directory (Library/Printers/PPDs)
    NSSharedPublicDirectory NS_ENUM_AVAILABLE(10_6, 4_0) = 21,           // location of user's Public sharing directory (~/Public)
    NSPreferencePanesDirectory NS_ENUM_AVAILABLE(10_6, 4_0) = 22,        // location of the PreferencePanes directory for use with System Preferences (Library/PreferencePanes)
    NSApplicationScriptsDirectory NS_ENUM_AVAILABLE(10_8, NA) = 23,      // location of the user scripts folder for the calling application (~/Library/Application Scripts/code-signing-id)
    NSItemReplacementDirectory NS_ENUM_AVAILABLE(10_6, 4_0) = 99,	    // For use with NSFileManager's URLForDirectory:inDomain:appropriateForURL:create:error:
    NSAllApplicationsDirectory = 100,       // all directories where applications can occur
    NSAllLibrariesDirectory = 101,          // all directories where resources can occur
    NSTrashDirectory NS_ENUM_AVAILABLE(10_8, NA) = 102                   // location of Trash directory

};
```



### NSString <—> NSData
```objectivec
NSString *string1 = @"NSData是对数据的一种抽象";
// NSString -> NSData
NSData *data = [string1 dataUsingEncoding:NSUTF8StringEncoding];

// NSData -> NSString
NSString *string2 =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
```



## NSFileManager

`NSFileManager` 主要对文件进行管理，主要有如下功能：创建、复制、删除、剪切等。常见的 `NSFileManager` 文件方法：

| 方法                                                         | 描述                                   |
| ------------------------------------------------------------ | -------------------------------------- |
| - (NSData *)contentsAtPath:                                  | 从一个文件中读取数据                   |
| - (BOOL)createFileAtPath: contents: attributes:              | 向一个文件写入数据                     |
| - (BOOL)copyItemAtPath: toPath: error:                       | 复制文件                               |
| - (BOOL)moveItemAtPath: toPath: error:                       | 重命名或移动一个文件                   |
| - (BOOL)linkItemAtPath: toPath: error:                       | 在指定的路径上创建项目之间的硬连接     |
| - (BOOL)removeItemAtPath: error:                             | 删除文件                               |
| - (BOOL)contentsEqualAtPath: andPath:                        | 比较这两个文件的内容                   |
| - (BOOL)fileExistsAtPath:                                    | 测试文件是否存在                       |
| - (BOOL)isReadableFileAtPath:                                | 测试文件是否存在，并且是否能执行读操作 |
| - (BOOL)isWritableFileAtPath:                                | 测试文件是否存在，并且是否能执行写操作 |
| - (NSDictionary *)attributesOfItemAtPath: error:             | 获取文件的属性                         |
| - (BOOL)setAttributes:(NSDictionary *)attributes ofItemAtPath: error | 更改文件的属性                         |

### 创建文件
```objectivec
//创建 NSFileManager 对象
NSFileManager *fileManager = [[NSFileManager alloc] init];    
NSFileManager *fileManager = [NSFileManager defaultManager];  //同上
        
//1.构造文件的路径
NSString *homePath = NSHomeDirectory();
NSString *filePath = [homePath stringByAppendingPathComponent:@"file.txt"];

//2.构造数据
NSString *string = @"Hello World!";
    
//3.将字符串中的文本数据存储到Data对象中
NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];

//4.创建文件
//createFileAtPath 创建文件，如果文件已经存在，那么新创建的文件会将原文件覆盖
BOOL success = [fileManager createFileAtPath:filePath //路径
                                        contents:data //数据
                                      attributes:nil]; //属性
if (success) {
        NSLog(@"create file success");
    }
```

### 创建并返回文件夹列表

```objectivec
// 创建并返回文件夹路径：../Library/Private Documents/
+ (NSString *)getPrivateDocsDir {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Private Documents"];

    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    
    return documentsDirectory;
}

// 返回数组：存放的是 Scary bug 文件夹名称列表：../Library/Private Documents/#.scarybug
+ (NSMutableArray *)loadScaryBugDocs {
    
    // Get private docs dir
    NSString *documentsDirectiory = [HQLScaryBugDatabase getPrivateDocsDir];
    NSLog(@"Loading bugs from %@",documentsDirectiory);
    
    // Get contents of documents directiory 获取文档目录列表
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectiory error:&error];
    if (!files) {
        NSLog(@"Error reading contents of documents directory:%@",error.localizedDescription);
        return nil;
    }
    
    // Create HQLScaryBugDoc for each file
    // Documents/Private Documents/#.scarybug
    NSMutableArray *retval = [NSMutableArray arrayWithCapacity:files.count];
    for (NSString *file in files) {
        // 判断文件扩展名是否相同
        if ([file.pathExtension compare:@"scarybug" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSString *fullPath = [documentsDirectiory stringByAppendingPathComponent:file];
            HQLScaryBugDoc *doc = [[HQLScaryBugDoc alloc] initWithDocPath:fullPath];
            [retval addObject:doc];
        }
    }
    return retval;
}
```


### 创建文件夹

```objectivec
[fileManager createDirectoryAtPath:(NSString *) withIntermediateDirectories:(BOOL) attributes:(NSDictionary *) error:(NSError *__autoreleasing *)] 
```


### 读取文件

```objectivec
//创建 NSFileManager 对象
NSFileManager *fileManager = [NSFileManager defaultManager]; 

//构造文件的路径
NSString *homePath = NSHomeDirectory();
NSString *filePath = [homePath stringByAppendingPathComponent:@"file.txt"];

//根据路径读取文件
NSData *fileData = [fileManager contentsAtPath:filePath];

//将NSData转NSString
NSString *content = [[NSString alloc] initWithData:fileData
                             encoding:NSUTF8StringEncoding];
```



### 移动，剪切文件


```objectivec
NSFileManager *fileManager = [NSFileManager defaultManager];

//构造路径
//文件的原路径
NSString *srcPath = [NSHomeDirectory() stringByAppendingPathComponent:@"file.txt"];     
//文件剪切之后的路径
NSString *toPath = [NSHomeDirectory() stringByAppendingPathComponent:@"temp/file.txt"];
    
//注意：如果目标路径已经存在此文件，那么会导致操作失败
NSError *error = nil;
BOOL success = [fileManager moveItemAtPath:srcPath
                                        toPath:toPath
                                         error:&error];
if (!success) {
	NSLog(@"剪切失败,%@",error);
    }
```



### 复制文件      


```objectivec
NSFileManager *fileManager = [NSFileManager defaultManager];

//1.构造路径
//文件的原路径
NSString *srcPath = [NSHomeDirectory() stringByAppendingPathComponent:@"temp/file.txt"];    
//文件复制之后的路径
NSString *toPath = [NSHomeDirectory() stringByAppendingPathComponent:@"file.txt"];
    
BOOL success = [fileManager copyItemAtPath:srcPath
                                        toPath:toPath
                                         error:nil];
//注意：如果目标路径已经存在此文件，那么会导致操作失败
if (!success) {
        NSLog(@"复制失败");
    }
```



### 删除文件


```objectivec
NSFileManager *fileManager = [NSFileManager defaultManager];

//1.构造文件路径
NSString *toPath = [NSHomeDirectory() stringByAppendingPathComponent:@"file.txt"];
    
//2.判断文件是否存在
BOOL exist = [fileManager fileExistsAtPath:toPath];
if (exist) {
//3.删除文件
	if ([fileManager removeItemAtPath:toPath error:nil]) {
            NSLog(@"删除文件成功");
		}
	}
```



### 删除文件夹

删除文件或文件夹之前，务必判断文件是否存在，否则会造成过度释放。

```objectivec
NSString *dir = [NSHomeDirectory() stringByAppendingPathComponent:@"temp"];
[fileManager removeItemAtPath:dir error:nil];
```



### 文件属性	


```objectivec
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
```



### 	获取文件夹中所有的文件


```objectivec
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
        
NSNumber *filesize = fileAttribute[@"NSFileSize"];
long size = [filesize longValue];
sum += size;
}
//6.单位换算
float result = sum / (1000*1000.0);
NSLog(@"result = %.1f",result);
```



## NSArray 

### 写文件

* 数组、字典、字符串、NSData都是容纳数据的,他们都有一个writeToFile方法, 将数据写入文件。
* 数组、字典写入的文件叫属性列表 (plist) 文件,可以用Xcode打开编辑。
* 数组只能将如下数据类型写入文件,如果包含其他对象,将写入失败。NSNumber、NSString、NSData、NSDate、NSArray、NSDictionary



```objectivec
// 需要保存的数组
NSArray *array = @[@"1", @"2", @"3", @"4", @"5",];

// 构建路径
NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
NSString *document = [pathArray lastObject];
NSString *documentPath = [document stringByAppendingPathComponent:@"city.plist"];

// 判断文件夹是否存在
if (![[NSFileManager defaultManager] fileExistsAtPath:document]) {
    [[NSFileManager defaultManager] createDirectoryAtPath:documentPath withIntermediateDirectories:YES attributes:nil error:nil];
}
NSLog(@"path:%@",documentPath);

// 将数组保存到 Documents 目录下，文件名为 city.plist
BOOL isSucceed = [array writeToFile:documentPath atomically:YES];
NSLog(@"isSucceed = %@",isSucceed ? @"YES" : @"NO");
```


### 读文件

```objectivec
//数组读文件
//1.通过alloc创建，并读入文件数据
NSArray *alloc = [[NSArray alloc] initWithContentsOfFile:path]; 
 	
//2.通过类方法创建，并读入文件数据
MSArray *array = [NSArray arrayWithContentsofFile:path];
```

## 参考

* [Apple：File System Programming Guide](https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40010672-CH1-SW1)
* [nshipster：NSFileManager](https://nshipster.cn/nsfilemanager/)
* [简书：使用 NSFileManager 管理文件系统 @pro648](https://www.jianshu.com/p/73f346855c54)