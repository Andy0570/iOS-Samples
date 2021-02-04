//
//  HQLSandBoxPathViewController.h
//  DataStorage
//
//  Created by Qilin Hu on 2020/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HQLSandBoxPathViewController : UIViewController

@end

NS_ASSUME_NONNULL_END

/**
 ## 1. 获取 NSString 路径
 
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
 */


/**
 ## 2. 获取 NSURL 路径
 
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
 */


/**
 链接：https://www.jianshu.com/p/73f346855c54
 
 ### MyApp.app
  
 这是应用程序的资源包。捆绑（Bundle）是一个目录（也可能是一个文件），它允许相关资源（如可执行代码、本地化资源、图片等）被组合在一起，在某些情况下可以当作一个单独文件看待。

 你不能向此目录写入文件。为防止篡改，在安装时会对捆绑包目录签名，向此文件写入内容会更改签名，导致 app 无法启动。但是，你可以读取该捆绑包内资源。

 iTunes 和 iCloud 不会备份该目录的内容。

 ### Documents (NSDocumentDirectory)
 此目录用来存储用户生成的内容。用户可以通过文件共享接触到该目录的内容，所以该目录应该只包含你希望向用户公开的内容。

 iTunes 和 iCloud 会备份该目录的内容。

 ### Library (NSLibraryDirectory)
 该顶级目录用于储存非用户数据文件，一般将文件放在几个标准子目录中。
 iOS 应用一般使用该目录的 Application Support、Preferences、Caches 子目录，你也可以自定义子目录。

 iTunes 和 iCloud 会备份除 Caches 目录外其他目录的内容。

 ### tmp (NSTemporaryDirectory())
 使用此目录用来存储不需要在应用程序启动之间保存的临时文件，app 应该在不需要这些文件时，主动删除这些文件。
 在 app 没有运行时，系统可能清空该目录的内容。

 iTunes 和 iCloud 不会备份该目录的内容。
 */
