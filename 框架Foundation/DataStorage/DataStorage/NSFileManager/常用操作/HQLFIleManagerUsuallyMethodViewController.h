//
//  HQLFIleManagerUsuallyMethodViewController.h
//  DataStorage
//
//  Created by Qilin Hu on 2020/12/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// NSFileManager 的常见操作
/// 本节内容摘自：<https://nshipster.cn/nsfilemanager/>
@interface HQLFIleManagerUsuallyMethodViewController : UIViewController

@end

NS_ASSUME_NONNULL_END

/*
 通过 NSFileManager 的 -attributesOfItemAtPath:error: 和其它方法可以访问很多文件的属性
 
 // 获得文件的属性字典
 NSDictionary *fileAttribute = [fileManager attributesOfItemAtPath:filePath error:nil];
 
 // 通过键值访问文件的属性
 // 获取文件大小
 NSNumber *fileSize = [fileAttribute objectForKey:@"NSFileSize"];
 long size = [fileSize longValue];
 
 文件属性的键值：
 NSFileAppendOnly: 文件是否只读
 NSFileBusy: 文件是否繁忙
 NSFileCreationDate: 文件创建日期
 NSFileOwnerAccountName: 文件所有者的名字
 NSFileGroupOwnerAccountName: 文件所有组的名字
 NSFileDeviceIdentifier: 文件所在驱动器的标示符
 NSFileExtensionHidden: 文件后缀是否隐藏
 NSFileGroupOwnerAccountID: 文件所有组的 group ID
 NSFileHFSCreatorCode: 文件的 HFS 创建者的代码
 NSFileHFSTypeCode: 文件的 HFS 类型代码
 NSFileImmutable: 文件是否可以改变
 NSFileModificationDate: 文件修改日期
 NSFileOwnerAccountID: 文件所有者的 ID
 NSFilePosixPermissions: 文件的 Posix 权限
 NSFileReferenceCount: 文件的链接数量
 NSFileSize: 文件的字节
 NSFileSystemFileNumber: 文件在文件系统的文件数量
 NSFileType: 文件类型
 NSDirectoryEnumerationSkipsSubdirectoryDescendants: 浅层的枚举，不会枚举子目录
 NSDirectoryEnumerationSkipsPackageDescendants: 不会扫描 pakages 的内容
 NSDirectoryEnumerationSkipsHiddenFile: 不会扫描隐藏文件
 */
