//
//  HQLDemo2ViewController.h
//  NSURLSession
//
//  Created by Qilin Hu on 2020/4/23.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 创建 NSURLSessionDownloadTask 下载任务
 
 还有一个更完整的示例参考：HQLDemo8ViewController
 
 
 ## dataTask 和 downloadTask 下载对比
 
 ### NSURLSessionDataTask
 
 1. 下载文件可以实现离线断点续传，但是代码相对复杂。
 
 ### NSURLSessionDownloadTask
 
 1. 下载文件可以实现断点下载，但不能实现离线断点续传；
 2. 内部已经完成了一边接收数据一边写入沙盒的操作；
 3. 解决了下载大文件时的内存飙升问题：
 
 NSURLSessionDownloadTask 下载任务时，会默认下载到沙盒中的 tem 文件夹中，不会出现内存暴涨的情况，
 在下载完成后会将 tem 中的临时文件删除。

 */
@interface HQLDemo2ViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
