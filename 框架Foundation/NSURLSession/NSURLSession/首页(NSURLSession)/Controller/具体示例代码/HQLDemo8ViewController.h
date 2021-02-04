//
//  HQLDemo8ViewController.h
//  NSURLSession
//
//  Created by Qilin Hu on 2020/4/23.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 NSURLSession 的使用
 iOS7-day-by-day Demo，演示 NSURLSessionDownloadTask 的使用，创建多种下载任务

 参考：
 <https://github.com/ScottLogic/iOS7-day-by-day/blob/master/01-nsurlsession/01-nsurlsession.md>
 <http://www.voidcn.com/article/p-vqslkieb-ben.html>
 <https://www.jianshu.com/p/78964aac72d5>
*/
@interface HQLDemo8ViewController : UIViewController

- (IBAction)startCancellable:(id)sender;  // 可撤销任务
- (IBAction)startResumable:(id)sender;    // 可恢复任务
- (IBAction)startBackground:(id)sender;   // 后台任务

- (IBAction)cancelCancellable:(id)sender; // 取消当前任务

@end

NS_ASSUME_NONNULL_END
