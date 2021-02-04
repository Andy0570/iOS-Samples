//
//  HQLFileBasicUsageViewController.h
//  DataStorage
//
//  Created by Qilin Hu on 2020/12/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 使用 NSFileManager 复制、移动、删除文件和目录
/// 参考：https://www.jianshu.com/p/73f346855c54
@interface HQLFileBasicUsageViewController : UIViewController

@end

NS_ASSUME_NONNULL_END

/**
 `NSFileManager` 主要对文件进行管理，主要有如下功能：创建、复制、删除、剪切等。常见的 `NSFileManager` 文件方法：

 | 方法                                                         | 描述                                 |
 | ------------------------------------------------------------ | ----------------------------------- |
 | - (NSData *)contentsAtPath:                                  | 从一个文件中读取数据                   |
 | - (BOOL)createFileAtPath: contents: attributes:              | 向一个文件写入数据                     |
 | - (BOOL)copyItemAtPath: toPath: error:                       | 复制文件                             |
 | - (BOOL)moveItemAtPath: toPath: error:                       | 重命名或移动一个文件                   |
 | - (BOOL)linkItemAtPath: toPath: error:                       | 在指定的路径上创建项目之间的硬连接       |
 | - (BOOL)removeItemAtPath: error:                             | 删除文件                             |
 | - (BOOL)contentsEqualAtPath: andPath:                        | 比较这两个文件的内容                   |
 | - (BOOL)fileExistsAtPath:                                    | 测试文件是否存在                       |
 | - (BOOL)isReadableFileAtPath:                                | 测试文件是否存在，并且是否能执行读操作     |
 | - (BOOL)isWritableFileAtPath:                                | 测试文件是否存在，并且是否能执行写操作     |
 | - (NSDictionary *)attributesOfItemAtPath: error:             | 获取文件的属性                         |
 | - (BOOL)setAttributes:(NSDictionary *)attributes ofItemAtPath: error | 更改文件的属性                 |
 */
